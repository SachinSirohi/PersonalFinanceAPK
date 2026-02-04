import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure vault for storing sensitive data (API keys, PDF passwords)
class SecureVault {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Keys
  static const _geminiApiKey = 'gemini_api_key';
  static const _baseCurrency = 'base_currency';
  static const _onboardingComplete = 'onboarding_complete';

  // ═══════════════════════════════════════════════════════════════════════════
  // GEMINI API KEY
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Store the user's Gemini API key
  static Future<void> setGeminiApiKey(String key) async {
    await _storage.write(key: _geminiApiKey, value: key);
  }
  
  /// Get the stored Gemini API key
  static Future<String?> getGeminiApiKey() async {
    return await _storage.read(key: _geminiApiKey);
  }
  
  /// Check if Gemini API key is configured
  static Future<bool> hasGeminiApiKey() async {
    final key = await _storage.read(key: _geminiApiKey);
    return key != null && key.isNotEmpty;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PDF PASSWORDS (Per Bank)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Store a PDF password for a specific bank/sender
  static Future<void> setPdfPassword(String sourceId, String password) async {
    await _storage.write(key: 'pdf_pwd_$sourceId', value: password);
  }
  
  /// Get PDF password for a specific bank/sender
  static Future<String?> getPdfPassword(String sourceId) async {
    return await _storage.read(key: 'pdf_pwd_$sourceId');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // USER PREFERENCES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Set base currency
  static Future<void> setBaseCurrency(String currencyCode) async {
    await _storage.write(key: _baseCurrency, value: currencyCode);
  }
  
  /// Get base currency (default: AED)
  static Future<String> getBaseCurrency() async {
    final currency = await _storage.read(key: _baseCurrency);
    return currency ?? 'AED';
  }
  
  /// Set onboarding complete flag
  static Future<void> setOnboardingComplete(bool complete) async {
    await _storage.write(key: _onboardingComplete, value: complete.toString());
  }
  
  // Check onboarding completion
  static Future<bool> isOnboardingComplete() async {
    final currency = await _storage.read(key: _baseCurrency);
    final apiKey = await _storage.read(key: _geminiApiKey);
    return currency != null && apiKey != null;
  }
  
  // Email configuration storage (IMAP)
  static Future<void> setEmailCredentials(String email, String appPassword, String provider) async {
    await _storage.write(key: 'email_address', value: email);
    await _storage.write(key: 'email_app_password', value: appPassword);
    await _storage.write(key: 'email_provider', value: provider);
  }
  
  static Future<Map<String, String?>> getEmailCredentials() async {
    return {
      'email': await _storage.read(key: 'email_address'),
      'password': await _storage.read(key: 'email_app_password'),
      'provider': await _storage.read(key: 'email_provider'),
    };
  }
  
  static Future<void> clearEmailCredentials() async {
    await _storage.delete(key: 'email_address');
    await _storage.delete(key: 'email_app_password');
    await _storage.delete(key: 'email_provider');
  }
  
  // Individual getters for IMAP service
  static Future<String?> getGmailEmail() async {
    return await _storage.read(key: 'email_address');
  }
  
  static Future<String?> getGmailPassword() async {
    return await _storage.read(key: 'email_app_password');
  }
  
  static Future<bool> hasEmailCredentials() async {
    final email = await _storage.read(key: 'email_address');
    final password = await _storage.read(key: 'email_app_password');
    return email != null && email.isNotEmpty && password != null && password.isNotEmpty;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Clear all stored data (for logout/reset)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
