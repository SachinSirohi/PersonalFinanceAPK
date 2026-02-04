import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../core/utils/financial_calculations.dart';
import '../widgets/deal_analyzer_sheet.dart';
import '../widgets/exit_strategy_sheet.dart';

class RealEstateScreen extends StatefulWidget {
  const RealEstateScreen({super.key});

  @override
  State<RealEstateScreen> createState() => _RealEstateScreenState();
}

class _RealEstateScreenState extends State<RealEstateScreen> {
  AppRepository? _repo;
  List<Asset> _properties = [];
  bool _isLoading = true;
  double _totalValue = 0;
  double _totalRentalIncome = 0;
  Map<String, double> _propertyRentalIncome = {};
  Map<String, double> _propertyExpenses = {};
  
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
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final allAssets = await _repo!.getAllAssets();
      if (!mounted) return;
      final properties = allAssets.where((a) => a.type == 'real_estate').toList();
      final total = properties.fold(0.0, (sum, p) => sum + p.currentValue);
      
      // Calculate rental income from transactions
      final now = DateTime.now();
      final transactions = await _repo!.getTransactionsByDateRange(
        DateTime(now.year, now.month - 12, 1), now);
      if (!mounted) return;
      final rentalIncome = transactions
          .where((t) => t.type == 'income' && t.description.toLowerCase().contains('rent'))
          .fold(0.0, (sum, t) => sum + t.amountBase);
      
      // Load property-specific rental income and expenses
      final propertyRentalIncomeMap = <String, double>{};
      final propertyExpensesMap = <String, double>{};
      
      // Calculate ROI for each property
      for (final property in properties) {
        final propertyTransactions = transactions.where((t) => t.description.contains(property.name));
        final income = propertyTransactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amountBase);
        final expenses = propertyTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amountBase);
        
        propertyRentalIncomeMap[property.id] = income;
        propertyExpensesMap[property.id] = expenses;
      }
      
      if (!mounted) return;
      setState(() {
        _properties = properties;
        _totalValue = total;
        _totalRentalIncome = rentalIncome;
        _propertyRentalIncome = propertyRentalIncomeMap;
        _propertyExpenses = propertyExpensesMap;
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
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildPortfolioSummary(),
          _buildMetricsRow(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B))),
            )
          else if (_properties.isEmpty)
            _buildEmptyState()
          else
            _buildPropertyList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPropertySheet(),
        backgroundColor: const Color(0xFFCFB53B),
        icon: const Icon(CupertinoIcons.add, color: Colors.black),
        label: Text('Add Property', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0A1628),
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Real Estate', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
    );
  }

  Widget _buildPortfolioSummary() {
    final avgROI = _totalValue > 0 && _totalRentalIncome > 0 
        ? (_totalRentalIncome * 12 / _totalValue * 100) 
        : 0.0;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1976D2), const Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF1976D2).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
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
                    Text(
                      _formatCurrency(_totalValue),
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.house_fill, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text('${_properties.length} Properties', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
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
                      Text('Monthly Rental', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text(_formatCurrency(_totalRentalIncome), style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gross Yield', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text('${avgROI.toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: const Color(0xFF4CAF50), fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildMetricsRow() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: _buildMetricCard('UAE Properties', _properties.where((p) => p.geography == 'UAE').length.toString(), CupertinoIcons.building_2_fill, const Color(0xFFCFB53B))),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('India Properties', _properties.where((p) => p.geography == 'India').length.toString(), CupertinoIcons.house_fill, const Color(0xFF7C4DFF))),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A5A)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(title, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.house, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text('No properties yet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white54)),
            const SizedBox(height: 8),
            Text('Add your real estate investments', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38)),
          ],
        ).animate().fadeIn(),
      ),
    );
  }

  Widget _buildPropertyList() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildPropertyCard(_properties[index]).animate(delay: (index * 80).ms).fadeIn().slideX(begin: 0.05),
          childCount: _properties.length,
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Asset property) {
    final gain = property.currentValue - property.purchaseValue;
    final gainPercent = property.purchaseValue > 0 ? (gain / property.purchaseValue * 100) : 0;
    final isPositive = gain >= 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3A5A), width: 0.5),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0xFF1976D2), const Color(0xFF0D47A1)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(CupertinoIcons.house_fill, color: Colors.white, size: 28),
            ),
            title: Text(property.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (property.geography != null)
                  Row(
                    children: [
                      Icon(CupertinoIcons.location_solid, size: 12, color: Colors.white38),
                      const SizedBox(width: 4),
                      Text(property.geography!, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_formatCurrency(property.currentValue), style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isPositive ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down, color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), size: 12),
                    Text('${gainPercent.abs().toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            onTap: () => _showPropertyDetail(property),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPropertyStat('Purchase', _formatCompact(property.purchaseValue)),
                _buildPropertyStat('Current', _formatCompact(property.currentValue)),
                _buildPropertyStat('Gain', '${isPositive ? "+" : ""}${_formatCompact(gain)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        Text(label, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  void _showPropertyDetail(Asset property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(property.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  IconButton(icon: const Icon(CupertinoIcons.xmark, color: Colors.white54), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Property Details', [
                      _buildDetailRow('Location', property.geography ?? 'Not specified'),
                      _buildDetailRow('Type', 'Residential'),
                      _buildDetailRow('Currency', property.currencyCode),
                      _buildDetailRow('Liquid', property.isLiquid ? 'Yes' : 'No'),
                    ]),
                    const SizedBox(height: 20),
                    _buildDetailSection('Valuation', [
                      _buildDetailRow('Purchase Price', _formatCurrency(property.purchaseValue)),
                      _buildDetailRow('Current Value', _formatCurrency(property.currentValue)),
                      _buildDetailRow('Unrealized Gain', _formatCurrency(property.currentValue - property.purchaseValue)),
                      _buildDetailRow('ROI', '${((property.currentValue - property.purchaseValue) / property.purchaseValue * 100).toStringAsFixed(1)}%'),
                    ]),
                    const SizedBox(height: 20),
                    Builder(builder: (context) {
                      final annualRent = _propertyRentalIncome[property.id] ?? 0;
                      final annualExpenses = _propertyExpenses[property.id] ?? 0;
                      final noi = annualRent - annualExpenses;
                      final capRate = property.purchaseValue > 0 ? (noi / property.purchaseValue * 100) : 0.0;
                      final grossYield = property.currentValue > 0 ? (annualRent / property.currentValue * 100) : 0.0;
                      
                      return _buildDetailSection('P&L Summary', [
                        _buildDetailRow('Annual Rental Income', _formatCurrency(annualRent)),
                        _buildDetailRow('Annual Expenses', _formatCurrency(annualExpenses)),
                        _buildDetailRow('Net Operating Income', _formatCurrency(noi)),
                        _buildDetailRow('Cap Rate', '${capRate.toStringAsFixed(1)}%'),
                        _buildDetailRow('Gross Yield', '${grossYield.toStringAsFixed(1)}%'),
                      ]);
                    }),
                    const SizedBox(height: 20),
                    // Analyze Deal Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDealAnalyzer(property);
                        },
                        icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                        label: Text('Analyze Deal', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Exit Strategy Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showExitStrategySheet(property);
                        },
                        icon: const Icon(CupertinoIcons.flag_fill, color: Color(0xFFE53935)),
                        label: Text('Exit Strategy & Alerts', style: GoogleFonts.poppins(color: const Color(0xFFE53935), fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE53935)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditPropertySheet(property);
                      },
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFCFB53B)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: Text('Edit', style: GoogleFonts.poppins(color: const Color(0xFFCFB53B), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showAddRentalIncomeSheet(property),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCFB53B), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: Text('Add Income', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0D1B2A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
          Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showAddPropertySheet() => _showPropertySheet(null);
  void _showEditPropertySheet(Asset property) => _showPropertySheet(property);

  void _showPropertySheet(Asset? existing) {
    final isEditing = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final purchaseController = TextEditingController(text: existing?.purchaseValue.toString() ?? '');
    final currentController = TextEditingController(text: existing?.currentValue.toString() ?? '');
    String geography = existing?.geography ?? 'UAE';
    String currency = existing?.currencyCode ?? 'AED';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isEditing ? 'Edit Property' : 'Add Property', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    if (isEditing)
                      IconButton(icon: const Icon(CupertinoIcons.trash, color: Color(0xFFE53935)), onPressed: () async {
                        await _repo!.deleteAsset(existing!.id);
                        Navigator.pop(context);
                        _loadData();
                      }),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Property Name',
                          hintText: 'e.g., Marina Heights Apartment',
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
                                  items: ['UAE', 'India', 'UK', 'USA', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                                  onChanged: (val) => setSheetState(() => geography = val!),
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
                                  items: ['AED', 'INR', 'USD', 'GBP', 'EUR'].map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                                  onChanged: (val) => setSheetState(() => currency = val!),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: purchaseController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Purchase Price',
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
                          labelText: 'Current Market Value',
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter property name')));
                        return;
                      }
                      
                      final purchase = double.tryParse(purchaseController.text) ?? 0;
                      final current = double.tryParse(currentController.text) ?? purchase;
                      
                      final asset = AssetsCompanion(
                        id: isEditing ? Value(existing.id) : Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        name: Value(nameController.text),
                        type: const Value('real_estate'),
                        currencyCode: Value(currency),
                        purchaseValue: Value(purchase),
                        currentValue: Value(current),
                        geography: Value(geography),
                        isLiquid: const Value(false),
                        purchaseDate: Value(DateTime.now()),
                      );
                      
                      if (isEditing) {
                        await _repo!.updateAsset(existing.id, asset);
                      } else {
                        await _repo!.insertAsset(asset);
                      }
                      
                      Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCFB53B), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(isEditing ? 'Update' : 'Add Property', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
  String _formatCompact(double amount) => NumberFormat.compactCurrency(symbol: 'AED ', decimalDigits: 0).format(amount);
  
  void _showDealAnalyzer(Asset property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DealAnalyzerSheet(
        propertyName: property.name,
        purchasePrice: property.purchaseValue,
        currentValue: property.currentValue,
        currency: property.currencyCode,
        geography: property.geography ?? 'UAE',
      ),
    );
  }

  void _showExitStrategySheet(Asset property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => ExitStrategySheet(
          asset: property,
          scrollController: scrollController,
        ),
      ),
    );
  }
  
  void _showAddRentalIncomeSheet(Asset property) {
    final amountController = TextEditingController();
    final tenantController = TextEditingController();
    DateTime selectedMonth = DateTime.now();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: const EdgeInsets.only(bottom: 16), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                Text('Add Rental Income', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(property.name, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54)),
                const SizedBox(height: 20),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount (${property.currencyCode})',
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tenantController,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Tenant Name (optional)',
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final amount = double.tryParse(amountController.text) ?? 0;
                      if (amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid amount')));
                        return;
                      }
                      
                      await _repo!.insertRentalIncome(RentalIncomeCompanion(
                        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        assetId: Value(property.id),
                        currencyCode: Value(property.currencyCode),
                        amount: Value(amount),
                        year: Value(selectedMonth.year),
                        month: Value(selectedMonth.month),
                        tenantName: Value(tenantController.text.isNotEmpty ? tenantController.text : null),
                      ));
                      
                      Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('Save Income', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
