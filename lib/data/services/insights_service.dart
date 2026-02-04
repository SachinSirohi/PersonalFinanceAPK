import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import '../repositories/app_repository.dart';
import '../../core/utils/financial_calculations.dart';

class InsightsService {
  final AppRepository _repository;

  InsightsService(this._repository);

  /// Generate proactive insights based on current financial data
  Future<List<FinancialInsight>> generateInsights() async {
    final insights = <FinancialInsight>[];
    
    // 1. Check for Spending Spikes
    final spendingInsights = await _checkSpendingSpikes();
    insights.addAll(spendingInsights);
    
    // 2. Check Emergency Fund Health
    final emergencyInsight = await _checkEmergencyFund();
    if (emergencyInsight != null) insights.add(emergencyInsight);
    
    // 3. Check Goal Progress
    final goalInsights = await _checkGoalProgress();
    insights.addAll(goalInsights);
    
    // 4. Check Budget Health
    final budgetInsights = await _checkBudgetHealth();
    insights.addAll(budgetInsights);

    // Save insights to DB
    for (final insight in insights) {
      await _repository.insertInsight(FinancialInsightsCompanion(
        id: drift.Value(insight.id),
        type: drift.Value(insight.type),
        message: drift.Value(insight.message),
        severity: drift.Value(insight.severity),
        generatedAt: drift.Value(insight.generatedAt),
        isDismissed: const drift.Value(false),
      ));
    }

    return insights;
  }

  Future<List<FinancialInsight>> _checkSpendingSpikes() async {
    final insights = <FinancialInsight>[];
    final now = DateTime.now();
    final currentMonthExpenses = await _repository.getTotalExpensesByMonth(now.year, now.month);
    
    // Compare with average of last 3 months
    double last3MonthsTotal = 0;
    int count = 0;
    for (int i = 1; i <= 3; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final expenses = await _repository.getTotalExpensesByMonth(date.year, date.month);
      if (expenses > 0) {
        last3MonthsTotal += expenses;
        count++;
      }
    }
    
    if (count > 0 && currentMonthExpenses > 0) {
      final avgExpenses = last3MonthsTotal / count;
      if (currentMonthExpenses > avgExpenses * 1.25) { // 25% higher
        final pctIncrease = ((currentMonthExpenses - avgExpenses) / avgExpenses * 100).toStringAsFixed(0);
        insights.add(FinancialInsight(
          id: const Uuid().v4(),
          type: 'spending_spike',
          message: 'Spending Alert: Your expenses are $pctIncrease% higher than average this month.',
          severity: 'warning',
          generatedAt: DateTime.now(),
          isDismissed: false,
        ));
      }
    }
    
    return insights;
  }

  Future<FinancialInsight?> _checkEmergencyFund() async {
    final months = await _repository.getEmergencyFundMonths();
    if (months < 3) {
      return FinancialInsight(
        id: const Uuid().v4(),
        type: 'emergency_fund',
        message: 'Your emergency fund covers only $months months. Aim for at least 6 months.',
        severity: 'critical',
        generatedAt: DateTime.now(),
        isDismissed: false,
      );
    }
    return null;
  }

  Future<List<FinancialInsight>> _checkGoalProgress() async {
    final insights = <FinancialInsight>[];
    final goals = await _repository.getAllGoals();
    final activeGoals = goals.where((g) => g.status == 'active');
    
    for (final goal in activeGoals) {
      // Simplified check: Just see if progress < 50% for goals ending in < 1 year
      final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;
      if (daysRemaining > 0 && daysRemaining < 365) {
        // Calculate progress (this logic would need to be in repository or here)
        // For now, skipping complex calculation to keep it simple
      }
    }
    return insights;
  }
  
  Future<List<FinancialInsight>> _checkBudgetHealth() async {
    final insights = <FinancialInsight>[];
    final alerts = await _repository.checkBudgetThresholds();
    
    for (final alert in alerts) {
      final pct = alert['percentUsed'] as double;
      if (pct >= 100) {
        insights.add(FinancialInsight(
          id: const Uuid().v4(),
          type: 'budget_overrun',
          message: 'Budget Exceeded: You have spent ${(pct).toStringAsFixed(0)}% of your ${alert['categoryName']} budget.',
          severity: 'warning',
          generatedAt: DateTime.now(),
          isDismissed: false,
        ));
      }
    }
    return insights;
  }
}


