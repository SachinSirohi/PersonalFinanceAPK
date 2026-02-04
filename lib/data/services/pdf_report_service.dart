import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../repositories/app_repository.dart';
import '../database/database.dart';

/// Service for generating PDF financial reports
class PdfReportService {
  final AppRepository _repository;
  
  PdfReportService(this._repository);
  
  /// Generate a comprehensive Financial Summary Report PDF
  Future<File> generateFinancialSummaryReport() async {
    final document = PdfDocument();
    
    // Fetch all data
    final totalAssets = await _repository.getTotalAssetValue();
    final totalAccounts = await _repository.getTotalAccountBalance();
    final totalLiabilities = await _repository.getTotalLiabilities();
    final netWorth = totalAssets + totalAccounts - totalLiabilities;
    
    final now = DateTime.now();
    final monthlyIncome = await _repository.getTotalIncomeByMonth(now.year, now.month);
    final monthlyExpenses = await _repository.getTotalExpensesByMonth(now.year, now.month);
    
    final assets = await _repository.getAllAssets();
    final goals = await _repository.getAllGoals();
    
    // Add pages
    _addTitlePage(document, 'Financial Summary Report');
    _addNetWorthPage(document, netWorth, totalAssets, totalAccounts, totalLiabilities);
    _addCashFlowPage(document, monthlyIncome, monthlyExpenses);
    _addAssetAllocationPage(document, assets);
    _addGoalsSummaryPage(document, goals);
    
    // Save to file
    final bytes = await document.save();
    document.dispose();
    
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'financial_summary_${DateFormat('yyyyMMdd_HHmmss').format(now)}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    
    return file;
  }
  
  /// Generate an Annual Report PDF
  Future<File> generateAnnualReport(int year) async {
    final document = PdfDocument();
    
    // Fetch yearly data
    double yearlyIncome = 0;
    double yearlyExpenses = 0;
    
    for (int month = 1; month <= 12; month++) {
      yearlyIncome += await _repository.getTotalIncomeByMonth(year, month);
      yearlyExpenses += await _repository.getTotalExpensesByMonth(year, month);
    }
    
    final netWorth = await _repository.getTotalAssetValue() + 
                     await _repository.getTotalAccountBalance() - 
                     await _repository.getTotalLiabilities();
    
    // Add pages
    _addTitlePage(document, 'Annual Financial Report $year');
    _addAnnualSummaryPage(document, year, yearlyIncome, yearlyExpenses, netWorth);
    
    // Save to file
    final bytes = await document.save();
    document.dispose();
    
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'annual_report_$year.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    
    return file;
  }
  
  /// Share a generated PDF file
  Future<void> shareReport(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Financial Report',
    );
  }
  
  void _addTitlePage(PdfDocument document, String title) {
    final page = document.pages.add();
    final graphics = page.graphics;
    final pageSize = page.getClientSize();
    
    // Title
    graphics.drawString(
      title,
      PdfStandardFont(PdfFontFamily.helvetica, 28, style: PdfFontStyle.bold),
      brush: PdfSolidBrush(PdfColor(10, 22, 40)),
      bounds: Rect.fromLTWH(0, 100, pageSize.width, 50),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    
    // Subtitle with date
    graphics.drawString(
      'Generated on ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(100, 100, 100)),
      bounds: Rect.fromLTWH(0, 150, pageSize.width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    
    // WealthOrbit branding
    graphics.drawString(
      'WealthOrbit',
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
      brush: PdfSolidBrush(PdfColor(207, 181, 59)), // Gold
      bounds: Rect.fromLTWH(0, 200, pageSize.width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    
    graphics.drawString(
      'Personal Wealth Management',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfSolidBrush(PdfColor(150, 150, 150)),
      bounds: Rect.fromLTWH(0, 220, pageSize.width, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
  }
  
  void _addNetWorthPage(PdfDocument document, double netWorth, double assets, double accounts, double liabilities) {
    final page = document.pages.add();
    final graphics = page.graphics;
    final pageSize = page.getClientSize();
    
    // Section header
    _drawSectionHeader(graphics, 'Net Worth Overview', 40);
    
    // Net Worth Box
    final netWorthFormatted = NumberFormat.currency(symbol: 'AED ', decimalDigits: 0).format(netWorth);
    graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(207, 181, 59, 30)),
      bounds: const Rect.fromLTWH(40, 80, 200, 60),
    );
    graphics.drawString(
      'Total Net Worth',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfSolidBrush(PdfColor(100, 100, 100)),
      bounds: const Rect.fromLTWH(50, 90, 180, 20),
    );
    graphics.drawString(
      netWorthFormatted,
      PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
      brush: PdfSolidBrush(PdfColor(10, 22, 40)),
      bounds: const Rect.fromLTWH(50, 110, 180, 25),
    );
    
    // Table of breakdown
    final grid = PdfGrid();
    grid.columns.add(count: 2);
    grid.headers.add(1);
    
    final headerRow = grid.headers[0];
    headerRow.cells[0].value = 'Category';
    headerRow.cells[1].value = 'Amount (AED)';
    _styleHeaderRow(headerRow);
    
    _addGridRow(grid, 'Total Assets', NumberFormat('#,###').format(assets));
    _addGridRow(grid, 'Bank Accounts', NumberFormat('#,###').format(accounts));
    _addGridRow(grid, 'Liabilities', '(${NumberFormat('#,###').format(liabilities)})');
    _addGridRow(grid, 'Net Worth', NumberFormat('#,###').format(netWorth));
    
    grid.draw(page: page, bounds: Rect.fromLTWH(40, 160, pageSize.width - 80, 200));
  }
  
  void _addCashFlowPage(PdfDocument document, double income, double expenses) {
    final page = document.pages.add();
    final graphics = page.graphics;
    
    _drawSectionHeader(graphics, 'Monthly Cash Flow', 40);
    
    final savings = income - expenses;
    final savingsRate = income > 0 ? (savings / income * 100) : 0;
    
    final grid = PdfGrid();
    grid.columns.add(count: 2);
    grid.headers.add(1);
    
    final headerRow = grid.headers[0];
    headerRow.cells[0].value = 'Item';
    headerRow.cells[1].value = 'Amount (AED)';
    _styleHeaderRow(headerRow);
    
    _addGridRow(grid, 'Monthly Income', NumberFormat('#,###').format(income));
    _addGridRow(grid, 'Monthly Expenses', NumberFormat('#,###').format(expenses));
    _addGridRow(grid, 'Net Savings', NumberFormat('#,###').format(savings));
    _addGridRow(grid, 'Savings Rate', '${savingsRate.toStringAsFixed(1)}%');
    
    grid.draw(page: page, bounds: const Rect.fromLTWH(40, 80, 250, 200));
  }
  
  void _addAssetAllocationPage(PdfDocument document, List<Asset> assets) {
    final page = document.pages.add();
    final graphics = page.graphics;
    
    _drawSectionHeader(graphics, 'Asset Allocation', 40);
    
    // Group assets by type
    final assetsByType = <String, double>{};
    for (final asset in assets) {
      assetsByType[asset.type] = (assetsByType[asset.type] ?? 0) + asset.currentValue;
    }
    
    final grid = PdfGrid();
    grid.columns.add(count: 3);
    grid.headers.add(1);
    
    final headerRow = grid.headers[0];
    headerRow.cells[0].value = 'Asset Type';
    headerRow.cells[1].value = 'Value (AED)';
    headerRow.cells[2].value = '% of Portfolio';
    _styleHeaderRow(headerRow);
    
    final total = assetsByType.values.fold(0.0, (sum, v) => sum + v);
    
    for (final entry in assetsByType.entries) {
      final percent = total > 0 ? (entry.value / total * 100) : 0;
      _addGridRow(grid, _formatAssetType(entry.key), NumberFormat('#,###').format(entry.value), '${percent.toStringAsFixed(1)}%');
    }
    
    grid.draw(page: page, bounds: const Rect.fromLTWH(40, 80, 350, 300));
  }
  
  void _addGoalsSummaryPage(PdfDocument document, List<Goal> goals) {
    final page = document.pages.add();
    final graphics = page.graphics;
    
    _drawSectionHeader(graphics, 'Financial Goals', 40);
    
    if (goals.isEmpty) {
      graphics.drawString(
        'No financial goals set yet.',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(40, 80, 300, 20),
      );
      return;
    }
    
    final grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);
    
    final headerRow = grid.headers[0];
    headerRow.cells[0].value = 'Goal';
    headerRow.cells[1].value = 'Target';
    headerRow.cells[2].value = 'Target Date';
    headerRow.cells[3].value = 'Status';
    _styleHeaderRow(headerRow);
    
    for (final goal in goals) {
      final row = grid.rows.add();
      row.cells[0].value = goal.name;
      row.cells[1].value = NumberFormat.currency(symbol: '', decimalDigits: 0).format(goal.targetAmount);
      row.cells[2].value = DateFormat('MMM yyyy').format(goal.targetDate);
      row.cells[3].value = goal.status.toUpperCase();
    }
    
    grid.draw(page: page, bounds: const Rect.fromLTWH(40, 80, 400, 400));
  }
  
  void _addAnnualSummaryPage(PdfDocument document, int year, double income, double expenses, double netWorth) {
    final page = document.pages.add();
    final graphics = page.graphics;
    
    _drawSectionHeader(graphics, 'Annual Summary - $year', 40);
    
    final grid = PdfGrid();
    grid.columns.add(count: 2);
    grid.headers.add(1);
    
    final headerRow = grid.headers[0];
    headerRow.cells[0].value = 'Metric';
    headerRow.cells[1].value = 'Amount (AED)';
    _styleHeaderRow(headerRow);
    
    _addGridRow(grid, 'Total Annual Income', NumberFormat('#,###').format(income));
    _addGridRow(grid, 'Total Annual Expenses', NumberFormat('#,###').format(expenses));
    _addGridRow(grid, 'Annual Savings', NumberFormat('#,###').format(income - expenses));
    _addGridRow(grid, 'Net Worth (Year End)', NumberFormat('#,###').format(netWorth));
    
    grid.draw(page: page, bounds: const Rect.fromLTWH(40, 80, 300, 200));
  }
  
  void _drawSectionHeader(PdfGraphics graphics, String title, double y) {
    graphics.drawString(
      title,
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
      brush: PdfSolidBrush(PdfColor(10, 22, 40)),
      bounds: Rect.fromLTWH(40, y, 400, 25),
    );
    graphics.drawLine(
      PdfPen(PdfColor(207, 181, 59), width: 2),
      Offset(40, y + 25),
      Offset(200, y + 25),
    );
  }
  
  void _styleHeaderRow(PdfGridRow row) {
    row.style = PdfGridRowStyle(
      backgroundBrush: PdfSolidBrush(PdfColor(10, 22, 40)),
      textBrush: PdfSolidBrush(PdfColor(255, 255, 255)),
      font: PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
    );
  }
  
  void _addGridRow(PdfGrid grid, String col1, String col2, [String? col3]) {
    final row = grid.rows.add();
    row.cells[0].value = col1;
    row.cells[1].value = col2;
    if (col3 != null && grid.columns.count > 2) {
      row.cells[2].value = col3;
    }
  }
  
  String _formatAssetType(String type) {
    switch (type) {
      case 'real_estate': return 'Real Estate';
      case 'stocks': return 'Stocks';
      case 'mutual_funds': return 'Mutual Funds';
      case 'fixed_deposit': return 'Fixed Deposits';
      case 'gold': return 'Gold';
      case 'crypto': return 'Crypto';
      case 'ppf': return 'PPF';
      case 'nps': return 'NPS';
      default: return type.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
    }
  }
}
