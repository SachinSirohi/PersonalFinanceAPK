import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../core/utils/financial_calculations.dart';

/// Liabilities Screen - Manage loans, credit cards, and debts
class LiabilitiesScreen extends StatefulWidget {
  final AppRepository repository;
  
  const LiabilitiesScreen({super.key, required this.repository});
  
  @override
  State<LiabilitiesScreen> createState() => _LiabilitiesScreenState();
}

class _LiabilitiesScreenState extends State<LiabilitiesScreen> {
  late Future<List<Liability>> _liabilitiesFuture;
  double _totalOutstanding = 0;
  double _totalEmi = 0;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  void _loadData() {
    _liabilitiesFuture = widget.repository.getAllLiabilities();
    _loadTotals();
  }
  
  Future<void> _loadTotals() async {
    final outstanding = await widget.repository.getTotalLiabilities();
    final emi = await widget.repository.getTotalMonthlyEMI();
    setState(() {
      _totalOutstanding = outstanding;
      _totalEmi = emi;
    });
  }
  
  void _showAddLiability() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddLiabilitySheet(
        onSave: (liability) async {
          await widget.repository.insertLiability(liability);
          _loadData();
          setState(() {});
        },
      ),
    );
  }
  
  void _showEditLiability(Liability liability) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddLiabilitySheet(
        liability: liability,
        onSave: (updated) async {
          await widget.repository.updateLiability(liability.id, updated);
          _loadData();
          setState(() {});
        },
        onDelete: () async {
          await widget.repository.deleteLiability(liability.id);
          _loadData();
          setState(() {});
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: Text(
          'Liabilities',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddLiability,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFDC2626).withValues(alpha: 0.2),
                  const Color(0xFFEA580C).withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance, color: Color(0xFFDC2626), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Outstanding',
                            style: GoogleFonts.inter(fontSize: 14, color: Colors.white60),
                          ),
                          Text(
                            'AED ${NumberFormat('#,##0').format(_totalOutstanding)}',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monthly EMI',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.white60),
                      ),
                      Text(
                        'AED ${NumberFormat('#,##0').format(_totalEmi)}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2),
          
          // Liabilities List
          Expanded(
            child: FutureBuilder<List<Liability>>(
              future: _liabilitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final liabilities = snapshot.data ?? [];
                
                if (liabilities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.celebration,
                            size: 48,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Debt Free! 🎉',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'No liabilities to track',
                          style: GoogleFonts.inter(color: Colors.white60),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: liabilities.length,
                  itemBuilder: (context, index) {
                    final liability = liabilities[index];
                    return _LiabilityCard(
                      liability: liability,
                      onTap: () => _showEditLiability(liability),
                    ).animate(delay: Duration(milliseconds: index * 100))
                      .fadeIn()
                      .slideX(begin: 0.2);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLiability,
        backgroundColor: const Color(0xFF7C3AED),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LIABILITY CARD
// ═══════════════════════════════════════════════════════════════════════════

class _LiabilityCard extends StatelessWidget {
  final Liability liability;
  final VoidCallback onTap;
  
  const _LiabilityCard({required this.liability, required this.onTap});
  
  IconData get _icon {
    switch (liability.type) {
      case 'home_loan': return Icons.home;
      case 'vehicle_loan': return Icons.directions_car;
      case 'personal_loan': return Icons.person;
      case 'credit_card': return Icons.credit_card;
      default: return Icons.account_balance;
    }
  }
  
  String get _typeLabel {
    switch (liability.type) {
      case 'home_loan': return 'Home Loan';
      case 'vehicle_loan': return 'Vehicle Loan';
      case 'personal_loan': return 'Personal Loan';
      case 'credit_card': return 'Credit Card';
      default: return 'Other Loan';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final progress = 1 - (liability.outstandingAmount / liability.principalAmount);
    final monthsRemaining = liability.endDate != null 
        ? liability.endDate!.difference(DateTime.now()).inDays ~/ 30
        : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_icon, color: const Color(0xFFDC2626), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          liability.name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$_typeLabel${liability.institution != null ? ' • ${liability.institution}' : ''}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${liability.currencyCode} ${NumberFormat('#,##0').format(liability.outstandingAmount)}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDC2626),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Outstanding',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1).toDouble(),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation(
                    Color.lerp(const Color(0xFFDC2626), const Color(0xFF10B981), progress)!,
                  ),
                  minHeight: 6,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem('EMI', '${liability.currencyCode} ${NumberFormat('#,##0').format(liability.emi)}'),
                  _buildInfoItem('Rate', '${(liability.interestRate * 100).toStringAsFixed(1)}%'),
                  _buildInfoItem('Paid', '${(progress * 100).toStringAsFixed(0)}%'),
                  if (monthsRemaining != null)
                    _buildInfoItem('Remaining', '$monthsRemaining mo'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ADD/EDIT LIABILITY SHEET
// ═══════════════════════════════════════════════════════════════════════════

class _AddLiabilitySheet extends StatefulWidget {
  final Liability? liability;
  final Function(LiabilitiesCompanion) onSave;
  final VoidCallback? onDelete;
  
  const _AddLiabilitySheet({
    this.liability,
    required this.onSave,
    this.onDelete,
  });
  
  @override
  State<_AddLiabilitySheet> createState() => _AddLiabilitySheetState();
}

class _AddLiabilitySheetState extends State<_AddLiabilitySheet> {
  final _nameController = TextEditingController();
  final _principalController = TextEditingController();
  final _outstandingController = TextEditingController();
  final _rateController = TextEditingController();
  final _tenureController = TextEditingController();
  final _institutionController = TextEditingController();
  
  String _type = 'home_loan';
  String _currency = 'AED';
  DateTime _startDate = DateTime.now();
  double _calculatedEmi = 0;
  
  final _types = [
    ('home_loan', 'Home Loan', Icons.home),
    ('vehicle_loan', 'Vehicle Loan', Icons.directions_car),
    ('personal_loan', 'Personal Loan', Icons.person),
    ('credit_card', 'Credit Card', Icons.credit_card),
    ('other', 'Other', Icons.account_balance),
  ];
  
  @override
  void initState() {
    super.initState();
    if (widget.liability != null) {
      final l = widget.liability!;
      _nameController.text = l.name;
      _principalController.text = l.principalAmount.toStringAsFixed(0);
      _outstandingController.text = l.outstandingAmount.toStringAsFixed(0);
      _rateController.text = (l.interestRate * 100).toStringAsFixed(2);
      _tenureController.text = (l.tenureMonths / 12).toStringAsFixed(0);
      _institutionController.text = l.institution ?? '';
      _type = l.type;
      _currency = l.currencyCode;
      _startDate = l.startDate;
      _calculatedEmi = l.emi;
    }
  }
  
  void _calculateEmi() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final rate = (double.tryParse(_rateController.text) ?? 0) / 100;
    final tenureYears = int.tryParse(_tenureController.text) ?? 0;
    
    if (principal > 0 && rate > 0 && tenureYears > 0) {
      final emi = FinancialCalculations.calculateEMI(
        principal: principal,
        annualInterestRate: rate,
        tenureMonths: tenureYears * 12,
      );
      setState(() => _calculatedEmi = emi);
    }
  }
  
  void _save() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final outstanding = double.tryParse(_outstandingController.text) ?? principal;
    final rate = (double.tryParse(_rateController.text) ?? 0) / 100;
    final tenureYears = int.tryParse(_tenureController.text) ?? 0;
    
    final liability = LiabilitiesCompanion(
      id: widget.liability != null 
          ? drift.Value(widget.liability!.id)
          : drift.Value(DateTime.now().millisecondsSinceEpoch.toString()),
      name: drift.Value(_nameController.text),
      type: drift.Value(_type),
      currencyCode: drift.Value(_currency),
      principalAmount: drift.Value(principal),
      outstandingAmount: drift.Value(outstanding),
      interestRate: drift.Value(rate),
      tenureMonths: drift.Value(tenureYears * 12),
      emi: drift.Value(_calculatedEmi),
      startDate: drift.Value(_startDate),
      endDate: drift.Value(_startDate.add(Duration(days: tenureYears * 365))),
      institution: drift.Value(_institutionController.text.isEmpty ? null : _institutionController.text),
    );
    
    widget.onSave(liability);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                Text(
                  widget.liability != null ? 'Edit Liability' : 'Add Liability',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      widget.onDelete!();
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type selection
                  Text('Type', style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _types.map((t) {
                      final isSelected = _type == t.$1;
                      return GestureDetector(
                        onTap: () => setState(() => _type = t.$1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF7C3AED).withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected 
                                ? Border.all(color: const Color(0xFF7C3AED))
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(t.$3, size: 16, color: isSelected ? const Color(0xFF7C3AED) : Colors.white60),
                              const SizedBox(width: 6),
                              Text(t.$2, style: GoogleFonts.inter(
                                color: isSelected ? const Color(0xFF7C3AED) : Colors.white60,
                                fontSize: 12,
                              )),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Name
                  _buildTextField('Name', _nameController, 'e.g., Home Loan - HDFC'),
                  
                  const SizedBox(height: 16),
                  
                  // Principal & Outstanding
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Principal Amount', _principalController, '0', isNumber: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Outstanding', _outstandingController, '0', isNumber: true)),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rate & Tenure
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Interest Rate (%)', _rateController, '4.5', isNumber: true, onChanged: (_) => _calculateEmi())),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Tenure (Years)', _tenureController, '25', isNumber: true, onChanged: (_) => _calculateEmi())),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // EMI Display
                  if (_calculatedEmi > 0)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calculated EMI', style: GoogleFonts.inter(color: Colors.white60)),
                          Text(
                            '$_currency ${NumberFormat('#,##0').format(_calculatedEmi)}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7C3AED),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Institution
                  _buildTextField('Institution (Optional)', _institutionController, 'e.g., HDFC Bank'),
                  
                  const SizedBox(height: 24),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        widget.liability != null ? 'Update' : 'Add Liability',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : null,
          style: GoogleFonts.inter(color: Colors.white),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.white38),
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
  
  @override
  void dispose() {
    _nameController.dispose();
    _principalController.dispose();
    _outstandingController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    _institutionController.dispose();
    super.dispose();
  }
}
