import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';
import '../widgets/xirr_calculator_sheet.dart';
import 'sip_manager_screen.dart';
import 'dividend_tracker_screen.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AppRepository? _repo;
  List<Asset> _stocks = [];
  List<Asset> _mutualFunds = [];
  List<Asset> _fixedDeposits = [];
  List<Asset> _retirement = []; // PPF, NPS, EPF
  bool _isLoading = true;
  double _totalValue = 0;
  double _totalGain = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _initializeData() async {
    _repo = await AppRepository.getInstance();
    await _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final allAssets = await _repo!.getAllAssets();
    final stocks = allAssets.where((a) => a.type == 'stocks').toList();
    final mfs = allAssets.where((a) => a.type == 'mutual_funds').toList();
    final fds = allAssets.where((a) => a.type == 'fixed_deposit').toList();
    final retirement = allAssets.where((a) => ['ppf', 'nps', 'epf'].contains(a.type)).toList();
    
    final allInvestments = [...stocks, ...mfs, ...fds, ...retirement];
    final total = allInvestments.fold(0.0, (sum, a) => sum + a.currentValue);
    final purchase = allInvestments.fold(0.0, (sum, a) => sum + a.purchaseValue);
    
    setState(() {
      _stocks = stocks;
      _mutualFunds = mfs;
      _fixedDeposits = fds;
      _retirement = retirement;
      _totalValue = total;
      _totalGain = total - purchase;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(),
          _buildPortfolioSummary(),
          _buildQuickActions(),
          _buildAllocationChart(),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFCFB53B),
                labelColor: const Color(0xFFCFB53B),
                unselectedLabelColor: Colors.white54,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                tabs: [
                  Tab(text: 'STOCKS'),
                  Tab(text: 'MF/SIP'),
                  Tab(text: 'FD'),
                  Tab(text: 'RETIREMENT'),
                ],
              ),
            ),
            pinned: true,
          ),
        ],
        body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildInvestmentList(_stocks, 'stocks'),
                _buildInvestmentList(_mutualFunds, 'mutual_funds'),
                _buildInvestmentList(_fixedDeposits, 'fixed_deposit'),
                _buildInvestmentList(_retirement, 'ppf'),
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddInvestmentSheet(),
        backgroundColor: const Color(0xFFCFB53B),
        icon: const Icon(CupertinoIcons.add, color: Colors.black),
        label: Text('Add Investment', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0A1628),
      title: Text('Investments', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
  
  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Row(
          children: [
            Expanded(child: _buildQuickActionButton('XIRR', Icons.calculate_outlined, const Color(0xFF10B981), () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const XIRRCalculatorSheet(),
              );
            })),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickActionButton('SIPs', Icons.event_repeat, const Color(0xFFCFB53B), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SIPManagerScreen()));
            })),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickActionButton('Dividends', Icons.monetization_on_outlined, const Color(0xFF7C3AED), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DividendTrackerScreen()));
            })),
          ],
        ),
      ).animate().fadeIn(delay: 150.ms),
    );
  }
  
  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.inter(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSummary() {
    final gainPercent = (_totalValue - _totalGain) > 0 ? (_totalGain / (_totalValue - _totalGain) * 100) : 0;
    final isPositive = _totalGain >= 0;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
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
                    Text('Portfolio Value', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(_formatCurrency(_totalValue), style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(isPositive ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text('${gainPercent.abs().toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Gain/Loss', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text('${isPositive ? "+" : ""}${_formatCurrency(_totalGain)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Holdings', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text('${_stocks.length + _mutualFunds.length + _fixedDeposits.length + _retirement.length}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildAllocationChart() {
    final stocksValue = _stocks.fold(0.0, (sum, a) => sum + a.currentValue);
    final mfValue = _mutualFunds.fold(0.0, (sum, a) => sum + a.currentValue);
    final fdValue = _fixedDeposits.fold(0.0, (sum, a) => sum + a.currentValue);
    final retirementValue = _retirement.fold(0.0, (sum, a) => sum + a.currentValue);
    
    if (_totalValue == 0) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    final sections = <PieChartSectionData>[];
    if (stocksValue > 0) sections.add(PieChartSectionData(value: stocksValue, color: const Color(0xFF4CAF50), title: '${(stocksValue / _totalValue * 100).toStringAsFixed(0)}%', radius: 25, titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)));
    if (mfValue > 0) sections.add(PieChartSectionData(value: mfValue, color: const Color(0xFF2196F3), title: '${(mfValue / _totalValue * 100).toStringAsFixed(0)}%', radius: 25, titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)));
    if (fdValue > 0) sections.add(PieChartSectionData(value: fdValue, color: const Color(0xFFFF9800), title: '${(fdValue / _totalValue * 100).toStringAsFixed(0)}%', radius: 25, titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)));
    if (retirementValue > 0) sections.add(PieChartSectionData(value: retirementValue, color: const Color(0xFF9C27B0), title: '${(retirementValue / _totalValue * 100).toStringAsFixed(0)}%', radius: 25, titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)));
    
    if (sections.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1A2744), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 20, sectionsSpace: 2)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stocksValue > 0) _buildLegendItem('Stocks', stocksValue, const Color(0xFF4CAF50)),
                  if (mfValue > 0) _buildLegendItem('Mutual Funds', mfValue, const Color(0xFF2196F3)),
                  if (fdValue > 0) _buildLegendItem('Fixed Deposits', fdValue, const Color(0xFFFF9800)),
                  if (retirementValue > 0) _buildLegendItem('Retirement', retirementValue, const Color(0xFF9C27B0)),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms),
    );
  }

  Widget _buildLegendItem(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11))),
          Text(_formatCompact(value), style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInvestmentList(List<Asset> investments, String type) {
    if (investments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getTypeIcon(type), size: 48, color: Colors.white24),
            const SizedBox(height: 12),
            Text('No ${_getTypeName(type)} yet', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16)),
            const SizedBox(height: 4),
            Text('Tap + to add', style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: investments.length,
      itemBuilder: (context, index) => _buildInvestmentCard(investments[index]).animate(delay: (index * 60).ms).fadeIn().slideX(begin: 0.03),
    );
  }

  Widget _buildInvestmentCard(Asset investment) {
    final gain = investment.currentValue - investment.purchaseValue;
    final gainPercent = investment.purchaseValue > 0 ? (gain / investment.purchaseValue * 100) : 0;
    final isPositive = gain >= 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A5A), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: _getTypeColor(investment.type).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(_getTypeIcon(investment.type), color: _getTypeColor(investment.type), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(investment.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(investment.geography ?? investment.currencyCode, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_formatCurrency(investment.currentValue), style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isPositive ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down, color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), size: 11),
                  Text('${gainPercent.abs().toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddInvestmentSheet() {
    final nameController = TextEditingController();
    final purchaseController = TextEditingController();
    final currentController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    String type = 'stocks';
    String currency = 'INR';
    String geography = 'India';
    
    final types = [
      {'value': 'stocks', 'label': 'Stocks', 'icon': CupertinoIcons.graph_square},
      {'value': 'mutual_funds', 'label': 'Mutual Fund', 'icon': CupertinoIcons.chart_pie},
      {'value': 'fixed_deposit', 'label': 'Fixed Deposit', 'icon': CupertinoIcons.lock_shield},
      {'value': 'ppf', 'label': 'PPF', 'icon': CupertinoIcons.shield},
      {'value': 'nps', 'label': 'NPS', 'icon': CupertinoIcons.person_2},
      {'value': 'gold', 'label': 'Gold', 'icon': CupertinoIcons.circle_fill},
      {'value': 'crypto', 'label': 'Crypto', 'icon': CupertinoIcons.bitcoin_circle},
    ];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Add Investment', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Investment Type', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: types.map((t) => ChoiceChip(
                          label: Text(t['label'] as String),
                          selected: type == t['value'],
                          onSelected: (sel) => setSheetState(() => type = t['value'] as String),
                          selectedColor: const Color(0xFFCFB53B),
                          labelStyle: GoogleFonts.poppins(color: type == t['value'] ? Colors.black : Colors.white70, fontSize: 12),
                          backgroundColor: const Color(0xFF0D1B2A),
                        )).toList(),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: type == 'stocks' ? 'Stock Name / Symbol' : type == 'mutual_funds' ? 'Fund Name' : 'Investment Name',
                          hintText: type == 'stocks' ? 'e.g., RELIANCE, TCS' : type == 'mutual_funds' ? 'e.g., HDFC Equity Fund' : 'Enter name',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          hintStyle: GoogleFonts.poppins(color: Colors.white24),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: geography,
                                  dropdownColor: const Color(0xFF1A2744),
                                  items: ['India', 'UAE', 'USA', 'UK'].map((g) => DropdownMenuItem(value: g, child: Text(g, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                                  onChanged: (val) {
                                    setSheetState(() {
                                      geography = val!;
                                      currency = val == 'India' ? 'INR' : val == 'UAE' ? 'AED' : val == 'USA' ? 'USD' : 'GBP';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: currency,
                                  dropdownColor: const Color(0xFF1A2744),
                                  items: ['INR', 'AED', 'USD', 'GBP', 'EUR'].map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                                  onChanged: (val) => setSheetState(() => currency = val!),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (type == 'stocks') ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.poppins(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: GoogleFonts.poppins(color: Colors.white54),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: purchaseController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: type == 'stocks' ? 'Buy Price (per share)' : 'Invested Amount',
                          prefixText: '$currency ',
                          prefixStyle: GoogleFonts.poppins(color: Colors.white54),
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: currentController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: type == 'stocks' ? 'Current Price (per share)' : 'Current Value',
                          prefixText: '$currency ',
                          prefixStyle: GoogleFonts.poppins(color: Colors.white54),
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter investment name')));
                        return;
                      }
                      
                      final qty = int.tryParse(quantityController.text) ?? 1;
                      var purchase = double.tryParse(purchaseController.text) ?? 0;
                      var current = double.tryParse(currentController.text) ?? purchase;
                      
                      if (type == 'stocks') {
                        purchase = purchase * qty;
                        current = current * qty;
                      }
                      
                      final asset = AssetsCompanion(
                        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        name: Value(nameController.text),
                        type: Value(type),
                        currencyCode: Value(currency),
                        purchaseValue: Value(purchase),
                        currentValue: Value(current),
                        geography: Value(geography),
                        isLiquid: Value(type == 'stocks' || type == 'mutual_funds'),
                        purchaseDate: Value(DateTime.now()),
                      );
                      
                      await _repo!.insertAsset(asset);
                      Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCFB53B), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('Add Investment', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'stocks': return CupertinoIcons.graph_square;
      case 'mutual_funds': return CupertinoIcons.chart_pie;
      case 'fixed_deposit': return CupertinoIcons.lock_shield;
      case 'ppf': case 'nps': case 'epf': return CupertinoIcons.shield;
      case 'gold': return CupertinoIcons.circle_fill;
      case 'crypto': return CupertinoIcons.bitcoin_circle;
      default: return CupertinoIcons.money_dollar_circle;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'stocks': return const Color(0xFF4CAF50);
      case 'mutual_funds': return const Color(0xFF2196F3);
      case 'fixed_deposit': return const Color(0xFFFF9800);
      case 'ppf': case 'nps': case 'epf': return const Color(0xFF9C27B0);
      case 'gold': return const Color(0xFFCFB53B);
      case 'crypto': return const Color(0xFFE91E63);
      default: return Colors.grey;
    }
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'stocks': return 'stocks';
      case 'mutual_funds': return 'mutual funds';
      case 'fixed_deposit': return 'fixed deposits';
      case 'ppf': return 'retirement accounts';
      default: return 'investments';
    }
  }

  String _formatCurrency(double amount) => NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(amount);
  String _formatCompact(double amount) => NumberFormat.compactCurrency(symbol: '₹', decimalDigits: 0).format(amount);
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: const Color(0xFF0A1628), child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
