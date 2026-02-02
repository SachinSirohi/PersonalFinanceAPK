import 'package:flutter/material.dart';
import 'app_colors.dart';

/// iOS-inspired typography system following Apple's Human Interface Guidelines
class AppTypography {
  AppTypography._();

  // Font Family - Using system default for better compatibility
  // On iOS this will be SF Pro, on Android it will be Roboto
  static const String? fontFamily = null;

  // Large Title - Used for screen titles
  static TextStyle largeTitle({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.37,
        height: 1.2,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Title 1 - Main section headers
  static TextStyle title1({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.36,
        height: 1.2,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Title 2 - Sub-section headers
  static TextStyle title2({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.35,
        height: 1.2,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Title 3 - Card titles
  static TextStyle title3({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.38,
        height: 1.25,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Headline - Emphasized body text
  static TextStyle headline({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        height: 1.29,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Body - Standard body text
  static TextStyle body({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.41,
        height: 1.29,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Callout - Slightly smaller than body
  static TextStyle callout({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.32,
        height: 1.31,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Subheadline - Supporting text
  static TextStyle subheadline({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.24,
        height: 1.33,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      );

  // Footnote - Small supporting text
  static TextStyle footnote({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.08,
        height: 1.38,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
      );

  // Caption 1 - Labels and indicator text
  static TextStyle caption1({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
      );

  // Caption 2 - Smallest text
  static TextStyle caption2({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.07,
        height: 1.18,
        color: isDark ? AppColors.textQuaternaryDark : AppColors.textQuaternary,
      );

  // Money Large - For displaying large amounts
  static TextStyle moneyLarge({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 42,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.1,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Money Medium - For card amounts
  static TextStyle moneyMedium({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.2,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Money Small - For list items
  static TextStyle moneySmall({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        height: 1.29,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // Percentage - For displaying percentages
  static TextStyle percentage({bool isDark = false, Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.24,
        height: 1.33,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
      );

  // Button text styles
  static TextStyle buttonLarge({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        height: 1.29,
        color: Colors.white,
      );

  static TextStyle buttonMedium({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.24,
        height: 1.33,
        color: Colors.white,
      );

  static TextStyle buttonSmall({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.08,
        height: 1.38,
        color: Colors.white,
      );

  // Tab bar text
  static TextStyle tabBar({bool isDark = false, bool isSelected = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        letterSpacing: 0,
        height: 1.2,
        color: isSelected
            ? (isDark ? AppColors.systemBlueDark : AppColors.systemBlue)
            : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary),
      );

  // Navigation title
  static TextStyle navTitle({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        height: 1.29,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  // List item text styles
  static TextStyle listTitle({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.41,
        height: 1.29,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      );

  static TextStyle listSubtitle({bool isDark = false}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.24,
        height: 1.33,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      );
}
