import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/screens/home_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/net_worth/screens/net_worth_screen.dart';
import '../features/real_estate/screens/real_estate_screen.dart';
import '../features/goals/screens/goals_screen.dart';
import '../features/expenses/screens/expenses_screen.dart';
import '../features/investments/screens/investments_screen.dart';
import '../features/reports/screens/reports_screen.dart';
import '../features/transactions/screens/transactions_screen.dart';
import '../features/accounts/screens/accounts_screen.dart';
import '../features/assets/screens/assets_screen.dart';
import 'main_shell.dart';

/// App route definitions
class AppRoutes {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String netWorth = '/net-worth';
  static const String realEstate = '/real-estate';
  static const String goals = '/goals';
  static const String expenses = '/expenses';
  static const String investments = '/investments';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String transactions = '/transactions';
  static const String accounts = '/accounts';
  static const String assets = '/assets';
  
  // Sub-routes
  static const String propertyDetail = '/real-estate/:id';
  static const String goalDetail = '/goals/:id';
  static const String addTransaction = '/add-transaction';
  static const String addProperty = '/add-property';
  static const String addInvestment = '/add-investment';
  static const String addGoal = '/add-goal';
}

/// App router configuration with go_router
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Main shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.netWorth,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const NetWorthScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.realEstate,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const RealEstateScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.goals,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const GoalsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.expenses,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const ExpensesScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.investments,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const InvestmentsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.reports,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const ReportsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.transactions,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const TransactionsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.accounts,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const AccountsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.assets,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const AssetsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              state,
              const DashboardScreen(),
            ),
          ),
        ],
      ),
    ],
  );

  /// iOS-style page transition
  static CustomTransitionPage _buildPageWithAnimation(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // iOS-style slide transition
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        final offsetAnimation = animation.drive(tween);
        
        // Fade effect for smoother transition
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
