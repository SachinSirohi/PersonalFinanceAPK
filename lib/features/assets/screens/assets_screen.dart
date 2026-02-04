import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  AppRepository? _repo;
  List<Asset> _assets = [];
  bool _isLoading = true;
  double _totalValue = 0;
  
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
      final assets = await _repo!.getAllAssets();
      if (!mounted) return;
      final total = assets.fold(0.0, (sum, a) => sum + a.currentValue);
      
      if (!mounted) return;
      setState(() {
        _assets = assets;
        _totalValue = total;
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
          _buildTotalCard(),
          _buildAssetBreakdown(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B))),
            )
          else if (_assets.isEmpty)
            _buildEmptyState()
          else
            _buildAssetList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAssetSheet(),
        backgroundColor: const Color(0xFFCFB53B),
        icon: const Icon(CupertinoIcons.add, color: Colors.black),
        label: Text('Add Asset', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
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
        title: Text(
          'Assets',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
    );
  }

  Widget _buildTotalCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFCFB53B), const Color(0xFFB8963A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCFB53B).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Asset Value', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              _formatCurrency(_totalValue),
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('${_assets.length} assets tracked', style: GoogleFonts.poppins(color: Colors.black38, fontSize: 12)),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildAssetBreakdown() {
    final byType = <String, double>{};
    for (var a in _assets) {
      byType[a.type] = (byType[a.type] ?? 0) + a.currentValue;
    }
    
    if (byType.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2744),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A3A5A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Allocation', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            ...byType.entries.map((e) {
              final percent = _totalValue > 0 ? (e.value / _totalValue * 100) : 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getTypeLabel(e.key), style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
                        Text('${percent.toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percent / 100,
                      backgroundColor: const Color(0xFF0D1B2A),
                      valueColor: AlwaysStoppedAnimation(_getTypeColor(e.key)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms),
    );
  }

  String _getTypeLabel(String type) {
    final labels = {
      'real_estate': 'Real Estate',
      'stocks': 'Stocks',
      'mutual_funds': 'Mutual Funds',
      'fixed_deposit': 'Fixed Deposits',
      'gold': 'Gold',
      'crypto': 'Cryptocurrency',
      'ppf': 'PPF',
      'nps': 'NPS',
      'other': 'Other',
    };
    return labels[type] ?? type.toUpperCase();
  }

  Color _getTypeColor(String type) {
    final colors = {
      'real_estate': const Color(0xFF1976D2),
      'stocks': const Color(0xFF4CAF50),
      'mutual_funds': const Color(0xFF7C4DFF),
      'fixed_deposit': const Color(0xFFFF9800),
      'gold': const Color(0xFFCFB53B),
      'crypto': const Color(0xFFE91E63),
      'ppf': const Color(0xFF00BCD4),
      'nps': const Color(0xFF009688),
      'other': const Color(0xFF607D8B),
    };
    return colors[type] ?? Colors.grey;
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.chart_pie, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text('No assets yet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white54)),
            const SizedBox(height: 8),
            Text('Add your investments & properties', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38)),
          ],
        ).animate().fadeIn(),
      ),
    );
  }

  Widget _buildAssetList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final asset = _assets[index];
          return _buildAssetTile(asset).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.05);
        },
        childCount: _assets.length,
      ),
    );
  }

  Widget _buildAssetTile(Asset asset) {
    final gain = asset.currentValue - asset.purchaseValue;
    final gainPercent = asset.purchaseValue > 0 ? (gain / asset.purchaseValue * 100) : 0;
    final isPositive = gain >= 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A5A), width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getTypeColor(asset.type).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getTypeIcon(asset.type), color: _getTypeColor(asset.type), size: 24),
        ),
        title: Text(
          asset.name,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getTypeLabel(asset.type), style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
            if (asset.geography != null)
              Text(asset.geography!, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatCurrency(asset.currentValue),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down,
                  color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                  size: 12,
                ),
                Text(
                  '${gainPercent.abs().toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                    color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showEditAssetSheet(asset),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    final icons = {
      'real_estate': CupertinoIcons.house_fill,
      'stocks': CupertinoIcons.graph_square_fill,
      'mutual_funds': CupertinoIcons.chart_pie_fill,
      'fixed_deposit': CupertinoIcons.lock_fill,
      'gold': CupertinoIcons.gift_fill,
      'crypto': CupertinoIcons.bitcoin,
      'ppf': CupertinoIcons.shield_fill,
      'nps': CupertinoIcons.person_crop_circle_fill,
      'other': CupertinoIcons.cube_fill,
    };
    return icons[type] ?? CupertinoIcons.circle;
  }

  void _showAddAssetSheet() => _showAssetSheet(null);
  void _showEditAssetSheet(Asset asset) => _showAssetSheet(asset);

  void _showAssetSheet(Asset? existing) {
    final isEditing = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final purchaseValueController = TextEditingController(text: existing?.purchaseValue.toString() ?? '');
    final currentValueController = TextEditingController(text: existing?.currentValue.toString() ?? '');
    final geographyController = TextEditingController(text: existing?.geography ?? '');
    String type = existing?.type ?? 'stocks';
    String currency = existing?.currencyCode ?? 'AED';
    bool isLiquid = existing?.isLiquid ?? true;
    
    final types = ['real_estate', 'stocks', 'mutual_funds', 'fixed_deposit', 'gold', 'crypto', 'ppf', 'nps', 'other'];
    final currencies = ['AED', 'USD', 'INR', 'EUR', 'GBP'];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF1A2744),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Asset' : 'Add Asset',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    if (isEditing)
                      IconButton(
                        icon: const Icon(CupertinoIcons.trash, color: Color(0xFFE53935)),
                        onPressed: () async {
                          await _repo!.deleteAsset(existing!.id);
                          Navigator.pop(context);
                          _loadData();
                          HapticFeedback.heavyImpact();
                        },
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Asset Name
                      TextField(
                        controller: nameController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Asset Name',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Asset Type
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: type,
                            dropdownColor: const Color(0xFF1A2744),
                            isExpanded: true,
                            items: types.map((t) => DropdownMenuItem(value: t, child: Text(_getTypeLabel(t), style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                            onChanged: (val) => setSheetState(() => type = val!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Currency
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currency,
                            dropdownColor: const Color(0xFF1A2744),
                            isExpanded: true,
                            items: currencies.map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                            onChanged: (val) => setSheetState(() => currency = val!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Purchase Value
                      TextField(
                        controller: purchaseValueController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Purchase Value',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Current Value
                      TextField(
                        controller: currentValueController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Current Value',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Geography
                      TextField(
                        controller: geographyController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Geography (e.g., UAE, India)',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Liquid Toggle
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Liquid Asset', style: GoogleFonts.poppins(color: Colors.white)),
                            CupertinoSwitch(
                              value: isLiquid,
                              activeTrackColor: const Color(0xFFCFB53B),
                              onChanged: (val) => setSheetState(() => isLiquid = val),
                            ),
                          ],
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter asset name')));
                        return;
                      }
                      
                      final purchaseValue = double.tryParse(purchaseValueController.text) ?? 0;
                      final currentValue = double.tryParse(currentValueController.text) ?? purchaseValue;
                      
                      final asset = AssetsCompanion(
                        id: isEditing ? Value(existing.id) : Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        name: Value(nameController.text),
                        type: Value(type),
                        currencyCode: Value(currency),
                        purchaseValue: Value(purchaseValue),
                        currentValue: Value(currentValue),
                        geography: Value(geographyController.text.isNotEmpty ? geographyController.text : 'UAE'),
                        isLiquid: Value(isLiquid),
                        purchaseDate: Value(DateTime.now()),
                      );
                      
                      if (isEditing) {
                        await _repo!.updateAsset(existing!.id, asset);
                      } else {
                        await _repo!.insertAsset(asset);
                      }
                      
                      Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCFB53B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? 'Update' : 'Add Asset', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
  }
}
