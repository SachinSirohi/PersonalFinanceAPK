import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// iOS-style primary button with gradient and shadow
class IOSPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Gradient? gradient;
  final double? width;

  const IOSPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradient,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed == null || isLoading ? null : () {
          HapticFeedback.lightImpact();
          onPressed!();
        },
        borderRadius: BorderRadius.circular(14),
        child: Opacity(
          opacity: onPressed == null ? 0.5 : 1.0,
          child: Container(
            width: width ?? double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: gradient ?? AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(77),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(text, style: AppTypography.buttonLarge()),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// iOS-style secondary button (outlined)
class IOSSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final double? width;

  const IOSSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = color ?? (isDark ? AppColors.primaryDark : AppColors.primary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed == null ? null : () {
          HapticFeedback.lightImpact();
          onPressed!();
        },
        borderRadius: BorderRadius.circular(14),
        child: Opacity(
          opacity: onPressed == null ? 0.5 : 1.0,
          child: Container(
            width: width ?? double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: buttonColor.withAlpha(26),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: buttonColor.withAlpha(77), width: 1.5),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: buttonColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text, style: AppTypography.buttonLarge().copyWith(color: buttonColor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// iOS-style text button
class IOSTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool bold;

  const IOSTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = color ?? (isDark ? AppColors.primaryDark : AppColors.primary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed == null ? null : () {
          HapticFeedback.lightImpact();
          onPressed!();
        },
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: onPressed == null ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: buttonColor, size: 18),
                  const SizedBox(width: 4),
                ],
                Text(
                  text,
                  style: AppTypography.body(isDark: isDark).copyWith(
                    color: buttonColor,
                    fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// iOS-style icon button with circular background
class IOSIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;

  const IOSIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed == null ? null : () {
          HapticFeedback.lightImpact();
          onPressed!();
        },
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? (isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor ?? (isDark ? AppColors.primaryDark : AppColors.primary),
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// iOS-style floating action button
class IOSFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Gradient? gradient;

  const IOSFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed == null ? null : () {
          HapticFeedback.mediumImpact();
          onPressed!();
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(102),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
