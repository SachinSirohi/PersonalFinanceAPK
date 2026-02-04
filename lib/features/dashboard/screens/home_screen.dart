import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

/// Home Dashboard screen with real data integration
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppRepository? _repo;
  bool _isLoading = true;
  
  // Dashboard data
  double _netWorth = 0;
  double _totalAssets = 0;
  double _totalAccounts = 0;
  double _monthlyIncome = 0;
  double _monthlyExpenses = 0;
  int _emergencyFundMonths = 0;
  double _budgetUsed = 0;
  double _budgetTotal = 0;
  
  List<Transaction> _recentTransactions = [];
  List<Goal> _activeGoals = [];
  Map<String, double> _assetAllocation = {};
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    try {
      _repo = await AppRepository.getInstance();
      if (!mounted) return;
      await _loadData();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Net worth
      final netWorth = await _repo!.getNetWorth();
      final totalAssets = await _repo!.getTotalAssetValue();
      final totalAccounts = await _repo!.getTotalAccountBalance();
      
      // Monthly data
      final now = DateTime.now();
      final income = await _repo!.getTotalIncomeByMonth(now.year, now.month);
      final expenses = await _repo!.getTotalExpensesByMonth(now.year, now.month);
      
      // Emergency fund
      final emergencyMonths = await _repo!.getEmergencyFundMonths();
      
      // Budget
      final budgets = await _repo!.getAllBudgets();
      final budgetTotal = budgets.fold(0.0, (sum, b) => sum + b.limitAmount);
      
      // Recent transactions
      final transactions = await _repo!.getAllTransactions();
      final recentTx = transactions.take(5).toList();
      
      // Goals
      final goals = await _repo!.getAllGoals();
      final activeGoals = goals.take(3).toList();
      
      // Asset allocation
      final assets = await _repo!.getAllAssets();
      final allocation = <String, double>{};
      for (final asset in assets) {
        allocation[asset.type] = (allocation[asset.type] ?? 0) + asset.currentValue;
      }
      
      
      if (!mounted) return;
      setState(() {
        _netWorth = netWorth;
        _totalAssets = totalAssets;
        _totalAccounts = totalAccounts;
        _monthlyIncome = income;
        _monthlyExpenses = expenses;
        _emergencyFundMonths = emergencyMonths;
        _budgetTotal = budgetTotal;
        _budgetUsed = expenses;
        _recentTransactions = recentTx;
        _activeGoals = activeGoals;
        _assetAllocation = allocation;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFFCFB53B),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B))),
              )
            else ...[
              _buildNetWorthCard(),
              _buildQuickActions(),
              _buildFinancialHealth(),
              _buildGoalsSection(),
              _buildRecentTransactions(),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0A1628),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.w400),
            ),
            Text(
              'WealthOrbit',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.bell, color: Colors.white54),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.gear, color: Colors.white54),
          onPressed: () {},
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
          gradient: const LinearGradient(
            colors: [Color(0xFFCFB53B), Color(0xFFB8860B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFFCFB53B).withOpacity(0.3), blurRadius: 25, offset: const Offset(0, 12)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net Worth', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text('${savingsRate.toStringAsFixed(0)}% saved', style: GoogleFonts.poppins(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_formatCurrency(_netWorth), style: GoogleFonts.poppins(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assets', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 11)),
                      Text(_formatCompact(_totalAssets), style: GoogleFonts.poppins(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Accounts', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 11)),
                      Text(_formatCompact(_totalAccounts), style: GoogleFonts.poppins(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('This Month', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 11)),
                      Text(_monthlyIncome >= _monthlyExpenses ? '+${_formatCompact(_monthlyIncome - _monthlyExpenses)}' : '-${_formatCompact(_monthlyExpenses - _monthlyIncome)}', style: GoogleFonts.poppins(color: _monthlyIncome >= _monthlyExpenses ? Colors.green[800] : Colors.red[800], fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': CupertinoIcons.arrow_down_circle_fill, 'label': 'Income', 'color': const Color(0xFF4CAF50), 'route': '/transactions'},
      {'icon': CupertinoIcons.arrow_up_circle_fill, 'label': 'Expense', 'color': const Color(0xFFE53935), 'route': '/transactions'},
      {'icon': CupertinoIcons.chart_bar_fill, 'label': 'Budget', 'color': const Color(0xFF7C4DFF), 'route': '/expenses'},
      {'icon': CupertinoIcons.graph_square, 'label': 'Invest', 'color': const Color(0xFF2196F3), 'route': '/investments'},
    ];
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((action) => _buildQuickAction(
            action['icon'] as IconData,
            action['label'] as String,
            action['color'] as Color,
            action['route'] as String,
          )).toList(),
        ),
      ).animate().fadeIn(delay: 100.ms),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, String route) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(route);
      },
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2744),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A3A5A)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialHealth() {
    final budgetProgress = _budgetTotal > 0 ? (_budgetUsed / _budgetTotal).clamp(0.0, 1.0) : 0.0;
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Financial Health', style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildHealthCard('Emergency Fund', '$_emergencyFundMonths months', CupertinoIcons.shield_fill, const Color(0xFF4CAF50), _emergencyFundMonths >= 6 ? 1.0 : _emergencyFundMonths / 6)),
                const SizedBox(width: 12),
                Expanded(child: _buildHealthCard('Budget Used', '${(budgetProgress * 100).toStringAsFixed(0)}%', CupertinoIcons.chart_pie_fill, budgetProgress > 0.9 ? const Color(0xFFE53935) : const Color(0xFF2196F3), budgetProgress)),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 150.ms),
    );
  }

  Widget _buildHealthCard(String title, String value, IconData icon, Color color, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A5A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF0D1B2A),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    if (_activeGoals.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Goals', style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () => context.push('/goals'),
                  child: Text('See All', style: GoogleFonts.poppins(color: const Color(0xFFCFB53B), fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._activeGoals.map((goal) => _buildGoalCard(goal)),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final progress = 0.0; // Goals don't track currentAmount in DB yet
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A5A)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('${daysLeft > 0 ? "$daysLeft days left" : "Due date passed"}', style: GoogleFonts.poppins(color: daysLeft > 0 ? Colors.white38 : const Color(0xFFE53935), fontSize: 11)),
                ],
              ),
              Text('${(progress * 100).toStringAsFixed(0)}%', style: GoogleFonts.poppins(color: const Color(0xFFCFB53B), fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF0D1B2A),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFCFB53B)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    if (_recentTransactions.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions', style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () => context.push('/transactions'),
                  child: Text('See All', style: GoogleFonts.poppins(color: const Color(0xFFCFB53B), fontSize: 13)),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A2744),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _recentTransactions.asMap().entries.map((entry) {
                  final tx = entry.value;
                  final isLast = entry.key == _recentTransactions.length - 1;
                  return _buildTransactionRow(tx, isLast);
                }).toList(),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 250.ms),
    );
  }

  Widget _buildTransactionRow(Transaction tx, bool isLast) {
    final isExpense = tx.type == 'expense';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFF2A3A5A), width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isExpense ? const Color(0xFFE53935) : const Color(0xFF4CAF50)).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isExpense ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down,
              color: isExpense ? const Color(0xFFE53935) : const Color(0xFF4CAF50),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.description, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(DateFormat('MMM d, yyyy').format(tx.transactionDate), style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Text(
            '${isExpense ? "-" : "+"}${_formatCurrency(tx.amountBase)}',
            style: GoogleFonts.poppins(color: isExpense ? const Color(0xFFE53935) : const Color(0xFF4CAF50), fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
  String _formatCompact(double amount) => NumberFormat.compactCurrency(symbol: 'AED ', decimalDigits: 0).format(amount);
}
