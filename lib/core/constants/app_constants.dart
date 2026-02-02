/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'NRI Finance';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Personal Finance Management for NRIs';

  // Supported Currencies
  static const String currencyAED = 'AED';
  static const String currencyINR = 'INR';
  static const String currencyUSD = 'USD';

  // Currency Symbols
  static const String symbolAED = 'د.إ';
  static const String symbolINR = '₹';
  static const String symbolUSD = '\$';

  // Default values
  static const String defaultCurrency = currencyAED;
  static const double defaultInflationRate = 6.0; // 6% for India general
  static const double educationInflationRate = 10.0; // Higher for education
  static const double defaultReturnRate = 12.0; // Expected investment return

  // Date format
  static const String dateFormatDisplay = 'dd/MM/yyyy';
  static const String dateFormatStorage = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String monthYearFormat = 'MMM yyyy';

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 250);

  // Number formatting
  static const int maxDecimalPlaces = 2;
  static const int maxTransactions = 50000;
  static const int maxProperties = 100;
  static const int maxInvestments = 200;
  static const int maxGoals = 50;

  // Real Estate Constants - UAE
  static const double uaeDldFee = 4.0; // 4%
  static const double uaeMortgageRegistration = 0.25; // 0.25%
  static const double uaeAgencyCommission = 2.0; // 2%
  static const double uaeRentalTax = 0.0; // No rental income tax
  static const double uaeCapitalGainsTax = 0.0; // No CGT

  // Real Estate Constants - India
  static const double indiaStampDutyMin = 5.0; // 5-7%
  static const double indiaStampDutyMax = 7.0;
  static const double indiaRegistration = 1.0; // 1%
  static const double indiaBrokerage = 1.0; // 1-2%
  static const double indiaLtcgTax = 20.0; // 20% with indexation
  static const int indiaLtcgHoldingPeriod = 24; // months

  // Budget thresholds
  static const double budgetWarningThreshold = 70.0; // 70% - Yellow
  static const double budgetDangerThreshold = 90.0; // 90% - Red

  // Goal progress thresholds
  static const double goalOnTrackThreshold = 10.0; // Within 10% of target
  static const double goalBehindThreshold = 20.0; // More than 20% behind

  // Financial health thresholds
  static const double targetSavingsRate = 30.0; // 30%+
  static const double healthyDebtToIncome = 40.0; // <40%
  static const int emergencyFundMonths = 6;

  // Storage keys
  static const String keyMasterPassword = 'master_password_hash';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyThemeMode = 'theme_mode';
  static const String keyBaseCurrency = 'base_currency';
  static const String keyLastBackupDate = 'last_backup_date';
  static const String keyOnboardingComplete = 'onboarding_complete';
}

/// Asset categories as defined in BRD
enum AssetCategory {
  cash('Cash & Bank'),
  realEstate('Real Estate'),
  equity('Stocks & ETFs'),
  mutualFunds('Mutual Funds'),
  fixedIncome('Fixed Income'),
  providentFund('Provident Funds'),
  alternative('Alternative Assets');

  final String label;
  const AssetCategory(this.label);
}

/// Liability types
enum LiabilityType {
  homeLoan('Home Loan'),
  personalLoan('Personal Loan'),
  vehicleLoan('Vehicle Loan'),
  creditCard('Credit Card'),
  other('Other Debt');

  final String label;
  const LiabilityType(this.label);
}

/// Property types
enum PropertyType {
  residential('Residential'),
  commercial('Commercial'),
  land('Land');

  final String label;
  const PropertyType(this.label);
}

/// Geography (UAE or India)
enum Geography {
  uae('UAE'),
  india('India');

  final String label;
  const Geography(this.label);
}

/// Investment types
enum InvestmentType {
  stock('Stock'),
  mutualFund('Mutual Fund'),
  etf('ETF'),
  ppf('PPF'),
  nps('NPS'),
  fixedDeposit('Fixed Deposit'),
  bond('Bond'),
  epf('EPF'),
  recurringDeposit('Recurring Deposit');

  final String label;
  const InvestmentType(this.label);
}

/// Goal types (pre-configured templates)
enum GoalType {
  childEducation('Children\'s Education'),
  childMarriage('Children\'s Marriage'),
  homePurchase('Home Purchase'),
  retirement('Retirement'),
  vehiclePurchase('Vehicle Purchase'),
  vacation('Vacation/Travel'),
  emergencyFund('Emergency Fund'),
  custom('Custom Goal');

  final String label;
  const GoalType(this.label);
}

/// Risk profiles
enum RiskProfile {
  conservative('Conservative'),
  moderate('Moderate'),
  aggressive('Aggressive');

  final String label;
  const RiskProfile(this.label);
}

/// Transaction types
enum TransactionType {
  income('Income'),
  expense('Expense'),
  transfer('Transfer');

  final String label;
  const TransactionType(this.label);
}

/// Goal status
enum GoalStatus {
  ahead('Ahead'),
  onTrack('On Track'),
  behind('Behind'),
  critical('Critical');

  final String label;
  const GoalStatus(this.label);
}

/// Exit rule types for real estate
enum ExitRuleType {
  targetIRR('Target IRR'),
  targetEquity('Target Equity'),
  targetPrice('Target Price'),
  timeBased('Time Based'),
  yieldFloor('Yield Floor'),
  cashflowNegative('Cashflow Negative'),
  marketMultiple('Market Multiple'),
  debtMilestone('Debt Milestone');

  final String label;
  const ExitRuleType(this.label);
}
