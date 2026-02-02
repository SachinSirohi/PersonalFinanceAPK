import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'secure_vault.dart';

/// Service for interacting with Google Gemini API
class GeminiService {
  static GenerativeModel? _model;
  
  /// Initialize the Gemini model with user's API key
  static Future<bool> initialize() async {
    final apiKey = await SecureVault.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      return false;
    }
    
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.1, // Low temperature for consistent parsing
      ),
    );
    return true;
  }
  
  /// Check if the API key is valid by making a test request
  static Future<bool> validateApiKey(String apiKey) async {
    if (apiKey.isEmpty || apiKey.length < 10) {
      return false;
    }
    
    try {
      final testModel = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      final response = await testModel.generateContent([
        Content.text('Hello'),
      ]);
      // If we get any response without error, the key is valid
      return response.text != null && response.text!.isNotEmpty;
    } catch (e) {
      // Log error for debugging but return false
      print('API Key validation error: $e');
      return false;
    }
  }
  
  /// Parse bank statement text and extract transactions
  static Future<List<Map<String, dynamic>>> parseStatementText(String statementText) async {
    if (_model == null) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Gemini API not configured. Please add your API key in Settings.');
      }
    }
    
    final prompt = '''
You are a financial data extraction assistant. Parse the following bank statement text and extract ALL transactions.

Return a JSON array where each transaction has this EXACT structure:
{
  "date": "YYYY-MM-DD",
  "description": "Transaction description",
  "merchant": "Merchant name if identifiable",
  "amount": 123.45,
  "currency": "AED",
  "type": "expense" or "income",
  "category_hint": "One of: housing, utilities, groceries, transport, insurance, dining, leisure, travel, shopping, subscriptions, investments, savings, debt, other"
}

Rules:
1. Debits/Withdrawals/Purchases = "expense" with positive amount
2. Credits/Deposits/Refunds = "income" with positive amount
3. Detect currency from statement header or assume the most common one
4. category_hint should be your best guess based on merchant/description

STATEMENT TEXT:
$statementText
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      final jsonText = response.text ?? '[]';
      
      // Parse the JSON response
      final List<dynamic> transactions = json.decode(jsonText);
      return transactions.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to parse statement: $e');
    }
  }
  
  /// Natural language query about finances
  static Future<String> askQuestion(String question, String contextData) async {
    if (_model == null) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Gemini API not configured.');
      }
    }
    
    final prompt = '''
You are a helpful personal finance assistant named WealthOrbit AI. 
Answer the user's question based on their financial data.

USER'S FINANCIAL DATA:
$contextData

USER'S QUESTION:
$question

Provide a concise, helpful answer. If you need to show numbers, format them nicely with currency symbols.
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'I could not process your request.';
    } catch (e) {
      return 'Error: $e';
    }
  }
  
  /// Detect anomalies in transactions
  static Future<List<String>> detectAnomalies(List<Map<String, dynamic>> recentTransactions) async {
    if (_model == null) {
      final initialized = await initialize();
      if (!initialized) return [];
    }
    
    final transactionsJson = json.encode(recentTransactions);
    
    final prompt = '''
Analyze these recent transactions for anomalies or notable patterns:

$transactionsJson

Return a JSON array of warning strings. Examples:
- "Subscription increase: Netflix went up by \$2"
- "Unusual spending: \$500 at Unknown Merchant"
- "Duplicate charge: Two transactions for same amount at same merchant"

Only return genuine concerns. Return empty array [] if nothing notable.
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      final jsonText = response.text ?? '[]';
      final List<dynamic> anomalies = json.decode(jsonText);
      return anomalies.cast<String>();
    } catch (e) {
      return [];
    }
  }
}
