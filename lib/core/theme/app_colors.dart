import 'package:flutter/material.dart';

/// iOS-inspired color palette for the Personal Finance app
/// Using Apple's Human Interface Guidelines color system
class AppColors {
  AppColors._();

  // Primary Brand Colors - Deep Blue with Gold accents (Finance theme)
  static const Color primary = Color(0xFF007AFF); // iOS Blue
  static const Color primaryDark = Color(0xFF0A84FF);
  static const Color accent = Color(0xFFFFD60A); // Gold accent
  static const Color accentDark = Color(0xFFFFD426);

  // iOS System Colors
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemIndigo = Color(0xFF5856D6);
  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemPink = Color(0xFFFF2D55);
  static const Color systemPurple = Color(0xFFAF52DE);
  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemTeal = Color(0xFF5AC8FA);
  static const Color systemYellow = Color(0xFFFFCC00);

  // Dark Mode System Colors
  static const Color systemBlueDark = Color(0xFF0A84FF);
  static const Color systemGreenDark = Color(0xFF30D158);
  static const Color systemIndigoDark = Color(0xFF5E5CE6);
  static const Color systemOrangeDark = Color(0xFFFF9F0A);
  static const Color systemPinkDark = Color(0xFFFF375F);
  static const Color systemPurpleDark = Color(0xFFBF5AF2);
  static const Color systemRedDark = Color(0xFFFF453A);
  static const Color systemTealDark = Color(0xFF64D2FF);
  static const Color systemYellowDark = Color(0xFFFFD60A);

  // Background Colors - Light Mode
  static const Color backgroundPrimary = Color(0xFFF2F2F7);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color backgroundTertiary = Color(0xFFFFFFFF);
  static const Color backgroundGrouped = Color(0xFFF2F2F7);
  static const Color backgroundGroupedSecondary = Color(0xFFFFFFFF);

  // Background Colors - Dark Mode
  static const Color backgroundPrimaryDark = Color(0xFF000000);
  static const Color backgroundSecondaryDark = Color(0xFF1C1C1E);
  static const Color backgroundTertiaryDark = Color(0xFF2C2C2E);
  static const Color backgroundGroupedDark = Color(0xFF000000);
  static const Color backgroundGroupedSecondaryDark = Color(0xFF1C1C1E);

  // Glass Morphism Colors
  static const Color glassPrimary = Color(0x99FFFFFF);
  static const Color glassPrimaryDark = Color(0x4D1C1C1E);
  static const Color glassSecondary = Color(0x66FFFFFF);
  static const Color glassSecondaryDark = Color(0x332C2C2E);

  // Text Colors - Light Mode
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF3C3C43);
  static const Color textTertiary = Color(0xFF787880);
  static const Color textQuaternary = Color(0xFFC7C7CC);
  static const Color textPlaceholder = Color(0xFFC7C7CC);

  // Text Colors - Dark Mode
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFEBEBF5);
  static const Color textTertiaryDark = Color(0xFFABABB3);
  static const Color textQuaternaryDark = Color(0xFF636366);
  static const Color textPlaceholderDark = Color(0xFF636366);

  // Separator Colors
  static const Color separator = Color(0x4D3C3C43);
  static const Color separatorDark = Color(0x99545458);

  // Fill Colors - Light Mode
  static const Color fillPrimary = Color(0x33787880);
  static const Color fillSecondary = Color(0x29787880);
  static const Color fillTertiary = Color(0x1F767680);
  static const Color fillQuaternary = Color(0x14747480);

  // Fill Colors - Dark Mode
  static const Color fillPrimaryDark = Color(0x5C787880);
  static const Color fillSecondaryDark = Color(0x52787880);
  static const Color fillTertiaryDark = Color(0x3D767680);
  static const Color fillQuaternaryDark = Color(0x2E747480);

  // Status Colors
  static const Color success = systemGreen;
  static const Color successDark = systemGreenDark;
  static const Color warning = systemOrange;
  static const Color warningDark = systemOrangeDark;
  static const Color error = systemRed;
  static const Color errorDark = systemRedDark;
  static const Color info = systemBlue;
  static const Color infoDark = systemBlueDark;

  // Finance-specific Colors
  static const Color income = Color(0xFF34C759);
  static const Color incomeDark = Color(0xFF30D158);
  static const Color expense = Color(0xFFFF3B30);
  static const Color expenseDark = Color(0xFFFF453A);
  static const Color investment = Color(0xFF5856D6);
  static const Color investmentDark = Color(0xFF5E5CE6);
  static const Color savings = Color(0xFF007AFF);
  static const Color savingsDark = Color(0xFF0A84FF);

  // Currency Colors
  static const Color aed = Color(0xFF00A86B); // Emirates Green
  static const Color inr = Color(0xFFFF9933); // India Saffron

  // Chart Colors
  static const List<Color> chartColors = [
    systemBlue,
    systemGreen,
    systemOrange,
    systemPurple,
    systemPink,
    systemTeal,
    systemIndigo,
    systemYellow,
    systemRed,
  ];

  static const List<Color> chartColorsDark = [
    systemBlueDark,
    systemGreenDark,
    systemOrangeDark,
    systemPurpleDark,
    systemPinkDark,
    systemTealDark,
    systemIndigoDark,
    systemYellowDark,
    systemRedDark,
  ];

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD60A), Color(0xFFFF9500)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34C759), Color(0xFF30D158)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF3B30), Color(0xFFFF2D55)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x40FFFFFF), Color(0x10FFFFFF)],
  );

  static const LinearGradient glassGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x201C1C1E), Color(0x101C1C1E)],
  );

  // Card Gradients for different asset types
  static const LinearGradient realEstateGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  );

  static const LinearGradient investmentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
  );

  static const LinearGradient goalsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
  );

  static const LinearGradient cashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
  );
}
