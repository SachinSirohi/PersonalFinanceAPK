import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';
import '../widgets/goal_detail_sheet.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  AppRepository? _repo;
  List<Goal> _goals = [];
  bool _isLoading = true;
  
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
    
    final goals = await _repo!.getAllGoals();
    
    setState(() {
      _goals = goals;
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
          _buildSummaryCard(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B))),
            )
          else if (_goals.isEmpty)
            _buildEmptyState()
          else
            _buildGoalsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalSheet(),
        backgroundColor: const Color(0xFFCFB53B),
        icon: const Icon(CupertinoIcons.add, color: Colors.black),
        label: Text('Add Goal', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
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
        title: Text('Financial Goals', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalTarget = _goals.fold(0.0, (sum, g) => sum + g.targetAmount);
    final activeCount = _goals.where((g) => g.status == 'active').length;
    final achievedCount = _goals.where((g) => g.status == 'achieved').length;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goals Overview', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            Text(_formatCurrency(totalTarget), style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text('Total Target Amount', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStat('Active', activeCount.toString(), const Color(0xFF4CAF50)),
                const SizedBox(width: 24),
                _buildStat('Achieved', achievedCount.toString(), const Color(0xFFCFB53B)),
                const SizedBox(width: 24),
                _buildStat('Total', _goals.length.toString(), Colors.white),
              ],
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: GoogleFonts.poppins(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.flag_fill, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text('No goals yet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white54)),
            const SizedBox(height: 8),
            Text('Set financial goals to track your progress', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38)),
          ],
        ).animate().fadeIn(),
      ),
    );
  }

  Widget _buildGoalsList() {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final goal = _goals[index];
            return _buildGoalCard(goal).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.05);
          },
          childCount: _goals.length,
        ),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    final isPastDue = daysLeft < 0;
    final isAchieved = goal.status == 'achieved';
    
    Color getStatusColor() {
      if (isAchieved) return const Color(0xFF4CAF50);
      if (isPastDue) return const Color(0xFFE53935);
      if (goal.priority == 'high') return const Color(0xFFFF9800);
      return const Color(0xFF2196F3);
    }
    
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
            color: getStatusColor().withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isAchieved ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.flag_fill,
            color: getStatusColor(),
            size: 24,
          ),
        ),
        title: Text(goal.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target: ${_formatCurrency(goal.targetAmount)}',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
            ),
            Text(
              isPastDue 
                  ? 'Past due by ${daysLeft.abs()} days' 
                  : isAchieved 
                      ? 'Achieved!' 
                      : '$daysLeft days left',
              style: GoogleFonts.poppins(
                color: isPastDue ? const Color(0xFFE53935) : isAchieved ? const Color(0xFF4CAF50) : Colors.white38,
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: getStatusColor().withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                goal.priority.toUpperCase(),
                style: GoogleFonts.poppins(color: getStatusColor(), fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM yyyy').format(goal.targetDate),
              style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
        onTap: () => _showGoalDetailSheet(goal),
        onLongPress: () => _showEditGoalSheet(goal),
      ),
    );
  }

  void _showAddGoalSheet() => _showGoalSheet(null);
  void _showEditGoalSheet(Goal goal) => _showGoalSheet(goal);
  
  void _showGoalDetailSheet(Goal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GoalDetailSheet(goal: goal),
    ).then((_) => _loadData());
  }

  void _showGoalSheet(Goal? existing) {
    final isEditing = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final targetController = TextEditingController(text: existing?.targetAmount.toString() ?? '');
    String priority = existing?.priority ?? 'medium';
    DateTime targetDate = existing?.targetDate ?? DateTime.now().add(const Duration(days: 365));
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isEditing ? 'Edit Goal' : 'Add Goal', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    if (isEditing)
                      IconButton(
                        icon: const Icon(CupertinoIcons.trash, color: Color(0xFFE53935)),
                        onPressed: () async {
                          await _repo!.deleteGoal(existing.id);
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
                      TextField(
                        controller: nameController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Goal Name',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: targetController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Target Amount',
                          prefixText: 'AED ',
                          prefixStyle: GoogleFonts.poppins(color: Colors.white54),
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Priority
                      Text('Priority', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: ['low', 'medium', 'high'].map((p) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(p.toUpperCase()),
                              selected: priority == p,
                              onSelected: (sel) => setSheetState(() => priority = p),
                              selectedColor: const Color(0xFFCFB53B),
                              labelStyle: GoogleFonts.poppins(color: priority == p ? Colors.black : Colors.white70, fontSize: 12),
                              backgroundColor: const Color(0xFF0D1B2A),
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                      // Target Date
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Target Date', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                        subtitle: Text(DateFormat('MMMM d, yyyy').format(targetDate), style: GoogleFonts.poppins(color: Colors.white, fontSize: 15)),
                        trailing: const Icon(CupertinoIcons.calendar, color: Color(0xFFCFB53B)),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: targetDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 30)),
                          );
                          if (date != null) setSheetState(() => targetDate = date);
                        },
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter goal name')));
                        return;
                      }
                      
                      final target = double.tryParse(targetController.text) ?? 0;
                      if (target <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid target amount')));
                        return;
                      }
                      
                      final goal = GoalsCompanion(
                        id: isEditing ? Value(existing.id) : Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        name: Value(nameController.text),
                        currencyCode: const Value('AED'),
                        targetAmount: Value(target),
                        targetDate: Value(targetDate),
                        priority: Value(priority),
                        status: const Value('active'),
                      );
                      
                      if (isEditing) {
                        await _repo!.updateGoal(existing.id, goal);
                      } else {
                        await _repo!.insertGoal(goal);
                      }
                      
                      if (mounted) Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCFB53B), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(isEditing ? 'Update' : 'Add Goal', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
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
}
