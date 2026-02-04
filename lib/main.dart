import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/services/secure_vault.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A1628),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  // Check if onboarding is complete (with error handling)
  bool onboardingComplete = false;
  try {
    onboardingComplete = await SecureVault.isOnboardingComplete();
  } catch (e) {
    // If error checking onboarding, assume not complete
    debugPrint('Error checking onboarding status: $e');
    onboardingComplete = false;
  }
  
  runApp(
    ProviderScope(
      child: WealthOrbitApp(showOnboarding: !onboardingComplete),
    ),
  );
}

class WealthOrbitApp extends StatelessWidget {
  final bool showOnboarding;
  
  const WealthOrbitApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WealthOrbit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFCFB53B),
        scaffoldBackgroundColor: const Color(0xFF0A1628),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFCFB53B),
          secondary: Color(0xFF5856D6),
          surface: Color(0xFF1A2744),
          error: Color(0xFFFF3B30),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1628),
          elevation: 0,
        ),
      ),
      home: showOnboarding 
          ? const OnboardingScreen() 
          : const DashboardScreen(),
      routes: {
        '/home': (context) => const DashboardScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
