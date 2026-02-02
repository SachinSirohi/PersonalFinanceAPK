import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Currency formatting utilities
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount with currency symbol
  static String format(double amount, String currency) {
    final NumberFormat formatter;
    
    switch (currency) {
      case AppConstants.currencyINR:
        // Use Indian number system (lakhs, crores)
        formatter = NumberFormat.currency(
          locale: 'en_IN',
          symbol: AppConstants.symbolINR,
          decimalDigits: 2,
        );
        break;
      case AppConstants.currencyAED:
        formatter = NumberFormat.currency(
          locale: 'ar_AE',
          symbol: '${AppConstants.symbolAED} ',
          decimalDigits: 2,
        );
        break;
      case AppConstants.currencyUSD:
        formatter = NumberFormat.currency(
          locale: 'en_US',
          symbol: AppConstants.symbolUSD,
          decimalDigits: 2,
        );
        break;
      default:
        formatter = NumberFormat.currency(
          symbol: '$currency ',
          decimalDigits: 2,
        );
    }
    
    return formatter.format(amount);
  }

  /// Format amount in compact form (e.g., 1.2M, 50K)
  static String formatCompact(double amount, String currency) {
    final symbol = _getSymbol(currency);
    
    if (amount.abs() >= 10000000) {
      // Crore for INR, Million for others
      if (currency == AppConstants.currencyINR) {
        return '$symbol${(amount / 10000000).toStringAsFixed(2)}Cr';
      }
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 100000) {
      // Lakh for INR
      if (currency == AppConstants.currencyINR) {
        return '$symbol${(amount / 100000).toStringAsFixed(2)}L';
      }
      return '$symbol${(amount / 1000).toStringAsFixed(0)}K';
    } else if (amount.abs() >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    
    return format(amount, currency);
  }

  /// Get currency symbol
  static String _getSymbol(String currency) {
    switch (currency) {
      case AppConstants.currencyINR:
        return AppConstants.symbolINR;
      case AppConstants.currencyAED:
        return AppConstants.symbolAED;
      case AppConstants.currencyUSD:
        return AppConstants.symbolUSD;
      default:
        return currency;
    }
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 2}) {
    final formatter = NumberFormat.decimalPatternDigits(
      decimalDigits: decimals,
    );
    return '${formatter.format(value)}%';
  }

  /// Format number with commas
  static String formatNumber(double value, {int decimals = 0}) {
    final formatter = NumberFormat.decimalPatternDigits(
      decimalDigits: decimals,
    );
    return formatter.format(value);
  }

  /// Parse currency string to double
  static double? parse(String value) {
    // Remove currency symbols and formatting
    final cleanValue = value
        .replaceAll(AppConstants.symbolAED, '')
        .replaceAll(AppConstants.symbolINR, '')
        .replaceAll(AppConstants.symbolUSD, '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    
    return double.tryParse(cleanValue);
  }
}

/// Date formatting utilities
class DateFormatter {
  DateFormatter._();

  /// Format date for display
  static String formatDisplay(DateTime date) {
    return DateFormat(AppConstants.dateFormatDisplay).format(date);
  }

  /// Format date for storage
  static String formatStorage(DateTime date) {
    return DateFormat(AppConstants.dateFormatStorage).format(date);
  }

  /// Format date with time
  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }

  /// Format as month and year
  static String formatMonthYear(DateTime date) {
    return DateFormat(AppConstants.monthYearFormat).format(date);
  }

  /// Get relative time string (e.g., "2 days ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Parse date from display format
  static DateTime? parseDisplay(String value) {
    try {
      return DateFormat(AppConstants.dateFormatDisplay).parse(value);
    } catch (e) {
      return null;
    }
  }

  /// Parse date from storage format
  static DateTime? parseStorage(String value) {
    try {
      return DateFormat(AppConstants.dateFormatStorage).parse(value);
    } catch (e) {
      return null;
    }
  }

  /// Get years between two dates
  static int yearsBetween(DateTime from, DateTime to) {
    return to.year - from.year;
  }

  /// Get months between two dates
  static int monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }
}

/// Financial calculation utilities
class FinancialCalculator {
  FinancialCalculator._();

  /// Calculate Future Value
  /// FV = PV × (1 + r)^n
  static double futureValue({
    required double presentValue,
    required double rate, // Annual rate as percentage (e.g., 10 for 10%)
    required int years,
  }) {
    final r = rate / 100;
    return presentValue * _pow(1 + r, years);
  }

  /// Calculate Present Value
  /// PV = FV / (1 + r)^n
  static double presentValue({
    required double futureValue,
    required double rate,
    required int years,
  }) {
    final r = rate / 100;
    return futureValue / _pow(1 + r, years);
  }

  /// Calculate required monthly SIP amount
  /// SIP = FV × r / ((1 + r)^n - 1)
  static double calculateSIP({
    required double targetAmount,
    required double annualReturn, // As percentage
    required int months,
  }) {
    if (months <= 0) return targetAmount;
    
    final r = annualReturn / 100 / 12; // Monthly rate
    if (r == 0) return targetAmount / months;
    
    final denominator = _pow(1 + r, months) - 1;
    return (targetAmount * r) / denominator;
  }

  /// Calculate future value of SIP
  /// FV = SIP × (((1 + r)^n - 1) / r) × (1 + r)
  static double calculateSIPFutureValue({
    required double sip,
    required double annualReturn,
    required int months,
  }) {
    if (months <= 0) return 0;
    
    final r = annualReturn / 100 / 12;
    if (r == 0) return sip * months;
    
    return sip * ((_pow(1 + r, months) - 1) / r) * (1 + r);
  }

  /// Calculate EMI
  /// EMI = P × r × (1 + r)^n / ((1 + r)^n - 1)
  static double calculateEMI({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    if (months <= 0) return principal;
    
    final r = annualRate / 100 / 12;
    if (r == 0) return principal / months;
    
    final factor = _pow(1 + r, months);
    return principal * r * factor / (factor - 1);
  }

  /// Calculate Internal Rate of Return (simplified Newton-Raphson)
  static double? calculateIRR({
    required List<double> cashflows,
    double guess = 0.1,
    int maxIterations = 100,
    double tolerance = 0.0001,
  }) {
    if (cashflows.isEmpty) return null;
    
    double rate = guess;
    
    for (int i = 0; i < maxIterations; i++) {
      double npv = 0;
      double dnpv = 0;
      
      for (int j = 0; j < cashflows.length; j++) {
        npv += cashflows[j] / _pow(1 + rate, j);
        dnpv -= j * cashflows[j] / _pow(1 + rate, j + 1);
      }
      
      if (dnpv == 0) return null;
      
      final newRate = rate - npv / dnpv;
      
      if ((newRate - rate).abs() < tolerance) {
        return newRate * 100; // Return as percentage
      }
      
      rate = newRate;
    }
    
    return null;
  }

  /// Calculate Net Present Value
  static double calculateNPV({
    required List<double> cashflows,
    required double discountRate,
  }) {
    final r = discountRate / 100;
    double npv = 0;
    
    for (int i = 0; i < cashflows.length; i++) {
      npv += cashflows[i] / _pow(1 + r, i);
    }
    
    return npv;
  }

  /// Calculate Cap Rate
  /// Cap Rate = NOI / Property Value
  static double calculateCapRate({
    required double noi, // Net Operating Income
    required double propertyValue,
  }) {
    if (propertyValue == 0) return 0;
    return (noi / propertyValue) * 100;
  }

  /// Calculate Cash-on-Cash Return
  /// CoC = Annual Pre-Tax Cashflow / Total Cash Invested
  static double calculateCashOnCash({
    required double annualCashflow,
    required double totalCashInvested,
  }) {
    if (totalCashInvested == 0) return 0;
    return (annualCashflow / totalCashInvested) * 100;
  }

  /// Calculate Debt Service Coverage Ratio
  /// DSCR = NOI / Annual Debt Service
  static double calculateDSCR({
    required double noi,
    required double annualDebtService,
  }) {
    if (annualDebtService == 0) return double.infinity;
    return noi / annualDebtService;
  }

  /// Helper power function
  static double _pow(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent.abs(); i++) {
      result *= base;
    }
    return exponent >= 0 ? result : 1 / result;
  }
}
