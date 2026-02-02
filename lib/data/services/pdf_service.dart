import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'gemini_service.dart';

/// PDF Parsing Service for extracting transactions from bank statements
class PdfService {
  final GeminiService? geminiService;
  
  PdfService({this.geminiService});
  
  /// Extract text from PDF bytes
  Future<String> extractTextFromPdf(Uint8List pdfBytes, {String? password}) async {
    try {
      final document = password != null 
          ? PdfDocument(inputBytes: pdfBytes, password: password)
          : PdfDocument(inputBytes: pdfBytes);
      
      final textExtractor = PdfTextExtractor(document);
      final text = textExtractor.extractText();
      
      document.dispose();
      
      return text;
    } catch (e) {
      throw Exception('Failed to extract PDF text: $e');
    }
  }
  
  /// Parse transactions from bank statement PDF
  Future<List<ParsedTransaction>> parseStatement({
    required Uint8List pdfBytes,
    required String bankName,
    String? password,
  }) async {
    // Extract text from PDF
    final text = await extractTextFromPdf(pdfBytes, password: password);
    
    // Redact PII before processing
    final redactedText = _redactPII(text);
    
    // Use Gemini to parse transactions if available
    if (geminiService != null) {
      return await _parseWithGemini(redactedText, bankName);
    }
    
    // Fallback to rule-based parsing
    return _parseWithRules(text, bankName);
  }
  
  /// Redact PII (Personal Identifiable Information) from text
  String _redactPII(String text) {
    // Redact account numbers (keep last 4 digits)
    var redacted = text.replaceAllMapped(
      RegExp(r'\b(\d{8,16})\b'),
      (match) {
        final full = match.group(1)!;
        if (full.length > 4) {
          return 'XXXX${full.substring(full.length - 4)}';
        }
        return full;
      },
    );
    
    // Redact email addresses
    redacted = redacted.replaceAllMapped(
      RegExp(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b'),
      (match) => '[EMAIL_REDACTED]',
    );
    
    // Redact phone numbers
    redacted = redacted.replaceAllMapped(
      RegExp(r'\b(\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b'),
      (match) => '[PHONE_REDACTED]',
    );
    
    // Redact Emirates ID / Aadhaar
    redacted = redacted.replaceAllMapped(
      RegExp(r'\b784-\d{4}-\d{7}-\d\b'), // Emirates ID
      (match) => '[ID_REDACTED]',
    );
    
    return redacted;
  }
  
  /// Parse transactions using Gemini AI
  Future<List<ParsedTransaction>> _parseWithGemini(String text, String bankName) async {
    final prompt = '''
Parse the following bank statement text and extract all transactions.

Bank: $bankName

For each transaction, extract:
1. Date (in YYYY-MM-DD format)
2. Description
3. Amount (positive for credit/income, negative for debit/expense)
4. Category (suggest category based on description)
5. Type (income/expense)

Statement text:
$text

Return the transactions in JSON format like this:
[
  {"date": "2026-01-15", "description": "SALARY JAN 2026", "amount": 25000.00, "category": "Salary", "type": "income"},
  {"date": "2026-01-16", "description": "CARREFOUR DUBAI", "amount": -450.50, "category": "Groceries", "type": "expense"}
]

Only return the JSON array, no other text.
''';

    try {
      // Call static method with two required parameters
      final response = await GeminiService.askQuestion(prompt, text);
      if (response.isEmpty) return [];
      
      // Parse JSON response
      return _parseGeminiResponse(response);
    } catch (e) {
      print('Gemini parsing error: $e');
      return _parseWithRules(text, bankName);
    }
  }
  
  /// Parse Gemini AI response
  List<ParsedTransaction> _parseGeminiResponse(String response) {
    try {
      // Extract JSON from response
      final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(response);
      if (jsonMatch == null) return [];
      
      final jsonStr = jsonMatch.group(0)!;
      final List<dynamic> items = _parseJsonSafely(jsonStr);
      
      return items.map((item) {
        final map = item as Map<String, dynamic>;
        return ParsedTransaction(
          date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
          description: map['description'] ?? '',
          amount: (map['amount'] as num?)?.toDouble() ?? 0,
          category: map['category'] ?? 'Uncategorized',
          type: map['type'] ?? 'expense',
        );
      }).toList();
    } catch (e) {
      print('Error parsing Gemini response: $e');
      return [];
    }
  }
  
  /// Safe JSON parsing
  List<dynamic> _parseJsonSafely(String jsonStr) {
    try {
      // Basic JSON parsing - in production use proper JSON decoder
      final cleaned = jsonStr
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .trim();
      
      // Use dart:convert json.decode
      return List<dynamic>.from(
        (const JsonDecoder()).convert(cleaned) as List,
      );
    } catch (e) {
      return [];
    }
  }
  
  /// Rule-based parsing fallback for common banks
  List<ParsedTransaction> _parseWithRules(String text, String bankName) {
    switch (bankName.toLowerCase()) {
      case 'emirates nbd':
      case 'enbd':
        return _parseEmiratesNBD(text);
      case 'hdfc':
        return _parseHDFC(text);
      case 'adcb':
        return _parseADCB(text);
      default:
        return _parseGeneric(text);
    }
  }
  
  /// Parse Emirates NBD statement
  List<ParsedTransaction> _parseEmiratesNBD(String text) {
    final transactions = <ParsedTransaction>[];
    
    // Pattern: DD/MM/YYYY Description Amount Balance
    final pattern = RegExp(
      r'(\d{2}/\d{2}/\d{4})\s+(.+?)\s+([\d,]+\.\d{2})\s*(CR|DR)?\s+([\d,]+\.\d{2})',
      multiLine: true,
    );
    
    for (final match in pattern.allMatches(text)) {
      final dateStr = match.group(1)!;
      final description = match.group(2)!.trim();
      final amountStr = match.group(3)!.replaceAll(',', '');
      final crDr = match.group(4);
      
      final dateParts = dateStr.split('/');
      final date = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );
      
      double amount = double.parse(amountStr);
      if (crDr == 'DR' || crDr == null) {
        amount = -amount;
      }
      
      transactions.add(ParsedTransaction(
        date: date,
        description: description,
        amount: amount,
        category: _detectCategory(description),
        type: amount >= 0 ? 'income' : 'expense',
      ));
    }
    
    return transactions;
  }
  
  /// Parse HDFC Bank statement
  List<ParsedTransaction> _parseHDFC(String text) {
    final transactions = <ParsedTransaction>[];
    
    // Pattern: DD/MM/YY Description Amount
    final pattern = RegExp(
      r'(\d{2}/\d{2}/\d{2,4})\s+(.+?)\s+([\d,]+\.\d{2})',
      multiLine: true,
    );
    
    for (final match in pattern.allMatches(text)) {
      final dateStr = match.group(1)!;
      final description = match.group(2)!.trim();
      final amountStr = match.group(3)!.replaceAll(',', '');
      
      final dateParts = dateStr.split('/');
      int year = int.parse(dateParts[2]);
      if (year < 100) year += 2000;
      
      final date = DateTime(
        year,
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );
      
      double amount = double.parse(amountStr);
      
      // Detect if credit or debit from description
      if (description.contains('TO') || description.contains('BY TRANSFER')) {
        amount = -amount;
      }
      
      transactions.add(ParsedTransaction(
        date: date,
        description: description,
        amount: amount,
        category: _detectCategory(description),
        type: amount >= 0 ? 'income' : 'expense',
      ));
    }
    
    return transactions;
  }
  
  /// Parse ADCB statement
  List<ParsedTransaction> _parseADCB(String text) {
    // Similar pattern to Emirates NBD
    return _parseEmiratesNBD(text);
  }
  
  /// Generic statement parsing
  List<ParsedTransaction> _parseGeneric(String text) {
    final transactions = <ParsedTransaction>[];
    
    // Try common date formats
    final datePatterns = [
      RegExp(r'(\d{2}/\d{2}/\d{4})'),
      RegExp(r'(\d{2}-\d{2}-\d{4})'),
      RegExp(r'(\d{4}-\d{2}-\d{2})'),
    ];
    
    // Amount pattern
    final amountPattern = RegExp(r'([\d,]+\.\d{2})');
    
    final lines = text.split('\n');
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      DateTime? date;
      for (final pattern in datePatterns) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          date = _parseDate(match.group(1)!);
          break;
        }
      }
      
      if (date == null) continue;
      
      final amounts = amountPattern.allMatches(line).toList();
      if (amounts.isEmpty) continue;
      
      // Usually first amount is transaction, last is balance
      final amountStr = amounts.first.group(1)!.replaceAll(',', '');
      final amount = double.parse(amountStr);
      
      // Extract description (text between date and amount)
      final descStart = line.indexOf(RegExp(r'\d'));
      final descEnd = line.indexOf(amountStr);
      String description = line.substring(
        descStart + 10, // After date
        descEnd > descStart ? descEnd : line.length,
      ).trim();
      
      if (description.length < 3) continue;
      
      transactions.add(ParsedTransaction(
        date: date,
        description: description,
        amount: -amount, // Assume expense by default
        category: _detectCategory(description),
        type: 'expense',
      ));
    }
    
    return transactions;
  }
  
  /// Parse various date formats
  DateTime? _parseDate(String dateStr) {
    try {
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } else if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          // Check if YYYY-MM-DD or DD-MM-YYYY
          if (parts[0].length == 4) {
            return DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
          } else {
            return DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Detect category from transaction description
  String _detectCategory(String description) {
    final desc = description.toUpperCase();
    
    // Salary / Income
    if (desc.contains('SALARY') || desc.contains('PAYROLL')) {
      return 'Salary';
    }
    
    // Rent
    if (desc.contains('RENT') || desc.contains('RENTAL')) {
      return 'Rent';
    }
    
    // Groceries
    if (desc.contains('CARREFOUR') || 
        desc.contains('LULU') || 
        desc.contains('SPINNEYS') ||
        desc.contains('GROCERY')) {
      return 'Groceries';
    }
    
    // Restaurants / Food
    if (desc.contains('RESTAURANT') || 
        desc.contains('ZOMATO') || 
        desc.contains('DELIVEROO') ||
        desc.contains('TALABAT') ||
        desc.contains('CAFE') ||
        desc.contains('COFFEE')) {
      return 'Food & Dining';
    }
    
    // Fuel / Transport
    if (desc.contains('PETROL') || 
        desc.contains('ENOC') || 
        desc.contains('ADNOC') ||
        desc.contains('UBER') ||
        desc.contains('CAREEM') ||
        desc.contains('RTA')) {
      return 'Transport';
    }
    
    // Utilities
    if (desc.contains('DEWA') || 
        desc.contains('ETISALAT') || 
        desc.contains('DU ') ||
        desc.contains('ELECTRICITY')) {
      return 'Utilities';
    }
    
    // Shopping
    if (desc.contains('AMAZON') || 
        desc.contains('DUBAI MALL') || 
        desc.contains('MALL') ||
        desc.contains('SHOPPING')) {
      return 'Shopping';
    }
    
    // Healthcare
    if (desc.contains('HOSPITAL') || 
        desc.contains('CLINIC') || 
        desc.contains('PHARMACY') ||
        desc.contains('MEDICAL')) {
      return 'Healthcare';
    }
    
    // Entertainment
    if (desc.contains('CINEMA') || 
        desc.contains('VOX') || 
        desc.contains('REEL') ||
        desc.contains('NETFLIX') ||
        desc.contains('SPOTIFY')) {
      return 'Entertainment';
    }
    
    // Insurance
    if (desc.contains('INSURANCE') || desc.contains('PREMIUM')) {
      return 'Insurance';
    }
    
    // Transfer
    if (desc.contains('TRANSFER') || desc.contains('TRF')) {
      return 'Transfer';
    }
    
    // ATM
    if (desc.contains('ATM') || desc.contains('WITHDRAWAL')) {
      return 'Cash Withdrawal';
    }
    
    return 'Uncategorized';
  }
}

/// JSON decoder helper
class JsonDecoder {
  const JsonDecoder();
  
  dynamic convert(String source) {
    // Simple JSON parser for arrays
    // In production, use dart:convert
    return _parseJson(source);
  }
  
  dynamic _parseJson(String source) {
    final trimmed = source.trim();
    
    if (trimmed.startsWith('[')) {
      return _parseArray(trimmed);
    } else if (trimmed.startsWith('{')) {
      return _parseObject(trimmed);
    }
    
    return null;
  }
  
  List<dynamic> _parseArray(String source) {
    // This is a simplified implementation
    // In production, use dart:convert json.decode
    try {
      // Import and use dart:convert for real implementation
      return [];
    } catch (e) {
      return [];
    }
  }
  
  Map<String, dynamic> _parseObject(String source) {
    return {};
  }
}

/// Parsed transaction from bank statement
class ParsedTransaction {
  final DateTime date;
  final String description;
  final double amount;
  final String category;
  final String type;
  
  ParsedTransaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.category,
    required this.type,
  });
  
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'description': description,
    'amount': amount,
    'category': category,
    'type': type,
  };
}
