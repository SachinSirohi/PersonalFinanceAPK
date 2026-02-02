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

/// Goal Detail Sheet - Asset linking, progress tracking, SIP recommendations, what-if analysis
class GoalDetailSheet extends StatefulWidget {
  final Goal goal;
  
  const GoalDetailSheet({super.key, required this.goal});
  
  @override
  State<GoalDetailSheet> createState() => _GoalDetailSheetState();
}

class _GoalDetailSheetState extends State<GoalDetailSheet> {
  AppRepository? _repo;
  List<GoalAssetMapping> _mappings = [];
  List<Asset> _assets = [];
  List<Asset> _linkedAssets = [];
  double _currentProgress = 0;
  double _shortfall = 0;
  bool _isLoading = true;
  
  // What-if parameters
  double _expectedReturn = 10.0;
  
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
    
    final mappings = await _repo!.getGoalAssetMappings(widget.goal.id);
    final assets = await _repo!.getAllAssets();
    
    // Calculate linked assets and progress
    final linkedAssets = <Asset>[];
    double progress = 0;
    
    for (final mapping in mappings) {
      final asset = assets.where((a) => a.id == mapping.assetId).firstOrNull;
      if (asset != null) {
        linkedAssets.add(asset);
        progress += asset.currentValue * (mapping.allocationPercent / 100);
      }
    }
    
    setState(() {
      _mappings = mappings;
      _assets = assets;
      _linkedAssets = linkedAssets;
      _currentProgress = progress;
      _shortfall = (widget.goal.targetAmount - progress).clamp(0, double.infinity);
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF1A2744),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressCard(),
                        const SizedBox(height: 20),
                        _buildLinkedAssets(),
                        const SizedBox(height: 20),
                        _buildSIPRecommendation(),
                        const SizedBox(height: 20),
                        _buildWhatIfAnalysis(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    final daysLeft = widget.goal.targetDate.difference(DateTime.now()).inDays;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)), margin: const EdgeInsets.only(bottom: 16)),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(CupertinoIcons.flag_fill, color: Color(0xFF7C4DFF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.goal.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(
                      '${daysLeft > 0 ? daysLeft : 0} days left • ${DateFormat('MMM yyyy').format(widget.goal.targetDate)}',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressCard() {
    final progressPercent = widget.goal.targetAmount > 0 
        ? (_currentProgress / widget.goal.targetAmount * 100).clamp(0.0, 100.0) 
        : 0.0;
    final isOnTrack = progressPercent >= 50 || _shortfall == 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOnTrack 
              ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
              : [const Color(0xFFFF9800), const Color(0xFFF57C00)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                  Text(_formatCurrency(_currentProgress), style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Target', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                  Text(_formatCurrency(widget.goal.targetAmount), style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressPercent / 100,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${progressPercent.toStringAsFixed(1)}% complete', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
              if (_shortfall > 0)
                Text('Shortfall: ${_formatCurrency(_shortfall)}', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }
  
  Widget _buildLinkedAssets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Linked Assets', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            TextButton.icon(
              onPressed: _showLinkAssetSheet,
              icon: const Icon(Icons.add, color: Color(0xFFCFB53B), size: 18),
              label: Text('Link', style: GoogleFonts.inter(color: const Color(0xFFCFB53B), fontSize: 12)),
            ),
          ],
        ),
        if (_linkedAssets.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Icon(Icons.link_off, color: Colors.white24, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No assets linked', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
                      Text('Link investments to track goal progress', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          ...List.generate(_linkedAssets.length, (index) {
            final asset = _linkedAssets[index];
            final mapping = _mappings.where((m) => m.assetId == asset.id).firstOrNull;
            final allocation = mapping?.allocationPercent ?? 0;
            final contribution = asset.currentValue * (allocation / 100);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance, color: Color(0xFF4CAF50), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(asset.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        Text('${allocation.toStringAsFixed(0)}% allocated • ${_formatCurrency(contribution)}', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _repo!.deleteGoalAssetMapping(widget.goal.id, asset.id);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    icon: const Icon(Icons.link_off, color: Colors.white38, size: 18),
                  ),
                ],
              ),
            ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.05);
          }),
      ],
    );
  }
  
  Widget _buildSIPRecommendation() {
    if (_shortfall <= 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Goal on Track!', style: GoogleFonts.poppins(color: const Color(0xFF4CAF50), fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('You have enough assets linked to meet this goal.', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1);
    }
    
    final daysLeft = widget.goal.targetDate.difference(DateTime.now()).inDays.clamp(1, 36500);
    final monthsLeft = (daysLeft / 30).ceil().clamp(1, 1200);
    
    // Calculate SIP needed with expected return
    final sipNeeded = FinancialCalculations.calculateMonthlySIPForGoal(
      _shortfall,
      _expectedReturn,
      monthsLeft,
    );
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF0D47A1)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text('SIP Recommendation', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          Text('To cover the shortfall of ${_formatCurrency(_shortfall)}:', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recommended SIP', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
                    Text(_formatCurrency(sipNeeded), style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('per month', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('for $monthsLeft months', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                    Text('@ ${_expectedReturn.toStringAsFixed(1)}% p.a.', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('Assumptions: ${_expectedReturn.toStringAsFixed(1)}% annual return, compounded monthly', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10)),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
  
  Widget _buildWhatIfAnalysis() {
    final daysLeft = widget.goal.targetDate.difference(DateTime.now()).inDays.clamp(1, 36500);
    final monthsLeft = (daysLeft / 30).ceil().clamp(1, 1200);
    
    // Calculate different scenarios
    final scenarios = [
      {'label': 'Conservative', 'return': 6.0, 'color': const Color(0xFF64B5F6)},
      {'label': 'Moderate', 'return': 10.0, 'color': const Color(0xFF4CAF50)},
      {'label': 'Aggressive', 'return': 15.0, 'color': const Color(0xFFFF9800)},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What-If Analysis', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('SIP needed at different return rates', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 12),
        ...scenarios.map((scenario) {
          final rate = scenario['return'] as double;
          final label = scenario['label'] as String;
          final color = scenario['color'] as Color;
          
          final sip = _shortfall > 0
              ? FinancialCalculations.calculateMonthlySIPForGoal(_shortfall, rate, monthsLeft)
              : 0.0;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 40,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      Text('${rate.toStringAsFixed(0)}% annual return', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                Text(
                  _shortfall > 0 ? _formatCurrency(sip) : 'N/A',
                  style: GoogleFonts.poppins(color: color, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('/mo', style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        
        // Custom Scenario Slider
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Custom Scenario', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Expected Return: ', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                  Text('${_expectedReturn.toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: const Color(0xFFCFB53B), fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: _expectedReturn,
                min: 1,
                max: 25,
                divisions: 24,
                activeColor: const Color(0xFFCFB53B),
                onChanged: (value) => setState(() => _expectedReturn = value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1%', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10)),
                  Text('25%', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _showLinkAssetSheet() {
    final availableAssets = _assets.where((a) => !_linkedAssets.any((la) => la.id == a.id)).toList();
    String? selectedAssetId;
    double allocation = 100;
    
    if (availableAssets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more assets to link')));
      return;
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Color(0xFF0D1B2A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Link Asset to Goal', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              
              // Asset Dropdown
              DropdownButtonFormField<String>(
                value: selectedAssetId,
                dropdownColor: const Color(0xFF1A2744),
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Select Asset',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1A2744),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: availableAssets.map((a) => DropdownMenuItem(
                  value: a.id,
                  child: Text('${a.name} (${_formatCurrency(a.currentValue)})'),
                )).toList(),
                onChanged: (value) => setModalState(() => selectedAssetId = value),
              ),
              const SizedBox(height: 16),
              
              // Allocation Slider
              Text('Allocation: ${allocation.toStringAsFixed(0)}%', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
              Slider(
                value: allocation,
                min: 1,
                max: 100,
                divisions: 99,
                activeColor: const Color(0xFFCFB53B),
                onChanged: (value) => setModalState(() => allocation = value),
              ),
              Text('How much of this asset to allocate to the goal', style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedAssetId == null ? null : () async {
                    await _repo!.insertGoalAssetMapping(GoalAssetMappingsCompanion(
                      goalId: Value(widget.goal.id),
                      assetId: Value(selectedAssetId!),
                      allocationPercent: Value(allocation),
                    ));
                    Navigator.pop(context);
                    _loadData();
                    HapticFeedback.mediumImpact();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCFB53B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Link Asset', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
}
