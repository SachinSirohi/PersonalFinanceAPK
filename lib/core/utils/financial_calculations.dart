import 'dart:math';

/// Financial calculations utility for WealthOrbit
/// Includes XIRR, SIP, IRR, NPV, and other financial formulas
class FinancialCalculations {
  
  // ═══════════════════════════════════════════════════════════════════════════
  // XIRR CALCULATION (Extended Internal Rate of Return)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate XIRR for a series of cashflows with dates
  /// Returns annualized return rate as a decimal (e.g., 0.12 for 12%)
  static double calculateXIRR(List<double> cashflows, List<DateTime> dates, {double guess = 0.1}) {
    if (cashflows.isEmpty || cashflows.length != dates.length) {
      return 0.0;
    }
    
    // Need at least one positive and one negative cashflow
    bool hasPositive = cashflows.any((c) => c > 0);
    bool hasNegative = cashflows.any((c) => c < 0);
    if (!hasPositive || !hasNegative) return 0.0;
    
    double rate = guess;
    const int maxIterations = 100;
    const double tolerance = 0.0000001;
    
    for (int i = 0; i < maxIterations; i++) {
      double npv = _calculateNPVForXIRR(cashflows, dates, rate);
      double npvDerivative = _calculateNPVDerivativeForXIRR(cashflows, dates, rate);
      
      if (npvDerivative.abs() < tolerance) break;
      
      double newRate = rate - npv / npvDerivative;
      
      if ((newRate - rate).abs() < tolerance) {
        return newRate;
      }
      
      rate = newRate;
    }
    
    return rate;
  }
  
  static double _calculateNPVForXIRR(List<double> cashflows, List<DateTime> dates, double rate) {
    double npv = 0.0;
    DateTime startDate = dates.first;
    
    for (int i = 0; i < cashflows.length; i++) {
      double years = dates[i].difference(startDate).inDays / 365.0;
      npv += cashflows[i] / pow(1 + rate, years);
    }
    
    return npv;
  }
  
  static double _calculateNPVDerivativeForXIRR(List<double> cashflows, List<DateTime> dates, double rate) {
    double derivative = 0.0;
    DateTime startDate = dates.first;
    
    for (int i = 0; i < cashflows.length; i++) {
      double years = dates[i].difference(startDate).inDays / 365.0;
      derivative -= years * cashflows[i] / pow(1 + rate, years + 1);
    }
    
    return derivative;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SIP CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate required monthly SIP to reach a target amount
  /// [targetAmount] - Future value needed
  /// [currentCorpus] - Current amount already invested
  /// [annualReturn] - Expected annual return rate as decimal (0.12 for 12%)
  /// [months] - Number of months to invest
  static double calculateRequiredSIP({
    required double targetAmount,
    double currentCorpus = 0,
    required double annualReturn,
    required int months,
  }) {
    if (months <= 0) return 0;
    
    double monthlyRate = annualReturn / 12;
    
    // Future value of current corpus
    double corpusFV = currentCorpus * pow(1 + monthlyRate, months);
    
    // Remaining amount needed from SIP
    double remainingAmount = targetAmount - corpusFV;
    if (remainingAmount <= 0) return 0;
    
    // SIP formula: SIP = FV * r / ((1 + r)^n - 1)
    double sip = remainingAmount * monthlyRate / (pow(1 + monthlyRate, months) - 1);
    
    return sip;
  }
  
  /// Calculate future value of SIP investments
  static double calculateSIPFutureValue({
    required double monthlyInvestment,
    required double annualReturn,
    required int months,
  }) {
    if (months <= 0 || monthlyInvestment <= 0) return 0;
    
    double monthlyRate = annualReturn / 12;
    
    // FV = SIP * ((1 + r)^n - 1) / r * (1 + r)
    double fv = monthlyInvestment * ((pow(1 + monthlyRate, months) - 1) / monthlyRate) * (1 + monthlyRate);
    
    return fv;
  }
  
  /// Calculate total value of lump sum + SIP
  static double calculateTotalFutureValue({
    required double lumpSum,
    required double monthlyInvestment,
    required double annualReturn,
    required int months,
  }) {
    double lumpSumFV = lumpSum * pow(1 + annualReturn / 12, months);
    double sipFV = calculateSIPFutureValue(
      monthlyInvestment: monthlyInvestment,
      annualReturn: annualReturn,
      months: months,
    );
    return lumpSumFV + sipFV;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GOAL PLANNING CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate future value adjusted for inflation
  static double calculateInflationAdjustedGoal({
    required double currentValue,
    required double inflationRate,
    required int years,
  }) {
    return currentValue * pow(1 + inflationRate, years);
  }
  
  /// Calculate goal achievement probability based on historical returns
  static String calculateGoalProbability({
    required double targetAmount,
    required double currentCorpus,
    required double sipAmount,
    required int months,
    required double expectedReturn,
  }) {
    double fv = calculateTotalFutureValue(
      lumpSum: currentCorpus,
      monthlyInvestment: sipAmount,
      annualReturn: expectedReturn,
      months: months,
    );
    
    double ratio = fv / targetAmount;
    
    if (ratio >= 1.2) return 'Very High';
    if (ratio >= 1.0) return 'High';
    if (ratio >= 0.8) return 'Moderate';
    if (ratio >= 0.5) return 'Low';
    return 'Very Low';
  }
  
  /// Simplified SIP calculation for goal shortfall
  /// [shortfall] - Amount needed to reach goal
  /// [annualReturnPercent] - Expected return as percentage (e.g., 10 for 10%)
  /// [months] - Months until target date
  static double calculateMonthlySIPForGoal(double shortfall, double annualReturnPercent, int months) {
    if (shortfall <= 0 || months <= 0) return 0;
    return calculateRequiredSIP(
      targetAmount: shortfall,
      currentCorpus: 0,
      annualReturn: annualReturnPercent / 100,
      months: months,
    );
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // REAL ESTATE CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate Internal Rate of Return (IRR) for real estate
  static double calculateIRR(List<double> cashflows, {double guess = 0.1}) {
    if (cashflows.isEmpty) return 0.0;
    
    double rate = guess;
    const int maxIterations = 100;
    const double tolerance = 0.0000001;
    
    for (int i = 0; i < maxIterations; i++) {
      double npv = 0.0;
      double npvDerivative = 0.0;
      
      for (int j = 0; j < cashflows.length; j++) {
        npv += cashflows[j] / pow(1 + rate, j);
        npvDerivative -= j * cashflows[j] / pow(1 + rate, j + 1);
      }
      
      if (npvDerivative.abs() < tolerance) break;
      
      double newRate = rate - npv / npvDerivative;
      
      if ((newRate - rate).abs() < tolerance) {
        return newRate;
      }
      
      rate = newRate;
    }
    
    return rate;
  }
  
  /// Calculate Net Present Value (NPV)
  static double calculateNPV({
    required List<double> cashflows,
    required double discountRate,
  }) {
    double npv = 0.0;
    
    for (int i = 0; i < cashflows.length; i++) {
      npv += cashflows[i] / pow(1 + discountRate, i);
    }
    
    return npv;
  }
  
  /// Calculate Cash-on-Cash Return
  static double calculateCashOnCashReturn({
    required double annualCashflow,
    required double initialEquity,
  }) {
    if (initialEquity <= 0) return 0;
    return annualCashflow / initialEquity;
  }
  
  /// Calculate Equity Multiple
  static double calculateEquityMultiple({
    required double totalReturns,
    required double initialEquity,
  }) {
    if (initialEquity <= 0) return 0;
    return totalReturns / initialEquity;
  }
  
  /// Calculate Cap Rate
  static double calculateCapRate({
    required double netOperatingIncome,
    required double propertyValue,
  }) {
    if (propertyValue <= 0) return 0;
    return netOperatingIncome / propertyValue;
  }
  
  /// Calculate Gross Yield
  static double calculateGrossYield({
    required double annualRentalIncome,
    required double propertyValue,
  }) {
    if (propertyValue <= 0) return 0;
    return annualRentalIncome / propertyValue;
  }
  
  /// Calculate Net Yield (after expenses)
  static double calculateNetYield({
    required double annualRentalIncome,
    required double annualExpenses,
    required double propertyValue,
  }) {
    if (propertyValue <= 0) return 0;
    return (annualRentalIncome - annualExpenses) / propertyValue;
  }
  
  /// Calculate property exit proceeds
  static double calculateExitProceeds({
    required double salePrice,
    required double outstandingMortgage,
    required double brokerageFee, // as decimal
    required double transferFee, // as decimal (e.g., 0.04 for DLD 4%)
    required double capitalGainsTax, // as decimal
    required double purchasePrice,
  }) {
    double sellingCosts = salePrice * (brokerageFee + transferFee);
    double capitalGains = max(0, salePrice - purchasePrice);
    double taxAmount = capitalGains * capitalGainsTax;
    
    return salePrice - outstandingMortgage - sellingCosts - taxAmount;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LOAN CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate EMI (Equated Monthly Installment)
  static double calculateEMI({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    if (tenureMonths <= 0 || principal <= 0) return 0;
    
    double monthlyRate = annualInterestRate / 12;
    
    if (monthlyRate == 0) return principal / tenureMonths;
    
    double emi = principal * monthlyRate * pow(1 + monthlyRate, tenureMonths) /
        (pow(1 + monthlyRate, tenureMonths) - 1);
    
    return emi;
  }
  
  /// Calculate total interest payable
  static double calculateTotalInterest({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    double emi = calculateEMI(
      principal: principal,
      annualInterestRate: annualInterestRate,
      tenureMonths: tenureMonths,
    );
    
    return (emi * tenureMonths) - principal;
  }
  
  /// Calculate outstanding principal after N months
  static double calculateOutstandingPrincipal({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
    required int monthsPaid,
  }) {
    if (monthsPaid >= tenureMonths) return 0;
    
    double monthlyRate = annualInterestRate / 12;
    double emi = calculateEMI(
      principal: principal,
      annualInterestRate: annualInterestRate,
      tenureMonths: tenureMonths,
    );
    
    double outstanding = principal * pow(1 + monthlyRate, monthsPaid) -
        emi * (pow(1 + monthlyRate, monthsPaid) - 1) / monthlyRate;
    
    return max(0, outstanding);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EMERGENCY FUND CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate emergency fund months coverage
  static int calculateEmergencyFundMonths({
    required double liquidAssets,
    required double monthlyExpenses,
  }) {
    if (monthlyExpenses <= 0) return 0;
    return (liquidAssets / monthlyExpenses).floor();
  }
  
  /// Calculate recommended emergency fund amount
  static double calculateRecommendedEmergencyFund({
    required double monthlyExpenses,
    int recommendedMonths = 6,
  }) {
    return monthlyExpenses * recommendedMonths;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DEBT RATIOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate Debt-to-Asset Ratio
  static double calculateDebtToAssetRatio({
    required double totalDebt,
    required double totalAssets,
  }) {
    if (totalAssets <= 0) return 0;
    return totalDebt / totalAssets;
  }
  
  /// Calculate Debt Service Coverage Ratio (DSCR)
  static double calculateDSCR({
    required double netOperatingIncome,
    required double annualDebtService,
  }) {
    if (annualDebtService <= 0) return double.infinity;
    return netOperatingIncome / annualDebtService;
  }
}
