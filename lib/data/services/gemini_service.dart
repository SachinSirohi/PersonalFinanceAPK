import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_vault.dart';

/// Service for interacting with Google Gemini API
class GeminiService {
  static GenerativeModel? _model;  // For structured JSON responses (parsing)
  static GenerativeModel? _chatModel;  // For natural language chat
  static String? _cachedModelName; // Cache the working model
  static String? _lastError; // Store last error for diagnostics
  
  // VERIFIED models only (guaranteed to exist as of Feb 2026)
  static const _hardcodedModelFallback = [
    'gemini-1.5-flash-latest',   // ✅ Primary: Always available
    'gemini-1.5-flash',          // ✅ Fallback 1: Stable
    'gemini-1.5-pro-latest',     // ✅ Fallback 2: Pro tier
    'gemini-pro',                // ✅ Fallback 3: Legacy
  ];
  
  /// Fetch available models from Google API dynamically
  static Future<List<String>> _fetchGeminiModels(String apiKey) async {
    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode != 200) {
        print('⚠️ Failed to fetch models: ${response.statusCode} ${response.body}');
        return [];
      }
      
      final data = json.decode(response.body);
      final List<dynamic> models = data['models'] ?? [];
      
      // Filter for Gemini models that support generateContent
      final validModels = models.where((m) {
        final name = m['name'].toString();
        final methods = List<String>.from(m['supportedGenerationMethods'] ?? []);
        return name.contains('gemini') && methods.contains('generateContent');
      }).map((m) => m['name'].toString().replaceFirst('models/', '')).toList();
      
      // Sort priority: Flash > Pro > Others
      validModels.sort((a, b) {
        // Prioritize "flash"
        final aFlash = a.contains('flash');
        final bFlash = b.contains('flash');
        if (aFlash && !bFlash) return -1;
        if (!aFlash && bFlash) return 1;
        
        // Prioritize "latest"
        final aLatest = a.contains('latest');
        final bLatest = b.contains('latest');
        if (aLatest && !bLatest) return -1;
        if (!aLatest && bLatest) return 1;
        
        // Prioritize "1.5" over others
        final a15 = a.contains('1.5');
        final b15 = b.contains('1.5');
        if (a15 && !b15) return -1;
        if (!a15 && b15) return 1;
        
        return 0;
      });
      
      print('🌐 Discovered ${validModels.length} models via API: $validModels');
      return validModels;
    } catch (e) {
      print('⚠️ Error fetching models: $e');
      return [];
    }
  }
  
  /// Try models in order until one works, then cache it
  static Future<String?> _findWorkingModel(String apiKey) async {
    // Return cached model if available
    if (_cachedModelName != null) {
      return _cachedModelName;
    }
    
    // 1. Try to fetch verified models from API first
    final apiModels = await _fetchGeminiModels(apiKey);
    
    // 2. Combine with hardcoded fallback (deduplicated)
    final modelsToTry = [
      ...apiModels,
      ..._hardcodedModelFallback
    ].toSet().toList(); // Remove duplicates
    
    // 3. Try each model in priority order
    for (final modelName in modelsToTry) {
      try {
        print('🔄 Trying model: $modelName...');
        final testModel = GenerativeModel(model: modelName, apiKey: apiKey);
        final response = await testModel.generateContent([
          Content.text('Hi'),
        ]).timeout(const Duration(seconds: 15)); // ✅ Increased from 5s to 15s
        
        if (response.text != null && response.text!.isNotEmpty) {
          _cachedModelName = modelName;
          print('✅ SUCCESS: Connected to $modelName');
          return modelName;
        }
      } catch (e) {
        // Enhanced error categorization
        final errorMsg = e.toString().toLowerCase();
        String specificError;
        
        if (errorMsg.contains('timeout') || errorMsg.contains('socket')) {
          specificError = 'Network timeout';
        } else if (errorMsg.contains('api') || errorMsg.contains('invalid') || errorMsg.contains('401') || errorMsg.contains('403')) {
          specificError = 'Invalid API key';
        } else if (errorMsg.contains('not found') || errorMsg.contains('404')) {
          specificError = 'Model not available';
        } else if (errorMsg.contains('quota') || errorMsg.contains('429')) {
          specificError = 'Rate limit exceeded';
        } else {
          specificError = errorMsg.length > 100 ? errorMsg.substring(0, 100) : errorMsg;
        }
        
        print('❌ $modelName failed: $specificError');
        _lastError = specificError; // Store for final error message
        continue; // Try next model
      }
    }
    
    return null; // All models failed
  }
  
  /// Initialize the Gemini model with user's API key
  static Future<bool> initialize() async {
    final apiKey = await SecureVault.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      return false;
    }
    
    final modelName = await _findWorkingModel(apiKey);
    if (modelName == null) {
      return false; // No working model found
    }
    
    // Model for structured JSON responses (statement parsing)
    _model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.1, // Low temperature for consistent parsing
      ),
    );
    
    // Separate model for natural language chat (no JSON mode)
    _chatModel = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7, // Higher temp for conversational responses
        topP: 0.9,
        topK: 40,
      ),
    );
    
    return true;
  }
  
  /// Check if the API key is valid by making a test request
  /// Check if the API key is valid. Returns null if valid, or error message if invalid.
  static Future<String?> validateApiKey(String apiKey) async {
    if (apiKey.isEmpty || apiKey.length < 10) {
      return 'Key is too short';
    }
    
    // Try to find a working model
    print('🔍 Validating API key...');
    final modelName = await _findWorkingModel(apiKey);
    if (modelName == null) {
      return 'Failed: ${_lastError ?? "Unknown error"}\n\nCheck: API key, internet, firewall';
    }
    
    return null; // Success - model found and working
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
    // Use CHAT model (plain text, not JSON)
    if (_chatModel == null) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Gemini API not configured. Please add your API key in Settings.');
      }
    }
    
    final prompt = '''
You are WealthOrbit AI, a helpful personal finance assistant for NRI individuals managing finances in UAE and India.

USER'S FINANCIAL CONTEXT:
$contextData

USER'S QUESTION:
$question

Provide a helpful, actionable answer. Use the user's financial context when relevant.
Format your response with markdown (bold text with **, bullet points with •) for better readability.
Keep responses concise but comprehensive. Be friendly and professional.
''';

    try {
      // Use _chatModel instead of _model (no JSON mode!)
      final response = await _chatModel!.generateContent([Content.text(prompt)]);
      return response.text ?? 'I could not process your request. Please try again.';
    } catch (e) {
      print('AI Chat error: $e');
      throw Exception('Failed to get response: ${e.toString()}');
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
