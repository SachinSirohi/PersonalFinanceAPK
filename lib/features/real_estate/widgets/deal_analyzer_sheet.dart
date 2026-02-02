import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/financial_calculations.dart';

/// Real Estate Deal Analyzer - IRR, NPV, Cash-on-Cash, Scenario Analysis
class DealAnalyzerSheet extends StatefulWidget {
  final String propertyName;
  final double purchasePrice;
  final double currentValue;
  final String currency;
  final String geography; // 'UAE' or 'India'
  
  const DealAnalyzerSheet({
    super.key,
    required this.propertyName,
    required this.purchasePrice,
    required this.currentValue,
    required this.currency,
    required this.geography,
  });
  
  @override
  State<DealAnalyzerSheet> createState() => _DealAnalyzerSheetState();
}

class _DealAnalyzerSheetState extends State<DealAnalyzerSheet> {
  // Input controllers
  final _purchasePriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTenureController = TextEditingController();
  final _annualRentController = TextEditingController();
  final _rentGrowthController = TextEditingController();
  final _annualExpensesController = TextEditingController();
  final _expenseGrowthController = TextEditingController();
  final _holdingPeriodController = TextEditingController();
  final _exitValueController = TextEditingController();
  
  // Calculated results
  Map<String, double> _baseResults = {};
  Map<String, double> _bullResults = {};
  Map<String, double> _bearResults = {};
  bool _hasCalculated = false;
  
  @override
  void initState() {
    super.initState();
    _purchasePriceController.text = widget.purchasePrice.toStringAsFixed(0);
    _exitValueController.text = widget.currentValue.toStringAsFixed(0);
    
    // Default values
    _downPaymentController.text = '25';
    _interestRateController.text = '4.5';
    _loanTenureController.text = '25';
    _annualRentController.text = (widget.purchasePrice * 0.06).toStringAsFixed(0);
    _rentGrowthController.text = '3';
    _annualExpensesController.text = (widget.purchasePrice * 0.02).toStringAsFixed(0);
    _expenseGrowthController.text = '3';
    _holdingPeriodController.text = '5';
  }
  
  void _calculateDeal() {
    // Parse inputs
    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0;
    final downPaymentPercent = double.tryParse(_downPaymentController.text) ?? 25;
    final interestRate = (double.tryParse(_interestRateController.text) ?? 4.5) / 100;
    final loanTenure = int.tryParse(_loanTenureController.text) ?? 25;
    final annualRent = double.tryParse(_annualRentController.text) ?? 0;
    final rentGrowth = (double.tryParse(_rentGrowthController.text) ?? 3) / 100;
    final annualExpenses = double.tryParse(_annualExpensesController.text) ?? 0;
    final expenseGrowth = (double.tryParse(_expenseGrowthController.text) ?? 3) / 100;
    final holdingPeriod = int.tryParse(_holdingPeriodController.text) ?? 5;
    final exitValue = double.tryParse(_exitValueController.text) ?? purchasePrice;
    
    // Calculate derived values
    final downPayment = purchasePrice * downPaymentPercent / 100;
    final loanAmount = purchasePrice - downPayment;
    
    // Calculate purchase costs based on geography
    final purchaseCosts = _calculatePurchaseCosts(purchasePrice, loanAmount);
    final totalInvestment = downPayment + purchaseCosts;
    
    // Calculate exit costs
    final exitCosts = _calculateExitCosts(exitValue);
    
    // Base case calculation
    _baseResults = _calculateScenario(
      purchasePrice: purchasePrice,
      loanAmount: loanAmount,
      interestRate: interestRate,
      loanTenure: loanTenure,
      annualRent: annualRent,
      rentGrowth: rentGrowth,
      annualExpenses: annualExpenses,
      expenseGrowth: expenseGrowth,
      holdingPeriod: holdingPeriod,
      exitValue: exitValue,
      totalInvestment: totalInvestment,
      exitCosts: exitCosts,
    );
    
    // Bull case: +15% rent, -10% expenses, +20% exit value
    _bullResults = _calculateScenario(
      purchasePrice: purchasePrice,
      loanAmount: loanAmount,
      interestRate: interestRate,
      loanTenure: loanTenure,
      annualRent: annualRent * 1.15,
      rentGrowth: rentGrowth * 1.5,
      annualExpenses: annualExpenses * 0.9,
      expenseGrowth: expenseGrowth * 0.8,
      holdingPeriod: holdingPeriod,
      exitValue: exitValue * 1.2,
      totalInvestment: totalInvestment,
      exitCosts: _calculateExitCosts(exitValue * 1.2),
    );
    
    // Bear case: -15% rent, +15% expenses, -10% exit value
    _bearResults = _calculateScenario(
      purchasePrice: purchasePrice,
      loanAmount: loanAmount,
      interestRate: interestRate,
      loanTenure: loanTenure,
      annualRent: annualRent * 0.85,
      rentGrowth: rentGrowth * 0.5,
      annualExpenses: annualExpenses * 1.15,
      expenseGrowth: expenseGrowth * 1.2,
      holdingPeriod: holdingPeriod,
      exitValue: exitValue * 0.9,
      totalInvestment: totalInvestment,
      exitCosts: _calculateExitCosts(exitValue * 0.9),
    );
    
    setState(() {
      _hasCalculated = true;
    });
  }
  
  double _calculatePurchaseCosts(double purchasePrice, double loanAmount) {
    if (widget.geography == 'UAE') {
      // UAE: DLD 4%, Mortgage reg 0.25%, Agency 2%
      return purchasePrice * 0.04 + loanAmount * 0.0025 + purchasePrice * 0.02;
    } else {
      // India: Stamp duty 6%, Registration 1%, Brokerage 1%
      return purchasePrice * 0.06 + purchasePrice * 0.01 + purchasePrice * 0.01;
    }
  }
  
  double _calculateExitCosts(double exitValue) {
    if (widget.geography == 'UAE') {
      // UAE: DLD 4%, Agency 2%
      return exitValue * 0.04 + exitValue * 0.02;
    } else {
      // India: LTCG 20% on gains (simplified)
      final gains = exitValue - widget.purchasePrice;
      return exitValue * 0.02 + (gains > 0 ? gains * 0.20 : 0);
    }
  }
  
  Map<String, double> _calculateScenario({
    required double purchasePrice,
    required double loanAmount,
    required double interestRate,
    required int loanTenure,
    required double annualRent,
    required double rentGrowth,
    required double annualExpenses,
    required double expenseGrowth,
    required int holdingPeriod,
    required double exitValue,
    required double totalInvestment,
    required double exitCosts,
  }) {
    // Calculate EMI
    final emi = FinancialCalculations.calculateEMI(
      principal: loanAmount,
      annualInterestRate: interestRate,
      tenureMonths: loanTenure * 12,
    );
    
    // Calculate cashflows
    final cashflows = <double>[];
    final dates = <DateTime>[];
    
    // Initial investment (negative)
    cashflows.add(-totalInvestment);
    dates.add(DateTime.now());
    
    // Annual cashflows
    double cumulativeRent = 0;
    double cumulativeExpenses = 0;
    for (int year = 1; year <= holdingPeriod; year++) {
      final yearRent = annualRent * pow(1 + rentGrowth, year - 1);
      final yearExpenses = annualExpenses * pow(1 + expenseGrowth, year - 1);
      final yearEMI = emi * 12;
      final netCashflow = yearRent - yearExpenses - yearEMI;
      
      cumulativeRent += yearRent;
      cumulativeExpenses += yearExpenses;
      
      cashflows.add(netCashflow);
      dates.add(DateTime.now().add(Duration(days: year * 365)));
    }
    
    // Outstanding loan at exit
    final outstandingLoan = FinancialCalculations.calculateOutstandingPrincipal(
      principal: loanAmount,
      annualInterestRate: interestRate,
      tenureMonths: loanTenure * 12,
      monthsPaid: holdingPeriod * 12,
    );
    
    // Exit cashflow
    final netExitProceeds = exitValue - outstandingLoan - exitCosts;
    cashflows[cashflows.length - 1] += netExitProceeds;
    
    // Calculate metrics
    final xirr = FinancialCalculations.calculateXIRR(cashflows, dates);
    final irr = FinancialCalculations.calculateIRR(cashflows);
    final npv = FinancialCalculations.calculateNPV(
      cashflows: cashflows,
      discountRate: 0.10,
    );
    
    final noi = annualRent - annualExpenses;
    final capRate = FinancialCalculations.calculateCapRate(
      netOperatingIncome: noi,
      propertyValue: purchasePrice,
    );
    
    final cashOnCash = FinancialCalculations.calculateCashOnCashReturn(
      annualCashflow: noi - (emi * 12),
      initialEquity: totalInvestment,
    );
    
    final totalReturns = cashflows.fold(0.0, (sum, c) => sum + c);
    final equityMultiple = (totalReturns + totalInvestment) / totalInvestment;
    
    final grossYield = FinancialCalculations.calculateGrossYield(
      annualRentalIncome: annualRent,
      propertyValue: purchasePrice,
    );
    
    return {
      'irr': irr * 100,
      'xirr': xirr * 100,
      'npv': npv,
      'capRate': capRate * 100,
      'cashOnCash': cashOnCash * 100,
      'equityMultiple': equityMultiple,
      'grossYield': grossYield * 100,
      'emi': emi,
      'noi': noi,
      'totalInvestment': totalInvestment,
      'netExitProceeds': netExitProceeds,
      'cumulativeRent': cumulativeRent,
      'cumulativeExpenses': cumulativeExpenses,
    };
  }
  
  double pow(double x, int n) {
    double result = 1.0;
    for (int i = 0; i < n; i++) {
      result *= x;
    }
    return result;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.analytics_outlined, color: Color(0xFF7C3AED)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deal Analyzer',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.propertyName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.geography == 'UAE' 
                        ? const Color(0xFF10B981).withValues(alpha: 0.2)
                        : const Color(0xFFFF9500).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.geography,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.geography == 'UAE' 
                          ? const Color(0xFF10B981)
                          : const Color(0xFFFF9500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Section
                  _buildSectionTitle('Investment Parameters'),
                  const SizedBox(height: 12),
                  _buildInputGrid(),
                  
                  const SizedBox(height: 24),
                  
                  // Calculate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _calculateDeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Analyze Deal',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  if (_hasCalculated) ...[
                    const SizedBox(height: 32),
                    _buildResultsSection(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
  
  Widget _buildInputGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInputField('Purchase Price', _purchasePriceController, widget.currency)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Down Payment %', _downPaymentController, '%')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField('Interest Rate', _interestRateController, '%')),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Loan Tenure', _loanTenureController, 'years')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField('Annual Rent', _annualRentController, widget.currency)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Rent Growth', _rentGrowthController, '%/yr')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField('Annual Expenses', _annualExpensesController, widget.currency)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Expense Growth', _expenseGrowthController, '%/yr')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField('Holding Period', _holdingPeriodController, 'years')),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Exit Value', _exitValueController, widget.currency)),
          ],
        ),
      ],
    );
  }
  
  Widget _buildInputField(String label, TextEditingController controller, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: GoogleFonts.inter(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF0A0A0F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
  
  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Investment Analysis'),
        const SizedBox(height: 16),
        
        // Scenario Comparison
        _buildScenarioComparison(),
        
        const SizedBox(height: 24),
        
        // Key Metrics Cards
        _buildKeyMetricsGrid(),
        
        const SizedBox(height: 24),
        
        // Cashflow Summary
        _buildCashflowSummary(),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
  
  Widget _buildScenarioComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildScenarioHeader('Scenario', Colors.white70)),
              Expanded(child: _buildScenarioHeader('IRR', Colors.white70)),
              Expanded(child: _buildScenarioHeader('Equity Multiple', Colors.white70)),
            ],
          ),
          const Divider(color: Colors.white12, height: 24),
          Row(
            children: [
              Expanded(child: _buildScenarioValue('🐻 Bear', Colors.red.shade400)),
              Expanded(child: _buildScenarioValue('${_bearResults['irr']?.toStringAsFixed(1) ?? '0'}%', Colors.red.shade400)),
              Expanded(child: _buildScenarioValue('${_bearResults['equityMultiple']?.toStringAsFixed(2) ?? '0'}x', Colors.red.shade400)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildScenarioValue('📊 Base', Colors.blue.shade400)),
              Expanded(child: _buildScenarioValue('${_baseResults['irr']?.toStringAsFixed(1) ?? '0'}%', Colors.blue.shade400)),
              Expanded(child: _buildScenarioValue('${_baseResults['equityMultiple']?.toStringAsFixed(2) ?? '0'}x', Colors.blue.shade400)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildScenarioValue('🐂 Bull', Colors.green.shade400)),
              Expanded(child: _buildScenarioValue('${_bullResults['irr']?.toStringAsFixed(1) ?? '0'}%', Colors.green.shade400)),
              Expanded(child: _buildScenarioValue('${_bullResults['equityMultiple']?.toStringAsFixed(2) ?? '0'}x', Colors.green.shade400)),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildScenarioHeader(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
  
  Widget _buildScenarioValue(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
  
  Widget _buildKeyMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard('Cap Rate', '${_baseResults['capRate']?.toStringAsFixed(1) ?? '0'}%', Icons.pie_chart_outline),
        _buildMetricCard('Cash-on-Cash', '${_baseResults['cashOnCash']?.toStringAsFixed(1) ?? '0'}%', Icons.attach_money),
        _buildMetricCard('Gross Yield', '${_baseResults['grossYield']?.toStringAsFixed(1) ?? '0'}%', Icons.percent),
        _buildMetricCard('NPV (10%)', '${widget.currency} ${(_baseResults['npv'] ?? 0).toStringAsFixed(0)}', Icons.trending_up),
      ],
    );
  }
  
  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withValues(alpha: 0.1),
            const Color(0xFF2563EB).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF7C3AED), size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCashflowSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cashflow Summary (Base Case)',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Total Investment', widget.currency, _baseResults['totalInvestment'] ?? 0),
          _buildSummaryRow('Monthly EMI', widget.currency, _baseResults['emi'] ?? 0),
          _buildSummaryRow('Annual NOI (Year 1)', widget.currency, _baseResults['noi'] ?? 0),
          _buildSummaryRow('Cumulative Rent', widget.currency, _baseResults['cumulativeRent'] ?? 0),
          _buildSummaryRow('Cumulative Expenses', widget.currency, _baseResults['cumulativeExpenses'] ?? 0),
          const Divider(color: Colors.white12, height: 24),
          _buildSummaryRow('Net Exit Proceeds', widget.currency, _baseResults['netExitProceeds'] ?? 0, highlight: true),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String currency, double value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: highlight ? Colors.white : Colors.white60,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            '$currency ${value.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: highlight ? const Color(0xFF10B981) : Colors.white,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _purchasePriceController.dispose();
    _downPaymentController.dispose();
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTenureController.dispose();
    _annualRentController.dispose();
    _rentGrowthController.dispose();
    _annualExpensesController.dispose();
    _expenseGrowthController.dispose();
    _holdingPeriodController.dispose();
    _exitValueController.dispose();
    super.dispose();
  }
}
