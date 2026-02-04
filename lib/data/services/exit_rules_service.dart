import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../repositories/app_repository.dart';
import '../../core/utils/financial_calculations.dart';

class ExitRulesService {
  final AppRepository _repository;

  ExitRulesService(this._repository);

  /// Evaluate all active exit rules against current property metrics
  Future<List<ExitRuleAlert>> evaluateAllRules() async {
    final alerts = <ExitRuleAlert>[];
    final rules = await _repository.getAllExitRules();
    
    // Group rules by asset to minimize DB queries
    final rulesByAsset = <String, List<PropertyExitRule>>{};
    for (final rule in rules) {
      if (!rulesByAsset.containsKey(rule.assetId)) {
        rulesByAsset[rule.assetId] = [];
      }
      rulesByAsset[rule.assetId]!.add(rule);
    }

    for (final assetId in rulesByAsset.keys) {
      final assetAlerts = await _evaluateRulesForAsset(assetId, rulesByAsset[assetId]!);
      alerts.addAll(assetAlerts);
    }

    return alerts;
  }

  /// Evaluate rules for a specific asset
  Future<List<ExitRuleAlert>> _evaluateRulesForAsset(String assetId, List<PropertyExitRule> rules) async {
    final alerts = <ExitRuleAlert>[];
    final asset = await _repository.getAsset(assetId);
    if (asset == null) return [];

    // Fetch necessary data for calculations
    final income = await _repository.getRentalIncomeForAsset(assetId);
    final expenses = await _repository.getPropertyExpensesForAsset(assetId);
    
    // Calculate metrics
    // Note: This is a simplified calculation. Real-world would need full cashflow history.
    // We'll estimate based on current value vs purchase price + net income
    
    final currentEquity = asset.currentValue - (asset.associatedLiabilityId != null ? 
        (await _repository.getLiability(asset.associatedLiabilityId!))?.outstandingAmount ?? 0 : 0);
        
    final equityPercentage = (currentEquity / asset.currentValue) * 100;
    
    final totalProfit = (asset.currentValue - asset.purchasePrice) + 
        (income.fold(0.0, (sum, i) => sum + i.amount)) - 
        (expenses.fold(0.0, (sum, e) => sum + e.amount));
        
    final profitPercentage = (totalProfit / asset.purchasePrice) * 100;
    
    // Approximate IRR for now (simplified as (Profit%) / Years)
    final holdingPeriodDays = DateTime.now().difference(asset.purchaseDate).inDays;
    final holdingPeriodYears = holdingPeriodDays / 365.0;
    final approxIRR = holdingPeriodYears > 0 ? (profitPercentage / holdingPeriodYears) : 0.0;

    for (final rule in rules) {
      bool isTriggered = false;
      String message = '';
      double currentValue = 0;

      switch (rule.ruleType) {
        case 'irr_threshold':
          currentValue = approxIRR;
          if (approxIRR >= rule.thresholdValue) {
            isTriggered = true;
            message = 'Target IRR of ${rule.thresholdValue}% reached (Current: ${approxIRR.toStringAsFixed(1)}%)';
          }
          break;
          
        case 'equity_threshold':
          currentValue = equityPercentage;
          if (equityPercentage >= rule.thresholdValue) {
            isTriggered = true;
            message = 'Target Equity of ${rule.thresholdValue}% reached (Current: ${equityPercentage.toStringAsFixed(1)}%)';
          }
          break;
          
        case 'profit_threshold':
          currentValue = totalProfit;
          if (totalProfit >= rule.thresholdValue) {
            isTriggered = true;
            message = 'Target Profit of ${rule.thresholdValue} reached (Current: ${totalProfit.toStringAsFixed(0)})';
          }
          break;
          
        case 'holding_period':
          currentValue = holdingPeriodYears;
          if (holdingPeriodYears >= rule.thresholdValue) {
            isTriggered = true;
            message = 'Target Holding Period of ${rule.thresholdValue} years reached';
          }
          break;
      }

      if (isTriggered) {
        alerts.add(ExitRuleAlert(
          ruleId: rule.id,
          assetName: asset.name,
          message: message,
          triggeredAt: DateTime.now(),
        ));
        
        // Update rule state in DB
        await _repository.updateExitRule(
          rule.id, 
          PropertyExitRulesCompanion(
            isTriggered: const drift.Value(true), 
            lastCheckedAt: drift.Value(DateTime.now())
          )
        );
      }
    }

    return alerts;
  }
}

class ExitRuleAlert {
  final String ruleId;
  final String assetName;
  final String message;
  final DateTime triggeredAt;

  ExitRuleAlert({
    required this.ruleId,
    required this.assetName,
    required this.message,
    required this.triggeredAt,
  });
}
