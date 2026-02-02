import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Main theme configuration for iOS-like appearance
class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        fontFamily: AppTypography.fontFamily,
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: AppTypography.navTitle(),
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        
        // Color Scheme
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.backgroundSecondary,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: AppColors.textPrimary,
          onError: Colors.white,
        ),
        
        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.backgroundSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        
        // Bottom Navigation Bar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundSecondary,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          selectedLabelStyle: AppTypography.tabBar(isSelected: true),
          unselectedLabelStyle: AppTypography.tabBar(),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        
        // Divider Theme
        dividerTheme: const DividerThemeData(
          color: AppColors.separator,
          thickness: 0.5,
          space: 0,
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.fillTertiary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          hintStyle: AppTypography.body().copyWith(color: AppColors.textPlaceholder),
        ),
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: AppTypography.buttonLarge(),
          ),
        ),
        
        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: AppTypography.buttonMedium().copyWith(color: AppColors.primary),
          ),
        ),
        
        // Icon Theme
        iconTheme: const IconThemeData(
          color: AppColors.primary,
          size: 24,
        ),
        
        // List Tile Theme
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          minLeadingWidth: 0,
          titleTextStyle: AppTypography.listTitle(),
          subtitleTextStyle: AppTypography.listSubtitle(),
        ),
        
        // Dialog Theme
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.backgroundSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          titleTextStyle: AppTypography.title3(),
          contentTextStyle: AppTypography.body(),
        ),
        
        // Bottom Sheet Theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.backgroundSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          ),
          modalElevation: 0,
          modalBackgroundColor: AppColors.backgroundSecondary,
        ),
        
        // Snack Bar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.backgroundSecondaryDark,
          contentTextStyle: AppTypography.body(isDark: true),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        
        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.fillTertiary,
          labelStyle: AppTypography.caption1(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        
        // Switch Theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.systemGreen;
            }
            return AppColors.fillSecondary;
          }),
        ),
      );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryDark,
        scaffoldBackgroundColor: AppColors.backgroundPrimaryDark,
        fontFamily: AppTypography.fontFamily,
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: AppTypography.navTitle(isDark: true),
          iconTheme: const IconThemeData(color: AppColors.primaryDark),
        ),
        
        // Color Scheme
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryDark,
          secondary: AppColors.accentDark,
          surface: AppColors.backgroundSecondaryDark,
          error: AppColors.errorDark,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: AppColors.textPrimaryDark,
          onError: Colors.black,
        ),
        
        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.backgroundSecondaryDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        
        // Bottom Navigation Bar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundSecondaryDark,
          selectedItemColor: AppColors.primaryDark,
          unselectedItemColor: AppColors.textTertiaryDark,
          selectedLabelStyle: AppTypography.tabBar(isDark: true, isSelected: true),
          unselectedLabelStyle: AppTypography.tabBar(isDark: true),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        
        // Divider Theme
        dividerTheme: const DividerThemeData(
          color: AppColors.separatorDark,
          thickness: 0.5,
          space: 0,
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.fillTertiaryDark,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.errorDark, width: 1),
          ),
          hintStyle: AppTypography.body(isDark: true).copyWith(color: AppColors.textPlaceholderDark),
        ),
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: AppTypography.buttonLarge(isDark: true),
          ),
        ),
        
        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: AppTypography.buttonMedium(isDark: true).copyWith(color: AppColors.primaryDark),
          ),
        ),
        
        // Icon Theme
        iconTheme: const IconThemeData(
          color: AppColors.primaryDark,
          size: 24,
        ),
        
        // List Tile Theme
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          minLeadingWidth: 0,
          titleTextStyle: AppTypography.listTitle(isDark: true),
          subtitleTextStyle: AppTypography.listSubtitle(isDark: true),
        ),
        
        // Dialog Theme
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.backgroundSecondaryDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          titleTextStyle: AppTypography.title3(isDark: true),
          contentTextStyle: AppTypography.body(isDark: true),
        ),
        
        // Bottom Sheet Theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.backgroundSecondaryDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          ),
          modalElevation: 0,
          modalBackgroundColor: AppColors.backgroundSecondaryDark,
        ),
        
        // Snack Bar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.backgroundTertiaryDark,
          contentTextStyle: AppTypography.body(isDark: true),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        
        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.fillTertiaryDark,
          labelStyle: AppTypography.caption1(isDark: true),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        
        // Switch Theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.systemGreenDark;
            }
            return AppColors.fillSecondaryDark;
          }),
        ),
      );

  // Cupertino Theme for iOS-specific widgets
  static CupertinoThemeData get cupertinoLightTheme => const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        primaryContrastingColor: Colors.white,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        barBackgroundColor: AppColors.glassPrimary,
      );

  static CupertinoThemeData get cupertinoDarkTheme => const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryDark,
        primaryContrastingColor: Colors.white,
        scaffoldBackgroundColor: AppColors.backgroundPrimaryDark,
        barBackgroundColor: AppColors.glassPrimaryDark,
      );
}
