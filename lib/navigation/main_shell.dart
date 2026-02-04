import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import 'app_router.dart';

/// Main navigation shell with iOS-style bottom tab bar
class MainShell extends StatefulWidget {
  final Widget child;
  
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabScale;
  
  int _currentIndex = 0;
  
  final List<_NavItem> _navItems = [
    _NavItem(icon: CupertinoIcons.house_fill, label: 'Home', route: AppRoutes.home),
    _NavItem(icon: CupertinoIcons.chart_pie_fill, label: 'Net Worth', route: AppRoutes.netWorth),
    _NavItem(icon: CupertinoIcons.building_2_fill, label: 'Property', route: AppRoutes.realEstate),
    _NavItem(icon: CupertinoIcons.chart_bar_alt_fill, label: 'Invest', route: AppRoutes.investments),
    _NavItem(icon: CupertinoIcons.doc_chart_fill, label: 'Reports', route: AppRoutes.reports),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );
    
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      HapticFeedback.lightImpact();
      setState(() => _currentIndex = index);
      context.go(_navItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Update current index based on location
    _updateCurrentIndex(context);

    return Scaffold(
      body: widget.child,
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showQuickAddMenu(context);
          },
          backgroundColor: AppColors.primary,
          elevation: 8,
          child: const Icon(CupertinoIcons.add, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }
  
  void _updateCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _navItems.length; i++) {
      if (location == _navItems[i].route) {
        if (_currentIndex != i) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentIndex = i);
          });
        }
        break;
      }
    }
  }

  Widget _buildBottomNav(bool isDark) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? AppColors.backgroundSecondaryDark : AppColors.backgroundSecondary,
      selectedItemColor: isDark ? AppColors.primaryDark : AppColors.primary,
      unselectedItemColor: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: _navItems.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        label: item.label,
      )).toList(),
    );
  }

  void _showQuickAddMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundSecondaryDark : AppColors.backgroundSecondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 36, height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.fillSecondaryDark : AppColors.fillSecondary,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 20),
              Text('Quick Add', style: AppTypography.title3(isDark: isDark)),
              const SizedBox(height: 16),
              _QuickAddItem(
                icon: CupertinoIcons.doc_text_fill, 
                color: AppColors.systemBlue, 
                title: 'Add Transaction', 
                subtitle: 'Record income or expense', 
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddTransactionDialog(context);
                },
              ),
              _QuickAddItem(
                icon: CupertinoIcons.building_2_fill, 
                color: AppColors.systemPurple, 
                title: 'Add Property', 
                subtitle: 'Add real estate to portfolio', 
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddPropertyDialog(context);
                },
              ),
              _QuickAddItem(
                icon: CupertinoIcons.chart_bar_alt_fill, 
                color: AppColors.systemGreen, 
                title: 'Add Investment', 
                subtitle: 'Track stocks, mutual funds', 
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddInvestmentDialog(context);
                },
              ),
              _QuickAddItem(
                icon: CupertinoIcons.flag_fill, 
                color: AppColors.systemOrange, 
                title: 'Create Goal', 
                subtitle: 'Set a financial objective', 
                onTap: () { 
                  Navigator.pop(ctx); 
                  context.go(AppRoutes.goals); 
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.backgroundSecondaryDark : AppColors.backgroundSecondary,
        title: Text('Add Transaction', style: AppTypography.title3(isDark: isDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Grocery shopping',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (AED)',
                hintText: '0.00',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.income,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Income'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.expense,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Expense'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _showAddPropertyDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.backgroundSecondaryDark : AppColors.backgroundSecondary,
        title: Text('Add Property', style: AppTypography.title3(isDark: isDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Property Name',
                hintText: 'e.g., Marina Apartment',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Purchase Price (AED)',
                hintText: '0.00',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., Dubai Marina',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Property added successfully!'), backgroundColor: AppColors.income),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddInvestmentDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.backgroundSecondaryDark : AppColors.backgroundSecondary,
        title: Text('Add Investment', style: AppTypography.title3(isDark: isDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Investment Type',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              items: const [
                DropdownMenuItem(value: 'mf', child: Text('Mutual Fund')),
                DropdownMenuItem(value: 'stocks', child: Text('Stocks')),
                DropdownMenuItem(value: 'ppf', child: Text('PPF')),
                DropdownMenuItem(value: 'nps', child: Text('NPS')),
                DropdownMenuItem(value: 'fd', child: Text('Fixed Deposit')),
              ],
              onChanged: (v) {},
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Investment Name',
                hintText: 'e.g., HDFC Flexicap Fund',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount Invested (INR)',
                hintText: '0.00',
                filled: true,
                fillColor: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Investment added successfully!'), backgroundColor: AppColors.income),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  _NavItem({required this.icon, required this.label, required this.route});
}

class _QuickAddItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAddItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: color.withAlpha(38), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.headline(isDark: isDark)),
                    Text(subtitle, style: AppTypography.footnote(isDark: isDark)),
                  ],
                ),
              ),
              Icon(CupertinoIcons.chevron_right, size: 18, color: isDark ? AppColors.textQuaternaryDark : AppColors.textQuaternary),
            ],
          ),
        ),
      ),
    );
  }
}
