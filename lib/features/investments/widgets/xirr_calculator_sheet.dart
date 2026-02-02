import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/financial_calculations.dart';

/// XIRR Calculator - Calculate returns from investment transactions
class XIRRCalculatorSheet extends StatefulWidget {
  final String? investmentName;
  final List<Map<String, dynamic>>? initialTransactions;
  
  const XIRRCalculatorSheet({
    super.key,
    this.investmentName,
    this.initialTransactions,
  });
  
  @override
  State<XIRRCalculatorSheet> createState() => _XIRRCalculatorSheetState();
}

class _XIRRCalculatorSheetState extends State<XIRRCalculatorSheet> {
  final List<_CashflowEntry> _entries = [];
  double? _xirrResult;
  double? _absoluteReturn;
  double? _totalInvested;
  double? _currentValue;
  
  @override
  void initState() {
    super.initState();
    if (widget.initialTransactions != null) {
      for (final tx in widget.initialTransactions!) {
        _entries.add(_CashflowEntry(
          amount: tx['amount'] as double,
          date: tx['date'] as DateTime,
          isInvestment: tx['isInvestment'] as bool? ?? true,
        ));
      }
    } else {
      // Add sample entries for demo
      _entries.add(_CashflowEntry(amount: 0, date: DateTime.now(), isInvestment: true));
    }
  }
  
  void _addEntry() {
    setState(() {
      _entries.add(_CashflowEntry(amount: 0, date: DateTime.now(), isInvestment: true));
    });
  }
  
  void _removeEntry(int index) {
    if (_entries.length > 1) {
      setState(() {
        _entries.removeAt(index);
        _xirrResult = null;
      });
    }
  }
  
  void _calculateXIRR() {
    if (_entries.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 entries (investments + current value)')),
      );
      return;
    }
    
    // Convert entries to cashflows
    final cashflows = <double>[];
    final dates = <DateTime>[];
    double invested = 0;
    double? exitValue;
    
    for (final entry in _entries) {
      if (entry.isInvestment) {
        cashflows.add(-entry.amount); // Investments are negative cashflow
        invested += entry.amount;
      } else {
        cashflows.add(entry.amount); // Redemptions/current value are positive
        exitValue = entry.amount;
      }
      dates.add(entry.date);
    }
    
    if (!cashflows.any((c) => c < 0) || !cashflows.any((c) => c > 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need both investments and current value/redemptions')),
      );
      return;
    }
    
    final xirr = FinancialCalculations.calculateXIRR(cashflows, dates);
    final absoluteRet = exitValue != null && invested > 0 
        ? ((exitValue - invested) / invested * 100) 
        : 0.0;
    
    setState(() {
      _xirrResult = xirr * 100;
      _absoluteReturn = absoluteRet;
      _totalInvested = invested;
      _currentValue = exitValue;
    });
    
    HapticFeedback.mediumImpact();
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
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calculate_outlined, color: Color(0xFF10B981)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'XIRR Calculator',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (widget.investmentName != null)
                        Text(
                          widget.investmentName!,
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.white60),
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
          ),
          
          // Result Card (if calculated)
          if (_xirrResult != null) _buildResultCard(),
          
          // Instructions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white38, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add investments (negative) and current value/redemptions (positive) with dates',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Entries List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _entries.length,
              itemBuilder: (context, index) => _buildEntryCard(index),
            ),
          ),
          
          // Actions
          _buildBottomActions(),
        ],
      ),
    );
  }
  
  Widget _buildResultCard() {
    final isPositive = (_xirrResult ?? 0) >= 0;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPositive 
                ? [const Color(0xFF10B981), const Color(0xFF059669)]
                : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResultMetric('XIRR', '${_xirrResult!.toStringAsFixed(2)}%', true),
                _buildResultMetric('Absolute', '${_absoluteReturn!.toStringAsFixed(1)}%', false),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResultMetric('Invested', _formatCurrency(_totalInvested ?? 0), false),
                _buildResultMetric('Current', _formatCurrency(_currentValue ?? 0), false),
              ],
            ),
          ],
        ),
      ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
    );
  }
  
  Widget _buildResultMetric(String label, String value, bool isPrimary) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isPrimary ? 28 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
  
  Widget _buildEntryCard(int index) {
    final entry = _entries[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entry.isInvestment 
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Type Toggle
              GestureDetector(
                onTap: () => setState(() => entry.isInvestment = !entry.isInvestment),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: entry.isInvestment 
                        ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                        : const Color(0xFF10B981).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.isInvestment ? '− Investment' : '+ Value/Redeem',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: entry.isInvestment 
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (_entries.length > 1)
                IconButton(
                  onPressed: () => _removeEntry(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Amount
              Expanded(
                flex: 2,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: const TextStyle(color: Colors.white38),
                    prefixText: 'AED ',
                    prefixStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF1E1E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    entry.amount = double.tryParse(value) ?? 0;
                    _xirrResult = null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Date picker
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: entry.date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        entry.date = date;
                        _xirrResult = null;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white38, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy').format(entry.date),
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0F),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _addEntry,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text('Add Entry', style: GoogleFonts.inter(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _calculateXIRR,
                icon: const Icon(Icons.calculate, color: Colors.white),
                label: Text('Calculate', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(amount);
}

class _CashflowEntry {
  double amount;
  DateTime date;
  bool isInvestment;
  
  _CashflowEntry({
    required this.amount,
    required this.date,
    required this.isInvestment,
  });
}
