import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../settings/screens/statement_automation_screen.dart';
import '../../goals/screens/goals_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../investments/screens/investments_screen.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../data/services/insights_service.dart';
import '../widgets/insight_carousel.dart';
import '../../ai_chat/screens/ai_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedCurrency = 'AED';
  bool _showNetWorth = true;
  
  // Mock data - will be replaced with real data from database
  final double _netWorth = 1250000;
  final double _emergencyFund = 45000;
  final double _emergencyTarget = 60000;
  final double _monthlySpending = 15000;
  final double _monthlyBudget = 20000;
  
  AppRepository? _repo;
  InsightsService? _insightsService;
  List<FinancialInsight> _activeInsights = [];
  bool _isLoadingInsights = true;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    try {
      _repo = await AppRepository.getInstance();
      if (!mounted) return;
      _insightsService = InsightsService(_repo!);
      await _refreshInsights();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingInsights = false);
      }
    }
  }
  
  Future<void> _refreshInsights() async {
    try {
      await _insightsService!.generateInsights();
      final insights = await _repo!.getActiveInsights();
      if (mounted) {
        setState(() {
          _activeInsights = insights;
          _isLoadingInsights = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingInsights = false);
      }
    }
  }

  Future<void> _dismissInsight(String id) async {
    await _repo!.dismissInsight(id);
    _refreshInsights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFF0A1628),
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(CupertinoIcons.globe, color: Color(0xFFCFB53B), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'WealthOrbit',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              // Currency Selector
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    icon: const Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.white70),
                    dropdownColor: const Color(0xFF1A2744),
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                    items: ['AED', 'USD', 'INR', 'EUR'].map((c) => 
                      DropdownMenuItem(value: c, child: Text(c))
                    ).toList(),
                    onChanged: (v) => setState(() => _selectedCurrency = v!),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.bell, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (_activeInsights.isNotEmpty)
                  InsightCarousel(
                    insights: _activeInsights,
                    onDismiss: _dismissInsight,
                  ).animate().fade(duration: 500.ms).slideY(begin: -0.1, end: 0),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(
                    children: [
                      // Net Worth Card
                      _buildNetWorthCard(),
                      
                      const SizedBox(height: 20),
                      
                      // Emergency Fund & Sync Status
                      Row(
                        children: [
                          Expanded(child: _buildEmergencyFundCard()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildSyncStatusCard()),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Budget Overview
                      _buildBudgetCard(),
                      
                      const SizedBox(height: 20),
                      
                      // AI Chat Card
                      _buildAiChatCard(),
                      
                      const SizedBox(height: 20),
                      
                      // Quick Actions
                      _buildQuickActions(),
                      
                      const SizedBox(height: 100), // Bottom padding for nav bar
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Bottom Navigation
      bottomNavigationBar: _buildBottomNav(),
      
      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _showQuickAddSheet();
        },
        backgroundColor: const Color(0xFFCFB53B),
        child: const Icon(CupertinoIcons.add, color: Color(0xFF0A1628)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNetWorthCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A2744),
            const Color(0xFF0D47A1).withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFCFB53B).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Net Worth',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _showNetWorth = !_showNetWorth);
                },
                child: Icon(
                  _showNetWorth ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _showNetWorth 
                    ? _formatCurrency(_netWorth)
                    : '••••••',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.arrow_up, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '12.5%',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Mini chart
          SizedBox(
            height: 60,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1000),
                      FlSpot(1, 1050),
                      FlSpot(2, 1020),
                      FlSpot(3, 1150),
                      FlSpot(4, 1180),
                      FlSpot(5, 1250),
                    ],
                    isCurved: true,
                    color: const Color(0xFFCFB53B),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFCFB53B).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildEmergencyFundCard() {
    final percentage = (_emergencyFund / _emergencyTarget * 100).clamp(0, 100);
    final months = (_emergencyFund / (_monthlySpending / 1)).toStringAsFixed(1);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.shield_fill, color: Color(0xFF5AC8FA), size: 18),
              const SizedBox(width: 8),
              Text(
                'Emergency Fund',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$months months',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: percentage >= 100 
                          ? [Colors.green, Colors.green.shade300]
                          : percentage >= 50
                              ? [Colors.orange, Colors.yellow]
                              : [Colors.red, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _showNetWorth 
                ? '${_formatCurrency(_emergencyFund)} / ${_formatCurrency(_emergencyTarget)}'
                : '•••• / ••••',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1);
  }

  Widget _buildSyncStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Sync Status',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Up to Date',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last sync: 2h ago',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSyncBadge('3', 'Banks'),
              const SizedBox(width: 8),
              _buildSyncBadge('2', 'Cards'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1);
  }

  Widget _buildSyncBadge(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFCFB53B).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFCFB53B),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard() {
    final spentPercent = (_monthlySpending / _monthlyBudget * 100).clamp(0.0, 100.0);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Budget',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${spentPercent.toStringAsFixed(0)}% used',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: spentPercent > 80 ? Colors.orange : Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Budget breakdown
          _buildBudgetRow('Needs', 0.50, 8500, 10000, const Color(0xFF5856D6)),
          _buildBudgetRow('Wants', 0.30, 4800, 6000, const Color(0xFFFF9500)),
          _buildBudgetRow('Future', 0.20, 1700, 4000, const Color(0xFF30D158)),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildBudgetRow(String label, double target, double spent, double limit, Color color) {
    final percent = (spent / limit * 100).clamp(0.0, 100.0);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$label (${(target * 100).toInt()}%)',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Text(
                _showNetWorth 
                    ? '${_formatCurrency(spent)} / ${_formatCurrency(limit)}'
                    : '•••• / ••••',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: percent > 90 ? Colors.red : color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiChatCard() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const AiChatScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF5856D6).withOpacity(0.3),
              const Color(0xFF0D47A1).withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF5856D6).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF5856D6).withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                CupertinoIcons.sparkles,
                color: Color(0xFF5856D6),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask WealthOrbit AI',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '"How much did I spend on Uber this month?"',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildQuickActions() {
    final actions = [
      ('Assets', CupertinoIcons.chart_pie, const Color(0xFFCFB53B)),
      ('Goals', CupertinoIcons.flag, const Color(0xFF30D158)),
      ('Statements', CupertinoIcons.doc_text, const Color(0xFF5AC8FA)),
      ('Reports', CupertinoIcons.chart_bar, const Color(0xFFFF9500)),
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: actions.asMap().entries.map((entry) {
            final action = entry.value;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (action.$1 == 'Statements') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementAutomationScreen()));
                  } else if (action.$1 == 'Goals') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsScreen()));
                  } else if (action.$1 == 'Reports') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
                  } else if (action.$1 == 'Assets') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const InvestmentsScreen()));
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: entry.key < 3 ? 12 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2744),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: action.$3.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(action.$2, color: action.$3, size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action.$1,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: Duration(milliseconds: 500 + entry.key * 50))
                  .fadeIn()
                  .scale(begin: const Offset(0.9, 0.9)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(CupertinoIcons.house_fill, 'Home', true),
              _buildNavItem(CupertinoIcons.creditcard, 'Accounts', false),
              const SizedBox(width: 40), // Space for FAB
              _buildNavItem(CupertinoIcons.chart_bar_alt_fill, 'Stats', false),
              _buildNavItem(CupertinoIcons.settings, 'Settings', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        // Navigate based on label
        if (label == 'Accounts') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const InvestmentsScreen()));
        } else if (label == 'Stats') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
        } else if (label == 'Settings') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementAutomationScreen()));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFCFB53B) : Colors.white.withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isActive ? const Color(0xFFCFB53B) : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickAddSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A2744),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Quick Add',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            _buildQuickAddItem(CupertinoIcons.arrow_down_circle, 'Income', Colors.green),
            _buildQuickAddItem(CupertinoIcons.arrow_up_circle, 'Expense', Colors.red),
            _buildQuickAddItem(CupertinoIcons.building_2_fill, 'Asset', const Color(0xFFCFB53B)),
            _buildQuickAddItem(CupertinoIcons.flag_fill, 'Goal', const Color(0xFF5856D6)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddItem(IconData icon, String label, Color color) {
    return ListTile(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
        // TODO: Navigate to add screen
      },
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.white54),
    );
  }

  String _formatCurrency(double amount) {
    final symbols = {'AED': 'د.إ', 'USD': '\$', 'INR': '₹', 'EUR': '€', 'GBP': '£'};
    final symbol = symbols[_selectedCurrency] ?? _selectedCurrency;
    
    if (amount >= 1000000) {
      return '$symbol ${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '$symbol ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '$symbol ${amount.toStringAsFixed(0)}';
  }
}
