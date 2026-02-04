import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

class ExitStrategySheet extends StatefulWidget {
  final Asset asset;
  final ScrollController scrollController;

  const ExitStrategySheet({
    super.key,
    required this.asset,
    required this.scrollController,
  });

  @override
  State<ExitStrategySheet> createState() => _ExitStrategySheetState();
}

class _ExitStrategySheetState extends State<ExitStrategySheet> {
  AppRepository? _repo;
  List<PropertyExitRule> _rules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _repo = await AppRepository.getInstance();
    final rules = await _repo!.getExitRulesForAsset(widget.asset.id);
    if (mounted) {
      setState(() {
        _rules = rules;
        _isLoading = false;
      });
    }
  }

  void _showAddRuleDialog() {
    String selectedType = 'irr_threshold';
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2744),
        title: Text('Add Exit Rule', style: GoogleFonts.poppins(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedType,
                dropdownColor: const Color(0xFF2A3A5A),
                style: GoogleFonts.poppins(color: Colors.white),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'irr_threshold', child: Text('Target IRR (%)')),
                  DropdownMenuItem(value: 'equity_threshold', child: Text('Target Equity (%)')),
                  DropdownMenuItem(value: 'profit_threshold', child: Text('Target Profit (Amount)')),
                  DropdownMenuItem(value: 'holding_period', child: Text('Holding Period (Years)')),
                ],
                onChanged: (val) {
                  setDialogState(() => selectedType = val!);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Threshold Value',
                  labelStyle: const TextStyle(color: Colors.white70),
                  suffixText: _getSuffix(selectedType),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFCFB53B))),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCFB53B)),
            child: const Text('Add Rule', style: TextStyle(color: Colors.black)),
            onPressed: () async {
              if (valueController.text.isEmpty) return;
              
              final rule = PropertyExitRulesCompanion(
                id: drift.Value(const Uuid().v4()),
                assetId: drift.Value(widget.asset.id),
                ruleType: drift.Value(selectedType),
                thresholdValue: drift.Value(double.parse(valueController.text)),
                isTriggered: const drift.Value(false),
                createdAt: drift.Value(DateTime.now()),
              );
              
              await _repo!.insertExitRule(rule);
              Navigator.pop(context);
              _loadData(); // Refresh list
            },
          ),
        ],
      ),
    );
  }

  String _getSuffix(String type) {
    switch (type) {
      case 'irr_threshold': return '%';
      case 'equity_threshold': return '%';
      case 'holding_period': return 'Years';
      default: return '';
    }
  }

  Future<void> _deleteRule(String id) async {
    await _repo!.deleteExitRule(id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A1628),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exit Strategy', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(widget.asset.name, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54)),
                  ],
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.add_circled_solid, color: Color(0xFFCFB53B), size: 32),
                  onPressed: _showAddRuleDialog,
                ),
              ],
            ),
          ),
          
          const Divider(color: Colors.white10),
          
          // Rules List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B)))
                : _rules.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.flag_slash, size: 48, color: Colors.white24),
                            const SizedBox(height: 16),
                            Text('No exit rules defined', style: GoogleFonts.poppins(color: Colors.white54)),
                            TextButton(onPressed: _showAddRuleDialog, child: const Text('Add your first rule')),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: widget.scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount: _rules.length,
                        itemBuilder: (context, index) {
                          final rule = _rules[index];
                          return Dismissible(
                            key: Key(rule.id),
                            onDismissed: (_) => _deleteRule(rule.id),
                            background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A2744),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: rule.isTriggered ? const Color(0xFF4CAF50) : const Color(0xFF2A3A5A),
                                  width: rule.isTriggered ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: rule.isTriggered ? const Color(0xFF4CAF50).withOpacity(0.2) : const Color(0xFF2A3A5A),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      rule.isTriggered ? Icons.check_circle : CupertinoIcons.scope,
                                      color: rule.isTriggered ? const Color(0xFF4CAF50) : const Color(0xFFCFB53B),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatRuleType(rule.ruleType),
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
                                        ),
                                        Text(
                                          'Target: ${_formatRuleValue(rule.ruleType, rule.thresholdValue)}',
                                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (rule.isTriggered)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(8)),
                                      child: Text('READY', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _formatRuleType(String type) {
    switch (type) {
      case 'irr_threshold': return 'Target IRR';
      case 'equity_threshold': return 'Target Equity';
      case 'profit_threshold': return 'Target Profit';
      case 'holding_period': return 'Holding Period';
      default: return type;
    }
  }

  String _formatRuleValue(String type, double value) {
    switch (type) {
      case 'irr_threshold': return '${value.toStringAsFixed(1)}%';
      case 'equity_threshold': return '${value.toStringAsFixed(1)}%';
      case 'holding_period': return '${value.toStringAsFixed(1)} Years';
      default: return value.toStringAsFixed(0);
    }
  }
}
