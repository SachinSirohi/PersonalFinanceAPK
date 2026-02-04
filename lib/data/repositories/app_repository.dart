import 'package:drift/drift.dart';
import '../database/database.dart';

/// Repository for all database operations
class AppRepository {
  final AppDatabase _db;
  
  // Singleton pattern
  static AppRepository? _instance;
  static AppDatabase? _database;
  
  AppRepository._(this._db);
  
  static Future<AppRepository> getInstance() async {
    if (_instance == null) {
      _database = AppDatabase();
      _instance = AppRepository._(_database!);
    }
    return _instance!;
  }
  
  /// Factory constructor for use with specific database instance
  factory AppRepository.withDatabase(AppDatabase db) => AppRepository._(db);
  
  static AppDatabase? get database => _database;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CURRENCIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Currency>> getAllCurrencies() => _db.select(_db.currencies).get();
  
  Future<Currency?> getCurrency(String code) => 
    (_db.select(_db.currencies)..where((c) => c.code.equals(code)))
      .getSingleOrNull();
  
  Future<void> updateExchangeRate(String code, double rate) =>
    (_db.update(_db.currencies)..where((c) => c.code.equals(code)))
      .write(CurrenciesCompanion(rateToBase: Value(rate), lastUpdated: Value(DateTime.now())));
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Account>> getAllAccounts() => _db.select(_db.accounts).get();
  
  Stream<List<Account>> watchAllAccounts() => _db.select(_db.accounts).watch();
  
  Future<Account?> getAccount(String id) =>
    (_db.select(_db.accounts)..where((a) => a.id.equals(id))).getSingleOrNull();
  
  Future<int> insertAccount(AccountsCompanion account) =>
    _db.into(_db.accounts).insert(account);
  
  Future<void> updateAccount(String id, AccountsCompanion account) =>
    (_db.update(_db.accounts)..where((a) => a.id.equals(id))).write(account);
  
  Future<void> deleteAccount(String id) =>
    (_db.delete(_db.accounts)..where((a) => a.id.equals(id))).go();
  
  Future<double> getTotalAccountsBalance(String currencyCode) async {
    final accounts = await (_db.select(_db.accounts)
      ..where((a) => a.currencyCode.equals(currencyCode))).get();
    double total = 0.0;
    for (final a in accounts) {
      total += a.balance;
    }
    return total;
  }
  
  Future<double> getTotalAccountBalance() async {
    final accounts = await getAllAccounts();
    double total = 0.0;
    for (final a in accounts) {
      total += a.balance;
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Category>> getAllCategories() => _db.select(_db.categories).get();
  
  Future<List<Category>> getCategoriesByType(String type) =>
    (_db.select(_db.categories)..where((c) => c.budgetType.equals(type))).get();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Transaction>> getAllTransactions() =>
    (_db.select(_db.transactions)..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])).get();
  
  Stream<List<Transaction>> watchAllTransactions() =>
    (_db.select(_db.transactions)..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])).watch();
  
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) =>
    (_db.select(_db.transactions)
      ..where((t) => t.transactionDate.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])).get();
  
  Future<List<Transaction>> getTransactionsByCategory(String categoryId) =>
    (_db.select(_db.transactions)
      ..where((t) => t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])).get();
  
  Future<int> insertTransaction(TransactionsCompanion transaction) =>
    _db.into(_db.transactions).insert(transaction);
  
  Future<void> updateTransaction(String id, TransactionsCompanion transaction) =>
    (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(transaction);
  
  Future<void> deleteTransaction(String id) =>
    (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  
  Future<double> getTotalExpensesByMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);
    final transactions = await (_db.select(_db.transactions)
      ..where((t) => t.transactionDate.isBetweenValues(start, end))
      ..where((t) => t.type.equals('expense'))).get();
    double total = 0.0;
    for (final t in transactions) {
      total += t.amountBase;
    }
    return total;
  }
  
  Future<double> getTotalIncomeByMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);
    final transactions = await (_db.select(_db.transactions)
      ..where((t) => t.transactionDate.isBetweenValues(start, end))
      ..where((t) => t.type.equals('income'))).get();
    double total = 0.0;
    for (final t in transactions) {
      total += t.amountBase;
    }
    return total;
  }
  
  Future<Map<String, double>> getExpensesByCategory(DateTime start, DateTime end) async {
    final transactions = await (_db.select(_db.transactions)
      ..where((t) => t.transactionDate.isBetweenValues(start, end))
      ..where((t) => t.type.equals('expense'))).get();
    
    final categories = await getAllCategories();
    final categoryMap = {for (var c in categories) c.id: c.name};
    
    final result = <String, double>{};
    for (var t in transactions) {
      final catName = categoryMap[t.categoryId] ?? 'Uncategorized';
      result[catName] = (result[catName] ?? 0) + t.amountBase;
    }
    return result;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ASSETS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Asset>> getAllAssets() => _db.select(_db.assets).get();
  
  Stream<List<Asset>> watchAllAssets() => _db.select(_db.assets).watch();
  
  Future<List<Asset>> getAssetsByType(String type) =>
    (_db.select(_db.assets)..where((a) => a.type.equals(type))).get();
  
  Future<int> insertAsset(AssetsCompanion asset) =>
    _db.into(_db.assets).insert(asset);
  
  Future<void> updateAsset(String id, AssetsCompanion asset) =>
    (_db.update(_db.assets)..where((a) => a.id.equals(id))).write(asset);
  
  Future<void> deleteAsset(String id) =>
    (_db.delete(_db.assets)..where((a) => a.id.equals(id))).go();
  
  Future<double> getTotalAssetValue() async {
    final assets = await getAllAssets();
    double total = 0.0;
    for (final a in assets) {
      total += a.currentValue;
    }
    return total;
  }
  
  Future<double> getLiquidAssetValue() async {
    final assets = await (_db.select(_db.assets)
      ..where((a) => a.isLiquid.equals(true))).get();
    double total = 0.0;
    for (final a in assets) {
      total += a.currentValue;
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GOALS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Goal>> getAllGoals() => _db.select(_db.goals).get();
  
  Stream<List<Goal>> watchAllGoals() => _db.select(_db.goals).watch();
  
  Future<int> insertGoal(GoalsCompanion goal) =>
    _db.into(_db.goals).insert(goal);
  
  Future<void> updateGoal(String id, GoalsCompanion goal) =>
    (_db.update(_db.goals)..where((g) => g.id.equals(id))).write(goal);
  
  Future<void> deleteGoal(String id) =>
    (_db.delete(_db.goals)..where((g) => g.id.equals(id))).go();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BUDGETS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Budget>> getAllBudgets() => _db.select(_db.budgets).get();
  
  Future<int> insertBudget(BudgetsCompanion budget) =>
    _db.into(_db.budgets).insert(budget);
  
  Future<void> updateBudget(String id, BudgetsCompanion budget) =>
    (_db.update(_db.budgets)..where((b) => b.id.equals(id))).write(budget);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // AGGREGATED DATA
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate total net worth (assets - liabilities)
  Future<double> getNetWorth() async {
    final totalAssets = await getTotalAssetValue();
    final accounts = await getAllAccounts();
    final totalAccounts = accounts.fold(0.0, (sum, a) => sum + a.balance);
    return totalAssets + totalAccounts;
  }
  
  /// Get monthly expenses for the last N months
  Future<List<double>> getMonthlyExpenses(int months) async {
    final result = <double>[];
    final now = DateTime.now();
    
    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final expense = await getTotalExpensesByMonth(date.year, date.month);
      result.add(expense);
    }
    return result;
  }
  
  /// Get average monthly expenses
  Future<double> getAverageMonthlyExpenses({int months = 6}) async {
    final expenses = await getMonthlyExpenses(months);
    if (expenses.isEmpty) return 0;
    return expenses.reduce((a, b) => a + b) / expenses.length;
  }
  
  /// Calculate emergency fund months (liquid assets / avg monthly expenses)
  Future<int> getEmergencyFundMonths() async {
    final liquid = await getLiquidAssetValue();
    final accounts = await getAllAccounts();
    final totalLiquid = liquid + accounts.fold(0.0, (sum, a) => sum + a.balance);
    final avgExpense = await getAverageMonthlyExpenses();
    if (avgExpense <= 0) return 0;
    return (totalLiquid / avgExpense).floor();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LIABILITIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Liability>> getAllLiabilities() => _db.select(_db.liabilities).get();
  
  Stream<List<Liability>> watchAllLiabilities() => _db.select(_db.liabilities).watch();
  
  Future<List<Liability>> getActiveLiabilities() =>
    (_db.select(_db.liabilities)..where((l) => l.isActive.equals(true))).get();
  
  Future<void> insertLiability(LiabilitiesCompanion liability) =>
    _db.into(_db.liabilities).insert(liability);
  
  Future<void> updateLiability(String id, LiabilitiesCompanion liability) =>
    (_db.update(_db.liabilities)..where((l) => l.id.equals(id))).write(liability);
  
  Future<void> deleteLiability(String id) =>
    (_db.delete(_db.liabilities)..where((l) => l.id.equals(id))).go();
  
  Future<double> getTotalLiabilities() async {
    final liabilities = await getActiveLiabilities();
    double total = 0.0;
    for (final l in liabilities) {
      total += l.outstandingAmount;
    }
    return total;
  }
  
  Future<double> getTotalMonthlyEMI() async {
    final liabilities = await getActiveLiabilities();
    double total = 0.0;
    for (final l in liabilities) {
      total += l.emi;
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SIP RECORDS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<SipRecord>> getAllSipRecords() => _db.select(_db.sipRecords).get();
  
  Stream<List<SipRecord>> watchAllSips() => _db.select(_db.sipRecords).watch();
  
  Future<List<SipRecord>> getActiveSips() =>
    (_db.select(_db.sipRecords)..where((s) => s.isActive.equals(true))).get();
  
  Future<List<SipRecord>> getSipsByGoal(String goalId) =>
    (_db.select(_db.sipRecords)..where((s) => s.goalId.equals(goalId))).get();
  
  Future<void> insertSipRecord(SipRecordsCompanion sip) =>
    _db.into(_db.sipRecords).insert(sip);
  
  Future<void> updateSipRecord(String id, SipRecordsCompanion sip) =>
    (_db.update(_db.sipRecords)..where((s) => s.id.equals(id))).write(sip);
  
  Future<void> deleteSipRecord(String id) =>
    (_db.delete(_db.sipRecords)..where((s) => s.id.equals(id))).go();
  
  Future<double> getTotalMonthlySip() async {
    final sips = await getActiveSips();
    double total = 0.0;
    for (final s in sips) {
      total += s.amount;
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIVIDENDS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Dividend>> getAllDividends() => _db.select(_db.dividends).get();
  
  Future<List<Dividend>> getDividendsByAsset(String assetId) =>
    (_db.select(_db.dividends)..where((d) => d.assetId.equals(assetId))).get();
  
  Future<List<Dividend>> getDividendsByYear(int year) =>
    (_db.select(_db.dividends)
      ..where((d) => d.paymentDate.isBetweenValues(
        DateTime(year, 1, 1),
        DateTime(year, 12, 31),
      ))).get();
  
  Future<void> insertDividend(DividendsCompanion dividend) =>
    _db.into(_db.dividends).insert(dividend);

  Future<void> updateDividend(String id, DividendsCompanion dividend) =>
    (_db.update(_db.dividends)..where((d) => d.id.equals(id))).write(dividend);
  
  Future<void> deleteDividend(String id) =>
    (_db.delete(_db.dividends)..where((d) => d.id.equals(id))).go();
  
  Future<double> getTotalDividendsByYear(int year) async {
    final dividends = await getDividendsByYear(year);
    double total = 0.0;
    for (final d in dividends) {
      total += d.amount;
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PROPERTY EXPENSES
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<PropertyExpense>> getPropertyExpenses(String assetId) =>
    (_db.select(_db.propertyExpenses)..where((p) => p.assetId.equals(assetId))).get();
  
  Future<List<PropertyExpense>> getPropertyExpensesByDateRange(String assetId, DateTime start, DateTime end) =>
    (_db.select(_db.propertyExpenses)
      ..where((p) => p.assetId.equals(assetId))
      ..where((p) => p.expenseDate.isBetweenValues(start, end))).get();
  
  Future<void> insertPropertyExpense(PropertyExpensesCompanion expense) =>
    _db.into(_db.propertyExpenses).insert(expense);
  
  Future<void> deletePropertyExpense(String id) =>
    (_db.delete(_db.propertyExpenses)..where((p) => p.id.equals(id))).go();
  
  Future<double> getTotalPropertyExpenses(String assetId, {int? year}) async {
    final now = DateTime.now();
    final targetYear = year ?? now.year;
    final expenses = await getPropertyExpensesByDateRange(
      assetId,
      DateTime(targetYear, 1, 1),
      DateTime(targetYear, 12, 31),
    );
    double total = 0.0;
    for (final e in expenses) {
      total += e.amount;
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // RENTAL INCOME
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<RentalIncomeData>> getRentalIncome(String assetId) =>
    (_db.select(_db.rentalIncome)..where((r) => r.assetId.equals(assetId))).get();
  
  Future<List<RentalIncomeData>> getRentalIncomeByYear(String assetId, int year) =>
    (_db.select(_db.rentalIncome)
      ..where((r) => r.assetId.equals(assetId))
      ..where((r) => r.year.equals(year))).get();
  
  Future<void> insertRentalIncome(RentalIncomeCompanion income) =>
    _db.into(_db.rentalIncome).insert(income);
  
  Future<void> updateRentalIncome(String id, RentalIncomeCompanion income) =>
    (_db.update(_db.rentalIncome)..where((r) => r.id.equals(id))).write(income);
  
  Future<void> deleteRentalIncome(String id) =>
    (_db.delete(_db.rentalIncome)..where((r) => r.id.equals(id))).go();
  
  Future<double> getTotalRentalIncome(String assetId, {int? year}) async {
    final targetYear = year ?? DateTime.now().year;
    final income = await getRentalIncomeByYear(assetId, targetYear);
    double total = 0.0;
    for (final r in income) {
      total += r.amount;
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GOAL-ASSET MAPPINGS
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<GoalAssetMapping>> getGoalAssetMappings(String goalId) =>
    (_db.select(_db.goalAssetMappings)..where((m) => m.goalId.equals(goalId))).get();
  
  Future<void> insertGoalAssetMapping(GoalAssetMappingsCompanion mapping) =>
    _db.into(_db.goalAssetMappings).insert(mapping);
  
  Future<void> deleteGoalAssetMapping(String goalId, String assetId) =>
    (_db.delete(_db.goalAssetMappings)
      ..where((m) => m.goalId.equals(goalId) & m.assetId.equals(assetId))).go();
  
  Future<double> getGoalCurrentValue(String goalId) async {
    final mappings = await getGoalAssetMappings(goalId);
    double total = 0.0;
    for (final m in mappings) {
      final asset = await (_db.select(_db.assets)
        ..where((a) => a.id.equals(m.assetId))).getSingleOrNull();
      if (asset != null) {
        total += asset.currentValue * (m.allocationPercent / 100);
      }
    }
    return total;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BUDGET THRESHOLD CHECKING
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<Map<String, dynamic>>> checkBudgetThresholds() async {
    final now = DateTime.now();
    final budgets = await getAllBudgets();
    final alerts = <Map<String, dynamic>>[];
    
    for (final budget in budgets) {
      if (budget.year != now.year || budget.month != now.month) continue;
      
      // Get actual expenses for this category
      final transactions = await getTransactionsByCategory(budget.categoryId);
      double spent = 0.0;
      for (final tx in transactions) {
        if (tx.transactionDate.year == now.year && 
            tx.transactionDate.month == now.month &&
            tx.type == 'expense') {
          spent += tx.amountBase;
        }
      }
      
      final percentUsed = budget.limitAmount > 0 ? (spent / budget.limitAmount * 100) : 0;
      
      if (percentUsed >= 70) {
        final category = await (_db.select(_db.categories)
          ..where((c) => c.id.equals(budget.categoryId))).getSingleOrNull();
        
        alerts.add({
          'categoryId': budget.categoryId,
          'categoryName': category?.name ?? 'Unknown',
          'budgetLimit': budget.limitAmount,
          'spent': spent,
          'percentUsed': percentUsed,
          'threshold': percentUsed >= 100 ? 'exceeded' : (percentUsed >= 90 ? 'critical' : 'warning'),
        });
      }
    }
    
    return alerts;
  }
  
  /// Calculate net worth including liabilities
  Future<double> getNetWorthWithLiabilities() async {
    final assets = await getTotalAssetValue();
    final accounts = await getTotalAccountBalance();
    final liabilities = await getTotalLiabilities();
    return assets + accounts - liabilities;
  }
  
  /// Calculate property P&L for a specific year
  Future<Map<String, double>> getPropertyProfitLoss(String assetId, int year) async {
    final income = await getTotalRentalIncome(assetId, year: year);
    final expenses = await getTotalPropertyExpenses(assetId, year: year);
    
    return {
      'income': income,
      'expenses': expenses,
      'netIncome': income - expenses,
    };
  }

  /// Get total income for a specific year
  Future<double> getTotalIncomeByYear(int year) async {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31);
    
    final result = await (_db.selectOnly(_db.transactions)
      ..addColumns([_db.transactions.amountBase.sum()])
      ..where(_db.transactions.transactionDate.isBetweenValues(start, end))
      ..where(_db.transactions.type.equals('income')))
      .map((row) => row.read(_db.transactions.amountBase.sum()))
      .getSingle();
      
    return result ?? 0.0;
  }

  /// Get total expenses for a specific year
  Future<double> getTotalExpensesByYear(int year) async {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31);
    
    final result = await (_db.selectOnly(_db.transactions)
      ..addColumns([_db.transactions.amountBase.sum()])
      ..where(_db.transactions.transactionDate.isBetweenValues(start, end))
      ..where(_db.transactions.type.equals('expense')))
      .map((row) => row.read(_db.transactions.amountBase.sum()))
      .getSingle();
      
    return result?.abs() ?? 0.0;
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // STATEMENT AUTOMATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Statement Sources
  Future<List<StatementSource>> getAllStatementSources() =>
    _db.select(_db.statementSources).get();

  Future<StatementSource?> getStatementSource(String id) =>
    (_db.select(_db.statementSources)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> insertStatementSource(StatementSourcesCompanion source) =>
    _db.into(_db.statementSources).insert(source);

  Future<void> updateStatementSource(String id, StatementSourcesCompanion source) =>
    (_db.update(_db.statementSources)..where((s) => s.id.equals(id))).write(source);

  Future<void> deleteStatementSource(String id) =>
    (_db.delete(_db.statementSources)..where((s) => s.id.equals(id))).go();
    
  // Statement Queue
  Future<List<StatementQueueData>> getAllStatementQueue() =>
    (_db.select(_db.statementQueue)
      ..orderBy([(t) => OrderingTerm(expression: t.queuedAt, mode: OrderingMode.desc)]))
      .get();
      
  Future<List<StatementQueueData>> getPendingStatementQueue() =>
    (_db.select(_db.statementQueue)
      ..where((t) => t.status.isIn(['pending', 'processing']))
      ..orderBy([(t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc)]))
      .get();
      
  Future<void> insertStatementQueueItem(StatementQueueCompanion item) =>
    _db.into(_db.statementQueue).insert(item);
    
  Future<void> updateStatementQueueStatus(String id, String status, {String? errorMessage}) {
    return (_db.update(_db.statementQueue)..where((t) => t.id.equals(id))).write(
      StatementQueueCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        processedAt: status == 'completed' || status == 'failed' ? Value(DateTime.now()) : const Value.absent(),
      ),
    );
  }
  
  Future<void> deleteStatementQueueItem(String id) =>
    (_db.delete(_db.statementQueue)..where((t) => t.id.equals(id))).go();
    
  Future<void> clearCompletedStatementQueue() =>
    (_db.delete(_db.statementQueue)..where((t) => t.status.equals('completed'))).go();

  // ═══════════════════════════════════════════════════════════════════════════
  // PROPERTY EXIT RULES
  // ═══════════════════════════════════════════════════════════════════════════
  
  Future<List<PropertyExitRule>> getAllExitRules() => _db.select(_db.propertyExitRules).get();
  
  Future<List<PropertyExitRule>> getExitRulesForAsset(String assetId) =>
    (_db.select(_db.propertyExitRules)..where((r) => r.assetId.equals(assetId))).get();
    
  Future<int> insertExitRule(PropertyExitRulesCompanion rule) =>
    _db.into(_db.propertyExitRules).insert(rule);
    
  Future<void> updateExitRule(String id, PropertyExitRulesCompanion rule) =>
    (_db.update(_db.propertyExitRules)..where((r) => r.id.equals(id))).write(rule);
    
  Future<void> deleteExitRule(String id) =>
    (_db.delete(_db.propertyExitRules)..where((r) => r.id.equals(id))).go();
    
  Stream<List<PropertyExitRule>> watchExitRulesForAsset(String assetId) =>
    (_db.select(_db.propertyExitRules)..where((r) => r.assetId.equals(assetId))).watch();

  // ═══════════════════════════════════════════════════════════════════════════
  // FINANCIAL INSIGHTS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<List<FinancialInsight>> getAllInsights() =>
    (_db.select(_db.financialInsights)..orderBy([(t) => OrderingTerm(expression: t.generatedAt, mode: OrderingMode.desc)])).get();
    
  Future<List<FinancialInsight>> getActiveInsights() =>
    (_db.select(_db.financialInsights)
      ..where((t) => t.isDismissed.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.generatedAt, mode: OrderingMode.desc)]))
      .get();
      
  Future<void> insertInsight(FinancialInsightsCompanion insight) =>
    _db.into(_db.financialInsights).insert(insight);
    
  Future<void> dismissInsight(String id) =>
    (_db.update(_db.financialInsights)..where((t) => t.id.equals(id))).write(const FinancialInsightsCompanion(isDismissed: Value(true)));
    
  Future<void> deleteInsight(String id) =>
    (_db.delete(_db.financialInsights)..where((t) => t.id.equals(id))).go();
}
