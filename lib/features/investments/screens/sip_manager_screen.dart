import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

/// SIP Manager - View and manage Systematic Investment Plans
class SIPManagerScreen extends StatefulWidget {
  const SIPManagerScreen({super.key});

  @override
  State<SIPManagerScreen> createState() => _SIPManagerScreenState();
}

class _SIPManagerScreenState extends State<SIPManagerScreen> {
  AppRepository? _repo;
  List<SipRecord> _sips = [];
  List<Asset> _assets = [];
  bool _isLoading = true;
  double _totalMonthlySIP = 0;
  double _totalAnnualSIP = 0;

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
      final sips = await _repo!.getAllSipRecords();
      if (!mounted) return;
      final assets = await _repo!.getAllAssets();
      if (!mounted) return;
      final activeSips = sips.where((s) => s.isActive).toList();
      final monthlyTotal = activeSips.fold(0.0, (sum, s) => sum + s.amount);

      if (!mounted) return;
      setState(() {
        _sips = sips;
        _assets = assets;
        _totalMonthlySIP = monthlyTotal;
        _totalAnnualSIP = monthlyTotal * 12;
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
        title: Text('SIP Manager', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B)))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  _buildSummaryCard(),
                  _buildSIPList(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSIPSheet(null),
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add SIP', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildSummaryCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
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
                    Text('Monthly SIP', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(_totalMonthlySIP),
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
                      const Icon(Icons.event_repeat, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text('${_sips.where((s) => s.isActive).length} Active', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
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
                      Text('Annual Investment', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text(_formatCurrency(_totalAnnualSIP), style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total SIPs', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                      Text('${_sips.length}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildSIPList() {
    if (_sips.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_repeat, size: 64, color: Colors.white24),
              const SizedBox(height: 16),
              Text('No SIPs yet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white54)),
              const SizedBox(height: 8),
              Text('Add systematic investment plans', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38)),
            ],
          ).animate().fadeIn(),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildSIPCard(_sips[index]).animate(delay: (index * 80).ms).fadeIn().slideX(begin: 0.05),
          childCount: _sips.length,
        ),
      ),
    );
  }

  Widget _buildSIPCard(SipRecord sip) {
    final asset = _assets.where((a) => a.id == sip.assetId).firstOrNull;
    final nextDate = _getNextSIPDate(sip.dayOfMonth);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sip.isActive ? const Color(0xFF10B981).withValues(alpha: 0.3) : const Color(0xFF2A3A5A)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: sip.isActive ? const Color(0xFF10B981).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.event_repeat,
            color: sip.isActive ? const Color(0xFF10B981) : Colors.white38,
            size: 24,
          ),
        ),
        title: Text(
          sip.name,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (asset != null)
              Text('→ ${asset.name}', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.white38),
                const SizedBox(width: 4),
                Text('Day ${sip.dayOfMonth} • Next: ${DateFormat('dd MMM').format(nextDate)}',
                    style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_formatCurrency(sip.amount), style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: sip.isActive ? const Color(0xFF10B981).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                sip.isActive ? 'Active' : 'Paused',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: sip.isActive ? const Color(0xFF10B981) : Colors.white54,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showAddSIPSheet(sip),
        onLongPress: () => _confirmDeleteSIP(sip),
      ),
    );
  }

  DateTime _getNextSIPDate(int dayOfMonth) {
    final now = DateTime.now();
    var nextDate = DateTime(now.year, now.month, dayOfMonth);
    if (nextDate.isBefore(now)) {
      nextDate = DateTime(now.year, now.month + 1, dayOfMonth);
    }
    return nextDate;
  }

  void _showAddSIPSheet(SipRecord? existing) {
    final isEditing = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final amountController = TextEditingController(text: existing?.amount.toStringAsFixed(0) ?? '');
    String? selectedAssetId = existing?.assetId;
    int dayOfMonth = existing?.dayOfMonth ?? 1;
    bool isActive = existing?.isActive ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: const EdgeInsets.only(bottom: 16), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                Text(isEditing ? 'Edit SIP' : 'Add SIP', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                
                // Name
                TextField(
                  controller: nameController,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'SIP Name',
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
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
                
                // Asset Dropdown
                DropdownButtonFormField<String>(
                  value: selectedAssetId,
                  dropdownColor: const Color(0xFF1A2744),
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Target Investment',
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: _assets
                      .where((a) => a.type != 'real_estate')
                      .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                      .toList(),
                  onChanged: (value) => setModalState(() => selectedAssetId = value),
                ),
                const SizedBox(height: 12),
                
                // Day of Month
                Row(
                  children: [
                    Expanded(
                      child: Text('SIP Day of Month', style: GoogleFonts.inter(color: Colors.white60)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1B2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white54),
                            onPressed: () => setModalState(() => dayOfMonth = (dayOfMonth - 1).clamp(1, 28)),
                          ),
                          Text('$dayOfMonth', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white54),
                            onPressed: () => setModalState(() => dayOfMonth = (dayOfMonth + 1).clamp(1, 28)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Active Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active', style: GoogleFonts.inter(color: Colors.white60)),
                    CupertinoSwitch(
                      value: isActive,
                      activeTrackColor: const Color(0xFF10B981),
                      onChanged: (value) => setModalState(() => isActive = value),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty || selectedAssetId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                        return;
                      }
                      
                      final amount = double.tryParse(amountController.text) ?? 0;
                      final companion = SipRecordsCompanion(
                        id: isEditing ? Value(existing.id) : Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        assetId: Value(selectedAssetId!),
                        name: Value(nameController.text),
                        amount: Value(amount),
                        currencyCode: const Value('AED'),
                        dayOfMonth: Value(dayOfMonth),
                        isActive: Value(isActive),
                        startDate: isEditing ? Value(existing.startDate) : Value(DateTime.now()),
                      );
                      
                      if (isEditing) {
                        await _repo!.updateSipRecord(existing.id, companion);
                      } else {
                        await _repo!.insertSipRecord(companion);
                      }
                      
                      Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? 'Update SIP' : 'Add SIP', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteSIP(SipRecord sip) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete SIP?'),
        content: Text('Are you sure you want to delete "${sip.name}"?'),
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
              await _repo!.deleteSipRecord(sip.id);
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
