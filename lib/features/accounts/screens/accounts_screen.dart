import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  AppRepository? _repo;
  List<Account> _accounts = [];
  bool _isLoading = true;
  double _totalBalance = 0;
  
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
    
    final accounts = await _repo!.getAllAccounts();
    final total = accounts.fold(0.0, (sum, a) => sum + a.balance);
    
    setState(() {
      _accounts = accounts;
      _totalBalance = total;
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
          _buildTotalCard(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B))),
            )
          else if (_accounts.isEmpty)
            _buildEmptyState()
          else
            _buildAccountList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAccountSheet(),
        backgroundColor: const Color(0xFFCFB53B),
        icon: const Icon(CupertinoIcons.add, color: Colors.black),
        label: Text('Add Account', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
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
        title: Text(
          'Accounts',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
    );
  }

  Widget _buildTotalCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D47A1).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatCurrency(_totalBalance),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_accounts.length} accounts connected',
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12,
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
            Icon(
              CupertinoIcons.creditcard,
              size: 64,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              'No accounts yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your bank accounts, cards & wallets',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
          ],
        ).animate().fadeIn(),
      ),
    );
  }

  Widget _buildAccountList() {
    // Group by type
    final byType = <String, List<Account>>{};
    for (var a in _accounts) {
      byType.putIfAbsent(a.type, () => []).add(a);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final types = byType.keys.toList();
          final type = types[index];
          final accounts = byType[type]!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  _getTypeLabel(type),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                  ),
                ),
              ),
              ...accounts.asMap().entries.map((entry) {
                return _buildAccountTile(entry.value)
                  .animate(delay: (entry.key * 50).ms)
                  .fadeIn()
                  .slideX(begin: 0.05);
              }),
            ],
          );
        },
        childCount: byType.keys.length,
      ),
    );
  }

  String _getTypeLabel(String type) {
    final labels = {
      'bank': 'Bank Accounts',
      'credit_card': 'Credit Cards',
      'wallet': 'Digital Wallets',
      'cash': 'Cash',
      'investment': 'Investment Accounts',
    };
    return labels[type] ?? type.toUpperCase();
  }

  Widget _buildAccountTile(Account account) {
    final typeIcons = {
      'bank': CupertinoIcons.building_2_fill,
      'credit_card': CupertinoIcons.creditcard_fill,
      'wallet': CupertinoIcons.money_dollar_circle_fill,
      'cash': CupertinoIcons.money_dollar,
      'investment': CupertinoIcons.chart_bar_fill,
    };
    
    final typeColors = {
      'bank': const Color(0xFF1976D2),
      'credit_card': const Color(0xFFE53935),
      'wallet': const Color(0xFF7C4DFF),
      'cash': const Color(0xFF4CAF50),
      'investment': const Color(0xFFCFB53B),
    };
    
    final icon = typeIcons[account.type] ?? CupertinoIcons.circle;
    final color = typeColors[account.type] ?? Colors.grey;
    
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
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          account.name,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: account.institution != null
            ? Text(
                account.institution!,
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
              )
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatCurrency(account.balance),
              style: GoogleFonts.poppins(
                color: account.balance >= 0 ? Colors.white : const Color(0xFFE53935),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              account.currencyCode,
              style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
        onTap: () => _showEditAccountSheet(account),
      ),
    );
  }

  void _showAddAccountSheet() {
    _showAccountSheet(null);
  }

  void _showEditAccountSheet(Account account) {
    _showAccountSheet(account);
  }

  void _showAccountSheet(Account? existing) {
    final isEditing = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final balanceController = TextEditingController(text: existing?.balance.toString() ?? '0');
    final institutionController = TextEditingController(text: existing?.institution ?? '');
    String type = existing?.type ?? 'bank';
    String currency = existing?.currencyCode ?? 'AED';
    
    final types = [
      {'value': 'bank', 'label': 'Bank Account'},
      {'value': 'credit_card', 'label': 'Credit Card'},
      {'value': 'wallet', 'label': 'Digital Wallet'},
      {'value': 'cash', 'label': 'Cash'},
      {'value': 'investment', 'label': 'Investment Account'},
    ];
    
    final currencies = ['AED', 'USD', 'INR', 'EUR', 'GBP'];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Color(0xFF1A2744),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Account' : 'Add Account',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    if (isEditing)
                      IconButton(
                        icon: const Icon(CupertinoIcons.trash, color: Color(0xFFE53935)),
                        onPressed: () async {
                          await _repo!.deleteAccount(existing!.id);
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
                      // Account Name
                      TextField(
                        controller: nameController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Account Name',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2A3A5A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFCFB53B)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Institution
                      TextField(
                        controller: institutionController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Bank/Institution (Optional)',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2A3A5A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFCFB53B)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Type Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2A3A5A)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: type,
                            dropdownColor: const Color(0xFF1A2744),
                            isExpanded: true,
                            items: types.map((t) => DropdownMenuItem(
                              value: t['value'],
                              child: Text(t['label']!, style: GoogleFonts.poppins(color: Colors.white)),
                            )).toList(),
                            onChanged: (val) => setSheetState(() => type = val!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Currency & Balance Row
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF2A3A5A)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: currency,
                                  dropdownColor: const Color(0xFF1A2744),
                                  items: currencies.map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c, style: GoogleFonts.poppins(color: Colors.white)),
                                  )).toList(),
                                  onChanged: (val) => setSheetState(() => currency = val!),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: balanceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                              style: GoogleFonts.poppins(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Current Balance',
                                labelStyle: GoogleFonts.poppins(color: Colors.white54),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF2A3A5A)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFCFB53B)),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter account name')),
                        );
                        return;
                      }
                      
                      final account = AccountsCompanion(
                        name: Value(nameController.text),
                        type: Value(type),
                        currencyCode: Value(currency),
                        balance: Value(double.tryParse(balanceController.text) ?? 0),
                        institution: Value(institutionController.text.isNotEmpty ? institutionController.text : null),
                      );
                      
                      if (isEditing) {
                        await _repo!.updateAccount(existing!.id, account);
                      } else {
                        await _repo!.insertAccount(account);
                      }
                      
                      Navigator.pop(context);
                      _loadData();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCFB53B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isEditing ? 'Update' : 'Add Account',
                      style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '', decimalDigits: 2).format(amount);
  }
}
