import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// iOS-style text field with floating label
class IOSTextField extends StatefulWidget {
  final String label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const IOSTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<IOSTextField> createState() => _IOSTextFieldState();
}

class _IOSTextFieldState extends State<IOSTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _labelAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _hasText = widget.controller?.text.isNotEmpty ?? false;
    if (_hasText) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused || _hasText) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : _isFocused
                      ? (isDark ? AppColors.primaryDark : AppColors.primary)
                      : Colors.transparent,
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.prefix != null ? 8 : 16,
              right: widget.suffix != null ? 8 : 16,
              top: 8,
              bottom: 8,
            ),
            child: Row(
              children: [
                if (widget.prefix != null) ...[
                  widget.prefix!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Stack(
                    children: [
                      // Floating Label
                      AnimatedBuilder(
                        animation: _labelAnimation,
                        builder: (context, child) {
                          return Positioned(
                            left: 0,
                            top: Tween<double>(begin: 14, end: 0)
                                .evaluate(_labelAnimation),
                            child: Text(
                              widget.label,
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: Tween<double>(begin: 17, end: 12)
                                    .evaluate(_labelAnimation),
                                fontWeight: FontWeight.w400,
                                color: hasError
                                    ? AppColors.error
                                    : _isFocused
                                        ? (isDark
                                            ? AppColors.primaryDark
                                            : AppColors.primary)
                                        : (isDark
                                            ? AppColors.textTertiaryDark
                                            : AppColors.textTertiary),
                              ),
                            ),
                          );
                        },
                      ),
                      // Text Field
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          keyboardType: widget.keyboardType,
                          obscureText: widget.obscureText,
                          maxLines: widget.maxLines,
                          maxLength: widget.maxLength,
                          readOnly: widget.readOnly,
                          autofocus: widget.autofocus,
                          textInputAction: widget.textInputAction,
                          style: AppTypography.body(isDark: isDark),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: _isFocused ? widget.placeholder : null,
                            hintStyle: AppTypography.body(isDark: isDark)
                                .copyWith(
                                  color: isDark
                                      ? AppColors.textPlaceholderDark
                                      : AppColors.textPlaceholder,
                                ),
                            counterText: '',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _hasText = value.isNotEmpty;
                            });
                            if (_hasText || _isFocused) {
                              _animationController.forward();
                            } else {
                              _animationController.reverse();
                            }
                            widget.onChanged?.call(value);
                          },
                          onTap: widget.onTap,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.suffix != null) ...[
                  const SizedBox(width: 8),
                  widget.suffix!,
                ],
              ],
            ),
          ),
        ),
        if (widget.helperText != null || widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 6),
            child: Text(
              widget.errorText ?? widget.helperText ?? '',
              style: AppTypography.caption1(isDark: isDark).copyWith(
                color: hasError
                    ? AppColors.error
                    : (isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiary),
              ),
            ),
          ),
      ],
    );
  }
}

/// iOS-style currency input field
class IOSCurrencyField extends StatelessWidget {
  final String label;
  final String currency; // AED or INR
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const IOSCurrencyField({
    super.key,
    required this.label,
    required this.currency,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencySymbol = currency == 'AED' ? 'د.إ' : '₹';
    final currencyColor = currency == 'AED' ? AppColors.aed : AppColors.inr;

    return IOSTextField(
      label: label,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      errorText: errorText,
      onChanged: onChanged,
      prefix: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: currencyColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          currencySymbol,
          style: AppTypography.headline(isDark: isDark).copyWith(
            color: currencyColor,
          ),
        ),
      ),
    );
  }
}

/// iOS-style search field
class IOSSearchField extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmit;

  const IOSSearchField({
    super.key,
    this.placeholder = 'Search',
    this.controller,
    this.onChanged,
    this.onClear,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? AppColors.fillTertiaryDark : AppColors.fillTertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: AppTypography.body(isDark: isDark).copyWith(fontSize: 17),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
          suffixIcon: controller?.text.isNotEmpty ?? false
              ? IconButton(
                  icon: Icon(
                    Icons.cancel,
                    size: 18,
                    color: isDark
                        ? AppColors.textQuaternaryDark
                        : AppColors.textQuaternary,
                  ),
                  onPressed: () {
                    controller?.clear();
                    onClear?.call();
                  },
                )
              : null,
          hintText: placeholder,
          hintStyle: AppTypography.body(isDark: isDark).copyWith(
            color: isDark
                ? AppColors.textPlaceholderDark
                : AppColors.textPlaceholder,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onChanged: onChanged,
        onSubmitted: (_) => onSubmit?.call(),
      ),
    );
  }
}

/// iOS-style date picker field
class IOSDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onChanged;
  final String? errorText;

  const IOSDateField({
    super.key,
    required this.label,
    this.value,
    this.firstDate,
    this.lastDate,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IOSTextField(
      label: label,
      readOnly: true,
      errorText: errorText,
      controller: TextEditingController(
        text: value != null
            ? '${value!.day.toString().padLeft(2, '0')}/${value!.month.toString().padLeft(2, '0')}/${value!.year}'
            : '',
      ),
      suffix: Icon(
        Icons.calendar_today_outlined,
        size: 20,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
      ),
      onTap: () async {
        HapticFeedback.lightImpact();
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: isDark ? AppColors.primaryDark : AppColors.primary,
                  onPrimary: Colors.white,
                  surface: isDark
                      ? AppColors.backgroundSecondaryDark
                      : AppColors.backgroundSecondary,
                  onSurface:
                      isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
    );
  }
}

/// iOS-style dropdown/picker field
class IOSPickerField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? errorText;

  const IOSPickerField({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IOSTextField(
      label: label,
      readOnly: true,
      errorText: errorText,
      controller: TextEditingController(
        text: value != null ? itemLabel(value as T) : '',
      ),
      suffix: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 24,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => _PickerSheet<T>(
            items: items,
            itemLabel: itemLabel,
            selectedValue: value,
            onSelected: (item) {
              onChanged(item);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class _PickerSheet<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final T? selectedValue;
  final ValueChanged<T> onSelected;

  const _PickerSheet({
    required this.items,
    required this.itemLabel,
    this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.backgroundSecondaryDark : AppColors.backgroundSecondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: isDark ? AppColors.fillSecondaryDark : AppColors.fillSecondary,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                height: 0.5,
                thickness: 0.5,
                indent: 16,
                color: isDark ? AppColors.separatorDark : AppColors.separator,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedValue;
                return ListTile(
                  title: Text(
                    itemLabel(item),
                    style: AppTypography.body(isDark: isDark).copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color:
                              isDark ? AppColors.primaryDark : AppColors.primary,
                        )
                      : null,
                  onTap: () => onSelected(item),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
