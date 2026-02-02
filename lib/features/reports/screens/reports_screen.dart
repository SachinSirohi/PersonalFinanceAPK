import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  AppRepository? _repo;
  bool _isLoading = true;
  
  double _netWorth = 0;
  double _totalAssets = 0;
  double _totalAccounts = 0;
  double _totalLiabilities = 0;
  double _monthlyIncome = 0;
  double _monthlyExpenses = 0;
  double _totalMonthlySip = 0;
  double _totalMonthlyEmi = 0;
  double _totalDividendsThisYear = 0;
  int _emergencyFundMonths = 0;
  
  List<FlSpot> _netWorthTrend = [];
  List<Map<String, dynamic>> _assetAllocation = [];
  List<Map<String, dynamic>> _incomeVsExpense = [];
  List<Map<String, dynamic>> _topExpenses = [];
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    _repo = await AppRepository.getInstance();
    await _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Net worth breakdown with liabilities
    final totalAssets = await _repo!.getTotalAssetValue();
    final totalAccounts = await _repo!.getTotalAccountBalance();
    final totalLiabilities = await _repo!.getTotalLiabilities();
    final netWorth = totalAssets + totalAccounts - totalLiabilities;
    
    // Monthly income/expense/SIP/EMI
    final now = DateTime.now();
    final income = await _repo!.getTotalIncomeByMonth(now.year, now.month);
    final expenses = await _repo!.getTotalExpensesByMonth(now.year, now.month);
    final totalSip = await _repo!.getTotalMonthlySip();
    final totalEmi = await _repo!.getTotalMonthlyEMI();
    
    // Dividends this year
    final dividendsThisYear = await _repo!.getTotalDividendsByYear(now.year);
    
    // Emergency fund
    final emergencyMonths = await _repo!.getEmergencyFundMonths();
    
    // Asset allocation
    final assets = await _repo!.getAllAssets();
    final assetsByType = <String, double>{};
    for (final asset in assets) {
      assetsByType[asset.type] = (assetsByType[asset.type] ?? 0) + asset.currentValue;
    }
    
    // Income vs Expense for last 6 months
    final incomeVsExpense = <Map<String, dynamic>>[];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthIncome = await _repo!.getTotalIncomeByMonth(month.year, month.month);
      final monthExpense = await _repo!.getTotalExpensesByMonth(month.year, month.month);
      incomeVsExpense.add({
        'month': DateFormat('MMM').format(month),
        'income': monthIncome,
        'expense': monthExpense,
      });
    }
    
    // Top expenses by category
    final expensesByCategory = await _repo!.getExpensesByCategory(
      DateTime(now.year, now.month, 1),
      DateTime(now.year, now.month + 1, 0),
    );
    final sortedExpenses = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    setState(() {
      _netWorth = netWorth;
      _totalAssets = totalAssets;
      _totalAccounts = totalAccounts;
      _totalLiabilities = totalLiabilities;
      _totalMonthlySip = totalSip;
      _totalMonthlyEmi = totalEmi;
      _totalDividendsThisYear = dividendsThisYear;
      _monthlyIncome = income;
      _monthlyExpenses = expenses;
      _emergencyFundMonths = emergencyMonths;
      
      _assetAllocation = assetsByType.entries
          .map((e) => {'type': e.key, 'value': e.value})
          .toList();
      
      _incomeVsExpense = incomeVsExpense;
      
      _topExpenses = sortedExpenses.take(5)
          .map((e) => {'category': e.key, 'amount': e.value})
          .toList();
      
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B))),
            )
          else ...[
            _buildNetWorthCard(),
            _buildKeyMetrics(),
            _buildCashFlowAnalysis(),
            _buildFinancialHealthCard(),
            _buildAssetAllocationChart(),
            _buildIncomeVsExpenseChart(),
            _buildTopExpensesCard(),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0A1628),
      title: Text('Financial Reports', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.arrow_clockwise, color: Colors.white54),
          onPressed: _loadData,
        ),
      ],
    );
  }

  Widget _buildNetWorthCard() {
    final savingsRate = _monthlyIncome > 0 
        ? ((_monthlyIncome - _monthlyExpenses) / _monthlyIncome * 100) 
        : 0.0;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFCFB53B), const Color(0xFFB8860B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFFCFB53B).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Net Worth', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(_formatCurrency(_netWorth), style: GoogleFonts.poppins(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text('${savingsRate.toStringAsFixed(0)}% savings rate', style: GoogleFonts.poppins(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildNetWorthItem('Assets', _totalAssets, const Color(0xFF4CAF50))),
                Expanded(child: _buildNetWorthItem('Accounts', _totalAccounts, const Color(0xFF2196F3))),
                Expanded(child: _buildNetWorthItem('Liabilities', _totalLiabilities, const Color(0xFFE53935))),
              ],
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildNetWorthItem(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(color: Colors.black54, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(_formatCompact(value), style: GoogleFonts.poppins(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildKeyMetrics() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: _buildMetricCard('Income', _monthlyIncome, CupertinoIcons.arrow_down_circle_fill, const Color(0xFF4CAF50))),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Expenses', _monthlyExpenses, CupertinoIcons.arrow_up_circle_fill, const Color(0xFFE53935))),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Emergency', _emergencyFundMonths.toDouble(), CupertinoIcons.shield_fill, const Color(0xFF2196F3), suffix: ' mo')),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms),
    );
  }

  Widget _buildMetricCard(String title, double value, IconData icon, Color color, {String suffix = ''}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A3A5A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(suffix.isEmpty ? _formatCompact(value) : '${value.toInt()}$suffix', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildAssetAllocationChart() {
    if (_assetAllocation.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final total = _assetAllocation.fold(0.0, (sum, e) => sum + (e['value'] as double));
    if (total == 0) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFFE53935),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
      const Color(0xFFCFB53B),
    ];
    
    final sections = _assetAllocation.asMap().entries.map((entry) {
      final value = entry.value['value'] as double;
      return PieChartSectionData(
        value: value,
        color: colors[entry.key % colors.length],
        title: '${(value / total * 100).toStringAsFixed(0)}%',
        radius: 30,
        titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      );
    }).toList();
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asset Allocation', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 25, sectionsSpace: 2)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: _assetAllocation.asMap().entries.map((entry) {
                      final type = _formatAssetType(entry.value['type'] as String);
                      final value = entry.value['value'] as double;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[entry.key % colors.length], borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 8),
                            Expanded(child: Text(type, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11))),
                            Text(_formatCompact(value), style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms),
    );
  }

  Widget _buildIncomeVsExpenseChart() {
    if (_incomeVsExpense.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final maxValue = _incomeVsExpense.fold(0.0, (max, e) {
      final income = e['income'] as double;
      final expense = e['expense'] as double;
      return [max, income, expense].reduce((a, b) => a > b ? a : b);
    });
    
    if (maxValue == 0) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Income vs Expenses', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    _buildLegendDot('Income', const Color(0xFF4CAF50)),
                    const SizedBox(width: 12),
                    _buildLegendDot('Expense', const Color(0xFFE53935)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue * 1.2,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < _incomeVsExpense.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(_incomeVsExpense[value.toInt()]['month'], style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: _incomeVsExpense.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(toY: entry.value['income'] as double, color: const Color(0xFF4CAF50), width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                        BarChartRodData(toY: entry.value['expense'] as double, color: const Color(0xFFE53935), width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 300.ms),
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
      ],
    );
  }

  Widget _buildTopExpensesCard() {
    if (_topExpenses.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final colors = [
      const Color(0xFFE53935),
      const Color(0xFFFF9800),
      const Color(0xFFCFB53B),
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
    ];
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Expenses This Month', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ..._topExpenses.asMap().entries.map((entry) {
              final category = entry.value['category'] as String;
              final amount = entry.value['amount'] as double;
              final maxAmount = _topExpenses.first['amount'] as double;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
                        Text(_formatCurrency(amount), style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: maxAmount > 0 ? amount / maxAmount : 0,
                        backgroundColor: const Color(0xFF0D1B2A),
                        valueColor: AlwaysStoppedAnimation(colors[entry.key % colors.length]),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms),
    );
  }

  String _formatAssetType(String type) {
    switch (type) {
      case 'real_estate': return 'Real Estate';
      case 'stocks': return 'Stocks';
      case 'mutual_funds': return 'Mutual Funds';
      case 'fixed_deposit': return 'Fixed Deposits';
      case 'gold': return 'Gold';
      case 'crypto': return 'Crypto';
      case 'ppf': return 'PPF';
      case 'nps': return 'NPS';
      default: return type.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
    }
  }

  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
  String _formatCompact(double amount) => NumberFormat.compactCurrency(symbol: 'AED ', decimalDigits: 0).format(amount);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CASH FLOW ANALYSIS WIDGET
  // ═══════════════════════════════════════════════════════════════════════════
  
  Widget _buildCashFlowAnalysis() {
    final netCashFlow = _monthlyIncome - _monthlyExpenses - _totalMonthlyEmi;
    final freeCashFlow = netCashFlow - _totalMonthlySip;
    final isPositive = netCashFlow >= 0;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2744),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isPositive ? const Color(0xFF4CAF50).withValues(alpha: 0.3) : const Color(0xFFE53935).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cash Flow Analysis', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                Icon(
                  isPositive ? CupertinoIcons.arrow_up_circle_fill : CupertinoIcons.arrow_down_circle_fill,
                  color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCashFlowRow('Income', _monthlyIncome, const Color(0xFF4CAF50)),
            _buildCashFlowRow('Expenses', -_monthlyExpenses, const Color(0xFFE53935)),
            _buildCashFlowRow('EMI Payments', -_totalMonthlyEmi, const Color(0xFFFF9800)),
            const Divider(color: Colors.white24, height: 24),
            _buildCashFlowRow('Net Cash Flow', netCashFlow, isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), isBold: true),
            const SizedBox(height: 8),
            _buildCashFlowRow('SIP Investments', -_totalMonthlySip, const Color(0xFF2196F3)),
            const Divider(color: Colors.white24, height: 24),
            _buildCashFlowRow('Free Cash Flow', freeCashFlow, freeCashFlow >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFE53935), isBold: true),
            const SizedBox(height: 12),
            if (_totalDividendsThisYear > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.money_dollar_circle_fill, color: Color(0xFF4CAF50), size: 20),
                    const SizedBox(width: 8),
                    Text('Dividends YTD: ${_formatCurrency(_totalDividendsThisYear)}', style: GoogleFonts.poppins(color: const Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms),
    );
  }
  
  Widget _buildCashFlowRow(String label, double amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: isBold ? FontWeight.w600 : FontWeight.normal)),
          Text(
            '${amount >= 0 ? '+' : ''}${_formatCurrency(amount.abs())}',
            style: GoogleFonts.poppins(color: color, fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500),
          ),
        ],
      ),
    );
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FINANCIAL HEALTH CARD
  // ═══════════════════════════════════════════════════════════════════════════
  
  Widget _buildFinancialHealthCard() {
    // Calculate key financial ratios
    final savingsRate = _monthlyIncome > 0 ? ((_monthlyIncome - _monthlyExpenses) / _monthlyIncome * 100) : 0.0;
    final debtToIncome = _monthlyIncome > 0 ? (_totalMonthlyEmi / _monthlyIncome * 100) : 0.0;
    final investmentRate = _monthlyIncome > 0 ? (_totalMonthlySip / _monthlyIncome * 100) : 0.0;
    final debtToAssets = (_totalAssets + _totalAccounts) > 0 ? (_totalLiabilities / (_totalAssets + _totalAccounts) * 100) : 0.0;
    
    // Calculate health score (0-100)
    double healthScore = 50.0; // Base score
    
    // Savings rate contribution (max +20 points)
    healthScore += (savingsRate.clamp(0, 30) / 30 * 20);
    
    // Emergency fund contribution (max +15 points)
    healthScore += (_emergencyFundMonths.clamp(0, 6) / 6 * 15);
    
    // Investment rate contribution (max +10 points)
    healthScore += (investmentRate.clamp(0, 20) / 20 * 10);
    
    // Debt penalties
    healthScore -= (debtToIncome.clamp(0, 50) / 50 * 15); // Penalty for high debt-to-income
    healthScore -= (debtToAssets.clamp(0, 80) / 80 * 10); // Penalty for high debt-to-assets
    
    healthScore = healthScore.clamp(0, 100);
    
    final healthGrade = healthScore >= 80 ? 'Excellent' : healthScore >= 60 ? 'Good' : healthScore >= 40 ? 'Fair' : 'Needs Attention';
    final healthColor = healthScore >= 80 ? const Color(0xFF4CAF50) : healthScore >= 60 ? const Color(0xFFCFB53B) : healthScore >= 40 ? const Color(0xFFFF9800) : const Color(0xFFE53935);
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [healthColor.withValues(alpha: 0.2), healthColor.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: healthColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Financial Health', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(healthGrade, style: GoogleFonts.poppins(color: healthColor, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: healthScore / 100,
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(healthColor),
                      ),
                    ),
                    Text('${healthScore.toInt()}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildHealthMetric('Savings Rate', '${savingsRate.toStringAsFixed(0)}%', savingsRate >= 20 ? const Color(0xFF4CAF50) : const Color(0xFFFF9800))),
                Expanded(child: _buildHealthMetric('Debt-to-Income', '${debtToIncome.toStringAsFixed(0)}%', debtToIncome <= 36 ? const Color(0xFF4CAF50) : const Color(0xFFE53935))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildHealthMetric('Investment Rate', '${investmentRate.toStringAsFixed(0)}%', investmentRate >= 10 ? const Color(0xFF4CAF50) : const Color(0xFFFF9800))),
                Expanded(child: _buildHealthMetric('Debt-to-Assets', '${debtToAssets.toStringAsFixed(0)}%', debtToAssets <= 50 ? const Color(0xFF4CAF50) : const Color(0xFFE53935))),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 250.ms),
    );
  }
  
  Widget _buildHealthMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
