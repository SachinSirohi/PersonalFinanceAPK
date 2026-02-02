import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

class NetWorthScreen extends StatefulWidget {
  const NetWorthScreen({super.key});

  @override
  State<NetWorthScreen> createState() => _NetWorthScreenState();
}

class _NetWorthScreenState extends State<NetWorthScreen> {
  AppRepository? _repo;
  bool _isLoading = true;
  
  double _netWorth = 0;
  double _totalAssets = 0;
  double _totalAccounts = 0;
  double _totalLiabilities = 0;
  double _liquidAssets = 0;
  
  List<Asset> _assets = [];
  List<Account> _accounts = [];
  Map<String, double> _assetBreakdown = {};
  
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
    
    final netWorth = await _repo!.getNetWorth();
    final totalAssets = await _repo!.getTotalAssetValue();
    final totalAccounts = await _repo!.getTotalAccountBalance();
    final liquidAssets = await _repo!.getLiquidAssetValue();
    
    final assets = await _repo!.getAllAssets();
    final accounts = await _repo!.getAllAccounts();
    
    // Calculate breakdown by asset type
    final breakdown = <String, double>{};
    for (final asset in assets) {
      breakdown[asset.type] = (breakdown[asset.type] ?? 0) + asset.currentValue;
    }
    // Add accounts to breakdown
    breakdown['cash_accounts'] = totalAccounts;
    
    setState(() {
      _netWorth = netWorth;
      _totalAssets = totalAssets;
      _totalAccounts = totalAccounts;
      _liquidAssets = liquidAssets;
      _assets = assets;
      _accounts = accounts;
      _assetBreakdown = breakdown;
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
            _buildBreakdownChart(),
            _buildQuickStats(),
            _buildAssetsList(),
            _buildAccountsList(),
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
      title: Text('Net Worth', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.arrow_clockwise, color: Colors.white54),
          onPressed: _loadData,
        ),
      ],
    );
  }

  Widget _buildNetWorthCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFCFB53B), const Color(0xFFB8860B)],
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
                Text('Total Net Worth', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text(DateFormat('MMM dd, yyyy').format(DateTime.now()), style: GoogleFonts.poppins(color: Colors.black54, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_formatCurrency(_netWorth), style: GoogleFonts.poppins(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: -1)),
            const SizedBox(height: 24),
            Container(height: 1, color: Colors.black.withOpacity(0.15)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildNetWorthStat('Assets', _totalAssets, CupertinoIcons.chart_bar_fill, const Color(0xFF4CAF50))),
                Container(width: 1, height: 40, color: Colors.black.withOpacity(0.15)),
                Expanded(child: _buildNetWorthStat('Accounts', _totalAccounts, CupertinoIcons.creditcard_fill, const Color(0xFF2196F3))),
                Container(width: 1, height: 40, color: Colors.black.withOpacity(0.15)),
                Expanded(child: _buildNetWorthStat('Liabilities', _totalLiabilities, CupertinoIcons.minus_circle_fill, const Color(0xFFE53935))),
              ],
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildNetWorthStat(String label, double value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(_formatCompact(value), style: GoogleFonts.poppins(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.poppins(color: Colors.black54, fontSize: 10)),
      ],
    );
  }

  Widget _buildBreakdownChart() {
    if (_assetBreakdown.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final total = _assetBreakdown.values.fold(0.0, (sum, v) => sum + v);
    if (total == 0) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFFE53935),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
      const Color(0xFFCFB53B),
      const Color(0xFFE91E63),
    ];
    
    final sortedEntries = _assetBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final sections = sortedEntries.asMap().entries.map((entry) {
      final value = entry.value.value;
      return PieChartSectionData(
        value: value,
        color: colors[entry.key % colors.length],
        title: '',
        radius: 35,
      );
    }).toList();
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wealth Breakdown', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(PieChartData(sections: sections, centerSpaceRadius: 30, sectionsSpace: 2)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${sortedEntries.length}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Types', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: sortedEntries.asMap().entries.map((entry) {
                      final type = _formatAssetType(entry.value.key);
                      final value = entry.value.value;
                      final percent = total > 0 ? (value / total * 100) : 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[entry.key % colors.length], borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 8),
                            Expanded(child: Text(type, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis)),
                            Text('${percent.toStringAsFixed(0)}%', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
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
      ).animate().fadeIn(delay: 100.ms),
    );
  }

  Widget _buildQuickStats() {
    final nonLiquid = _totalAssets + _totalAccounts - _liquidAssets;
    final liquidPercent = (_totalAssets + _totalAccounts) > 0 
        ? (_liquidAssets / (_totalAssets + _totalAccounts) * 100) 
        : 0.0;
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard('Liquid', _liquidAssets, '${liquidPercent.toStringAsFixed(0)}%', const Color(0xFF4CAF50)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Non-Liquid', nonLiquid, '${(100 - liquidPercent).toStringAsFixed(0)}%', const Color(0xFFFF9800)),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 150.ms),
    );
  }

  Widget _buildStatCard(String label, double value, String percent, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A3A5A))),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(percent, style: GoogleFonts.poppins(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
                Text(_formatCompact(value), style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList() {
    if (_assets.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final topAssets = _assets.toList()
      ..sort((a, b) => b.currentValue.compareTo(a.currentValue));
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Assets', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...topAssets.take(5).map((asset) => _buildAssetRow(asset)),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms),
    );
  }

  Widget _buildAssetRow(Asset asset) {
    final gain = asset.currentValue - asset.purchaseValue;
    final isPositive = gain >= 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: _getAssetColor(asset.type).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(_getAssetIcon(asset.type), color: _getAssetColor(asset.type), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                Text(_formatAssetType(asset.type), style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_formatCompact(asset.currentValue), style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isPositive ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down, size: 10, color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935)),
                  Text(_formatCompact(gain.abs()), style: GoogleFonts.poppins(color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsList() {
    if (_accounts.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bank Accounts', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ..._accounts.take(5).map((account) => _buildAccountRow(account)),
          ],
        ),
      ).animate().fadeIn(delay: 250.ms),
    );
  }

  Widget _buildAccountRow(Account account) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: const Color(0xFF2196F3).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: const Icon(CupertinoIcons.creditcard_fill, color: Color(0xFF2196F3), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                if (account.institution != null)
                  Text(account.institution!, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          Text(_formatCompact(account.balance), style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  IconData _getAssetIcon(String type) {
    switch (type) {
      case 'real_estate': return CupertinoIcons.house_fill;
      case 'stocks': return CupertinoIcons.graph_square;
      case 'mutual_funds': return CupertinoIcons.chart_pie;
      case 'fixed_deposit': return CupertinoIcons.lock_shield;
      case 'gold': return CupertinoIcons.circle_fill;
      case 'crypto': return CupertinoIcons.bitcoin_circle;
      default: return CupertinoIcons.money_dollar_circle;
    }
  }

  Color _getAssetColor(String type) {
    switch (type) {
      case 'real_estate': return const Color(0xFF1976D2);
      case 'stocks': return const Color(0xFF4CAF50);
      case 'mutual_funds': return const Color(0xFF2196F3);
      case 'fixed_deposit': return const Color(0xFFFF9800);
      case 'gold': return const Color(0xFFCFB53B);
      case 'crypto': return const Color(0xFFE91E63);
      default: return Colors.grey;
    }
  }

  String _formatAssetType(String type) {
    switch (type) {
      case 'real_estate': return 'Real Estate';
      case 'stocks': return 'Stocks';
      case 'mutual_funds': return 'Mutual Funds';
      case 'fixed_deposit': return 'Fixed Deposits';
      case 'cash_accounts': return 'Cash & Accounts';
      case 'gold': return 'Gold';
      case 'crypto': return 'Crypto';
      case 'ppf': return 'PPF';
      case 'nps': return 'NPS';
      default: return type.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : w).join(' ');
    }
  }

  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
  String _formatCompact(double amount) => NumberFormat.compactCurrency(symbol: 'AED ', decimalDigits: 0).format(amount);
}
