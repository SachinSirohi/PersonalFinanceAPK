import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

/// Dividend Tracker - View and manage dividend income from investments
class DividendTrackerScreen extends StatefulWidget {
  const DividendTrackerScreen({super.key});

  @override
  State<DividendTrackerScreen> createState() => _DividendTrackerScreenState();
}

class _DividendTrackerScreenState extends State<DividendTrackerScreen> {
  AppRepository? _repo;
  List<Dividend> _dividends = [];
  List<Asset> _assets = [];
  bool _isLoading = true;
  double _totalDividendsThisYear = 0;
  double _totalDividendsAllTime = 0;
  int _selectedYear = DateTime.now().year;

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
      final dividends = await _repo!.getAllDividends();
      if (!mounted) return;
      final assets = await _repo!.getAllAssets();
      if (!mounted) return;
      
      final yearDividends = dividends.where((d) => d.paymentDate.year == _selectedYear);
      final totalYear = yearDividends.fold(0.0, (sum, d) => sum + d.amount);
      final totalAll = dividends.fold(0.0, (sum, d) => sum + d.amount);

      if (!mounted) return;
      setState(() {
        _dividends = dividends;
        _assets = assets;
        _totalDividendsThisYear = totalYear;
        _totalDividendsAllTime = totalAll;
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Dividend Tracker', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          _buildYearSelector(),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B)))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  _buildSummaryCard(),
                  _buildDividendsByAsset(),
                  _buildDividendList(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDividendSheet(null),
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Dividend', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildYearSelector() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: DropdownButton<int>(
        value: _selectedYear,
        dropdownColor: const Color(0xFF1A2744),
        style: GoogleFonts.inter(color: Colors.white),
        underline: const SizedBox(),
        items: List.generate(5, (i) => DateTime.now().year - i)
            .map((year) => DropdownMenuItem(value: year, child: Text('$year')))
            .toList(),
        onChanged: (year) {
          if (year != null) {
            setState(() => _selectedYear = year);
            _loadData();
          }
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    final yieldRate = _totalDividendsAllTime > 0 && _assets.isNotEmpty
        ? (_totalDividendsThisYear / _assets.fold(0.0, (sum, a) => sum + a.currentValue) * 100)
        : 0.0;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
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
                    Text('Dividends $_selectedYear', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(_totalDividendsThisYear),
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text('${_dividends.where((d) => d.paymentDate.year == _selectedYear).length} Payments', 
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
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
                      Text('All-Time Dividends', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text(_formatCurrency(_totalDividendsAllTime), style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Yield Rate', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text('${yieldRate.toStringAsFixed(2)}%', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildDividendsByAsset() {
    // Group dividends by asset for the selected year
    final yearDividends = _dividends.where((d) => d.paymentDate.year == _selectedYear).toList();
    final assetDividends = <String, double>{};
    
    for (final d in yearDividends) {
      assetDividends[d.assetId] = (assetDividends[d.assetId] ?? 0) + d.amount;
    }
    
    if (assetDividends.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text('By Investment', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: assetDividends.length,
              itemBuilder: (context, index) {
                final assetId = assetDividends.keys.elementAt(index);
                final amount = assetDividends[assetId]!;
                final asset = _assets.where((a) => a.id == assetId).firstOrNull;
                
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2744),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        asset?.name ?? 'Unknown',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(amount),
                        style: GoogleFonts.poppins(color: const Color(0xFF7C3AED), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDividendList() {
    final yearDividends = _dividends.where((d) => d.paymentDate.year == _selectedYear).toList();
    yearDividends.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    
    if (yearDividends.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on_outlined, size: 64, color: Colors.white24),
              const SizedBox(height: 16),
              Text('No dividends in $_selectedYear', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white54)),
              const SizedBox(height: 8),
              Text('Add dividend income', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38)),
            ],
          ).animate().fadeIn(),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildDividendCard(yearDividends[index]).animate(delay: (index * 60).ms).fadeIn().slideX(begin: 0.05),
          childCount: yearDividends.length,
        ),
      ),
    );
  }

  Widget _buildDividendCard(Dividend dividend) {
    final asset = _assets.where((a) => a.id == dividend.assetId).firstOrNull;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A5A)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            dividend.isReinvested ? Icons.replay : Icons.payments,
            color: const Color(0xFF7C3AED),
            size: 22,
          ),
        ),
        title: Text(
          asset?.name ?? 'Unknown Investment',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(DateFormat('dd MMM yyyy').format(dividend.paymentDate), style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                if (dividend.isReinvested) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('DRIP', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                  ),
                ],
              ],
            ),
            if (dividend.dividendType != 'cash')
              Text(dividend.dividendType.toUpperCase(), style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
          ],
        ),
        trailing: Text(
          _formatCurrency(dividend.amount),
          style: GoogleFonts.poppins(color: const Color(0xFF10B981), fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onTap: () => _showAddDividendSheet(dividend),
        onLongPress: () => _confirmDeleteDividend(dividend),
      ),
    );
  }

  void _showAddDividendSheet(Dividend? existing) {
    final isEditing = existing != null;
    final amountController = TextEditingController(text: existing?.amount.toStringAsFixed(0) ?? '');
    String? selectedAssetId = existing?.assetId;
    DateTime paymentDate = existing?.paymentDate ?? DateTime.now();
    DateTime exDate = existing?.exDate ?? DateTime.now().subtract(const Duration(days: 7));
    String dividendType = existing?.dividendType ?? 'cash';
    bool isReinvested = existing?.isReinvested ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: const EdgeInsets.only(bottom: 16), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                Text(isEditing ? 'Edit Dividend' : 'Add Dividend', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                
                // Asset Dropdown
                DropdownButtonFormField<String>(
                  value: selectedAssetId,
                  dropdownColor: const Color(0xFF1A2744),
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Investment',
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: _assets.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                  onChanged: (value) => setModalState(() => selectedAssetId = value),
                ),
                const SizedBox(height: 12),
                
                // Amount
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount (AED)',
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Dates Row
                Row(
                  children: [
                    Expanded(
                      child: _buildDateButton('Ex-Date', exDate, (date) => setModalState(() => exDate = date)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateButton('Payment', paymentDate, (date) => setModalState(() => paymentDate = date)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Type Selector
                Row(
                  children: [
                    Text('Type: ', style: GoogleFonts.inter(color: Colors.white60)),
                    const SizedBox(width: 12),
                    ...['cash', 'stock', 'special'].map((type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type.toUpperCase()),
                        selected: dividendType == type,
                        selectedColor: const Color(0xFF7C3AED),
                        labelStyle: GoogleFonts.inter(fontSize: 11, color: dividendType == type ? Colors.white : Colors.white60),
                        onSelected: (selected) => setModalState(() => dividendType = type),
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Reinvested Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reinvested (DRIP)', style: GoogleFonts.inter(color: Colors.white60)),
                    CupertinoSwitch(
                      value: isReinvested,
                      activeTrackColor: const Color(0xFF10B981),
                      onChanged: (value) => setModalState(() => isReinvested = value),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedAssetId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an investment')));
                        return;
                      }
                      
                      final amount = double.tryParse(amountController.text) ?? 0;
                      final companion = DividendsCompanion(
                        id: isEditing ? Value(existing.id) : Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        assetId: Value(selectedAssetId!),
                        amount: Value(amount),
                        currencyCode: const Value('AED'),
                        exDate: Value(exDate),
                        paymentDate: Value(paymentDate),
                        dividendType: Value(dividendType),
                        isReinvested: Value(isReinvested),
                      );
                      
                      if (isEditing) {
                        await _repo!.updateDividend(existing.id, companion);
                      } else {
                        await _repo!.insertDividend(companion);
                      }
                      
                      Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? 'Update' : 'Add Dividend', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime date, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 4),
            Text(DateFormat('dd MMM').format(date), style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteDividend(Dividend dividend) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Dividend?'),
        content: Text('Delete ${_formatCurrency(dividend.amount)} dividend?'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await _repo!.deleteDividend(dividend.id);
              _loadData();
              HapticFeedback.mediumImpact();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
}
