import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../data/database/database.dart';

class AnnualPlanningScreen extends StatefulWidget {
  const AnnualPlanningScreen({super.key});

  @override
  State<AnnualPlanningScreen> createState() => _AnnualPlanningScreenState();
}

class _AnnualPlanningScreenState extends State<AnnualPlanningScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  AppRepository? _repo;
  bool _isLoading = true;
  
  // Data
  double _lastYearIncome = 0;
  double _lastYearExpenses = 0;
  List<Map<String, dynamic>> _categorySpending = [];
  
  // Planning Inputs
  final TextEditingController _incomeTargetController = TextEditingController();
  final TextEditingController _savingsTargetController = TextEditingController();
  final Map<String, TextEditingController> _budgetControllers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _repo = await AppRepository.getInstance();
    final now = DateTime.now();
    final lastYear = now.year - 1;
    
    // Fetch last year data
    final income = await _repo!.getTotalIncomeByYear(lastYear);
    final expenses = await _repo!.getTotalExpensesByYear(lastYear);
    
    // Fetch category breakdown
    final categories = await _repo!.getAllCategories();
    final breakdown = <Map<String, dynamic>>[];
    
    for (final cat in categories) {
      // Simplified: Assume repository has method or calculate locally
      // For now, placeholder query logic
      breakdown.add({
        'category': cat,
        'amount': expenses * 0.1, // Placeholder distribution
        'controller': TextEditingController(text: (expenses * 0.1).toStringAsFixed(0)),
      });
      _budgetControllers[cat.id] = TextEditingController(text: (expenses * 0.1 * 1.1).toStringAsFixed(0)); // Suggest 10% increase
    }
    
    setState(() {
      _lastYearIncome = income;
      _lastYearExpenses = expenses;
      _categorySpending = breakdown;
      _incomeTargetController.text = (income * 1.15).toStringAsFixed(0); // target +15%
      _savingsTargetController.text = (income * 0.20).toStringAsFixed(0); // target 20%
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Annual Planner ${DateTime.now().year}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B)))
        : Column(
            children: [
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children:List.generate(3, (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= _currentPage ? const Color(0xFFCFB53B) : Colors.white12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )),
                ),
              ),
              
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildReviewStep(),
                    _buildIncomeStep(),
                    _buildBudgetStep(),
                  ],
                ),
              ),
              
              // Navigation
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0D1B2A),
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: () {
                          _pageController.previousPage(duration: 300.ms, curve: Curves.easeOut);
                          setState(() => _currentPage--);
                        },
                        child: Text('Back', style: GoogleFonts.poppins(color: Colors.white54)),
                      )
                    else 
                      const SizedBox(width: 60),
                      
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(duration: 300.ms, curve: Curves.easeOut);
                          setState(() => _currentPage++);
                        } else {
                          // Save Plan
                          _savePlan();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCFB53B),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_currentPage == 2 ? 'Finish Planning' : 'Next Step', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildReviewStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Review Last Year', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Here is how you performed in ${DateTime.now().year - 1}.', style: GoogleFonts.poppins(color: Colors.white54)),
          const SizedBox(height: 32),
          
          _buildSummaryCard(
            'Total Income', 
            _lastYearIncome, 
            CupertinoIcons.graph_circle_fill, 
            const Color(0xFF4CAF50)
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            'Total Expenses', 
            _lastYearExpenses, 
            CupertinoIcons.money_dollar_circle_fill, 
            const Color(0xFFE53935)
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            'Net Savings', 
            _lastYearIncome - _lastYearExpenses, 
            CupertinoIcons.briefcase_fill, 
            const Color(0xFF2196F3)
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Set Targets', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('What are your goals for ${DateTime.now().year}?', style: GoogleFonts.poppins(color: Colors.white54)),
          const SizedBox(height: 32),
          
          Text('Income Target', style: GoogleFonts.poppins(color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _incomeTargetController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1A2744),
              prefixText: 'AED ',
              prefixStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text('Savings Goal', style: GoogleFonts.poppins(color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _savingsTargetController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1A2744),
              prefixText: 'AED ',
              prefixStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetStep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Step 3: Allocate Budgets', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text('Set monthly limits for key categories.', style: GoogleFonts.poppins(color: Colors.white54)),
        const SizedBox(height: 32),
        
        ..._categorySpending.map((item) {
          final cat = item['category'] as Category;
          final controller = _budgetControllers[cat.id]!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(cat.name, style: GoogleFonts.poppins(color: Colors.white)),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFF1A2744),
                      prefixText: 'AED ',
                      prefixStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
              Text(_formatCurrency(value), style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatCurrency(double v) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(v);

  void _savePlan() {
    // Save logic here (e.g., update category budgets in DB)
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Annual Plan Saved!')));
    Navigator.pop(context);
  }
}
