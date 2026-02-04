import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  AppRepository? _repo;
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  List<Account> _accounts = [];
  bool _isLoading = true;
  String _filterType = 'all';
  
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
      final transactions = await _repo!.getAllTransactions();
      if (!mounted) return;
      final categories = await _repo!.getAllCategories();
      if (!mounted) return;
      final accounts = await _repo!.getAllAccounts();
      if (!mounted) return;
      
      setState(() {
        _transactions = transactions;
        _categories = categories;
        _accounts = accounts;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  List<Transaction> get _filteredTransactions {
    if (_filterType == 'all') return _transactions;
    return _transactions.where((t) => t.type == _filterType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildFilterChips(),
          _buildSummaryCard(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B))),
            )
          else if (_filteredTransactions.isEmpty)
            _buildEmptyState()
          else
            _buildTransactionList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionSheet(),
        backgroundColor: const Color(0xFFCFB53B),
        icon: const Icon(CupertinoIcons.add, color: Colors.black),
        label: Text('Add', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0A1628),
      title: Text('Transactions', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildFilterChips() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            _buildChip('All', 'all'),
            const SizedBox(width: 8),
            _buildChip('Expenses', 'expense'),
            const SizedBox(width: 8),
            _buildChip('Income', 'income'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, String type) {
    final isSelected = _filterType == type;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _filterType = type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCFB53B) : const Color(0xFF1A2744),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFCFB53B) : const Color(0xFF2A3A5A)),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.black : Colors.white70),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    double totalIncome = _transactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amountBase);
    double totalExpense = _transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amountBase);
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1A2744), Color(0xFF0D1B2A)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A3A5A)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('Income', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_formatCurrency(totalIncome), style: GoogleFonts.poppins(color: const Color(0xFF4CAF50), fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(width: 1, height: 50, color: const Color(0xFF2A3A5A)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text('Expenses', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_formatCurrency(totalExpense), style: GoogleFonts.poppins(color: const Color(0xFFE53935), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.doc_text, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text('No transactions yet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white54)),
            const SizedBox(height: 8),
            Text('Add your first transaction to get started', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38)),
          ],
        ).animate().fadeIn(),
      ),
    );
  }

  Widget _buildTransactionList() {
    // Group transactions by date
    final grouped = <String, List<Transaction>>{};
    for (var t in _filteredTransactions) {
      final dateKey = DateFormat('MMM dd, yyyy').format(t.transactionDate);
      grouped.putIfAbsent(dateKey, () => []).add(t);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final dateKeys = grouped.keys.toList();
          final date = dateKeys[index];
          final transactions = grouped[date]!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(date, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54)),
              ),
              ...transactions.asMap().entries.map((entry) {
                return _buildTransactionTile(entry.value).animate(delay: (entry.key * 50).ms).fadeIn().slideX(begin: 0.05);
              }),
            ],
          );
        },
        childCount: grouped.keys.length,
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    final category = _categories.firstWhere(
      (c) => c.id == transaction.categoryId,
      orElse: () => _defaultCategory(),
    );
    final isExpense = transaction.type == 'expense';
    final color = Color(category.colorValue);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3A5A), width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(_getCategoryIcon(category.icon), color: color, size: 24),
        ),
        title: Text(transaction.description, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(category.name, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
        trailing: Text(
          '${isExpense ? "-" : "+"}${_formatCurrency(transaction.amountBase)}',
          style: GoogleFonts.poppins(color: isExpense ? const Color(0xFFE53935) : const Color(0xFF4CAF50), fontSize: 15, fontWeight: FontWeight.w600),
        ),
        onTap: () => _showEditTransactionSheet(transaction),
      ),
    );
  }

  Category _defaultCategory() {
    return Category(
      id: 'uncategorized', 
      name: 'Uncategorized', 
      budgetType: 'needs', 
      icon: 'help_outline', 
      colorValue: 0xFF666666,
      parentId: null,
    );
  }

  IconData _getCategoryIcon(String? iconName) {
    final icons = {
      'home': CupertinoIcons.home,
      'flash': CupertinoIcons.bolt,
      'cart': CupertinoIcons.cart,
      'car': CupertinoIcons.car,
      'heart': CupertinoIcons.heart,
      'briefcase': CupertinoIcons.briefcase,
      'gamecontroller': CupertinoIcons.gamecontroller,
      'airplane': CupertinoIcons.airplane,
      'bag': CupertinoIcons.bag,
      'arrow_2_circlepath': CupertinoIcons.arrow_2_circlepath,
      'chart_bar': CupertinoIcons.chart_bar,
      'person': CupertinoIcons.person,
      'shield': CupertinoIcons.shield,
    };
    return icons[iconName] ?? CupertinoIcons.circle;
  }

  void _showAddTransactionSheet() {
    _showTransactionSheet(null);
  }

  void _showEditTransactionSheet(Transaction transaction) {
    _showTransactionSheet(transaction);
  }

  void _showTransactionSheet(Transaction? existing) {
    final isEditing = existing != null;
    final descController = TextEditingController(text: existing?.description ?? '');
    final amountController = TextEditingController(text: existing?.amountSource.toString() ?? '');
    String type = existing?.type ?? 'expense';
    String? selectedCategoryId = existing?.categoryId;
    String? selectedAccountId = existing?.accountId;
    DateTime selectedDate = existing?.transactionDate ?? DateTime.now();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(color: Color(0xFF1A2744), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isEditing ? 'Edit Transaction' : 'Add Transaction', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    if (isEditing)
                      IconButton(
                        icon: const Icon(CupertinoIcons.trash, color: Color(0xFFE53935)),
                        onPressed: () async {
                          await _repo!.deleteTransaction(existing.id);
                          if (mounted) Navigator.pop(context);
                          _loadData();
                          HapticFeedback.heavyImpact();
                        },
                      ),
                  ],
                ),
              ),
              // Type Toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setSheetState(() => type = 'expense'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(color: type == 'expense' ? const Color(0xFFE53935) : const Color(0xFF0D1B2A), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text('Expense', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setSheetState(() => type = 'income'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(color: type == 'income' ? const Color(0xFF4CAF50) : const Color(0xFF0D1B2A), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text('Income', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Amount
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 32),
                    border: InputBorder.none,
                    prefixText: 'AED ',
                    prefixStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 20),
                  ),
                ),
              ),
              const Divider(color: Color(0xFF2A3A5A)),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: descController,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: GoogleFonts.poppins(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A3A5A))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFB53B))),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Category Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategoryId,
                      hint: Text('Select Category', style: GoogleFonts.poppins(color: Colors.white54)),
                      dropdownColor: const Color(0xFF1A2744),
                      isExpanded: true,
                      items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                      onChanged: (val) => setSheetState(() => selectedCategoryId = val),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Account Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedAccountId,
                      hint: Text('Select Account', style: GoogleFonts.poppins(color: Colors.white54)),
                      dropdownColor: const Color(0xFF1A2744),
                      isExpanded: true,
                      items: _accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                      onChanged: (val) => setSheetState(() => selectedAccountId = val),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Date Picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                    if (date != null) setSheetState(() => selectedDate = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A3A5A)), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.calendar, color: Colors.white54),
                        const SizedBox(width: 12),
                        Text(DateFormat('MMM dd, yyyy').format(selectedDate), style: GoogleFonts.poppins(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Save Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final amount = double.tryParse(amountController.text) ?? 0;
                      if (amount <= 0 || descController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                        return;
                      }
                      
                      if (selectedAccountId == null && _accounts.isNotEmpty) {
                        selectedAccountId = _accounts.first.id;
                      }
                      
                      final transaction = TransactionsCompanion(
                        id: isEditing ? Value(existing.id) : Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        description: Value(descController.text),
                        amountSource: Value(amount),
                        amountBase: Value(amount),
                        currencyCode: const Value('AED'),
                        type: Value(type),
                        categoryId: Value(selectedCategoryId),
                        accountId: Value(selectedAccountId ?? _accounts.firstOrNull?.id ?? 'default'),
                        transactionDate: Value(selectedDate),
                      );
                      
                      if (isEditing) {
                        await _repo!.updateTransaction(existing.id, transaction);
                      } else {
                        await _repo!.insertTransaction(transaction);
                      }
                      
                      if (mounted) Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCFB53B), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(isEditing ? 'Update' : 'Add Transaction', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 2).format(amount);
}
