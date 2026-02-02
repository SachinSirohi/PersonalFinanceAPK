import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import '../database/database.dart';

/// Gmail Service for fetching bank statements via Gmail API
class GmailService {
  static const _scopes = [gmail.GmailApi.gmailReadonlyScope];
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  
  GoogleSignInAccount? _currentUser;
  gmail.GmailApi? _gmailApi;
  
  // Rate limiting - 6 seconds between API calls as per BRD
  DateTime? _lastApiCall;
  static const _apiCallDelay = Duration(seconds: 6);
  
  // Bank sender emails for statement detection
  static const Map<String, List<String>> _bankSenders = {
    // UAE Banks
    'Emirates NBD': ['no-reply@emiratesnbd.com', 'statements@emiratesnbd.com'],
    'ADCB': ['no-reply@adcb.com', 'statements@adcb.com'],
    'FAB': ['no-reply@bankfab.com', 'statements@fab.com'],
    'Mashreq': ['no-reply@mashreq.com', 'statements@mashreq.com'],
    'DIB': ['no-reply@dib.ae', 'statements@dib.ae'],
    'RAKBANK': ['no-reply@rakbank.ae', 'statements@rakbank.ae'],
    // India Banks
    'HDFC': ['alerts@hdfcbank.net', 'statements@hdfcbank.com'],
    'ICICI': ['statements@icicibank.com', 'no-reply@icicibank.com'],
    'SBI': ['statements@sbi.co.in', 'no-reply@sbi.co.in'],
    'Axis': ['statements@axisbank.com', 'no-reply@axisbank.com'],
    'Kotak': ['statements@kotak.com', 'no-reply@kotak.com'],
  };
  
  /// Check if user is signed in
  bool get isSignedIn => _currentUser != null;
  
  /// Get current user's email
  String? get userEmail => _currentUser?.email;
  
  /// Sign in with Google
  Future<bool> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser == null) return false;
      
      await _initializeGmailApi();
      return true;
    } catch (e) {
      print('Gmail sign-in error: $e');
      return false;
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _gmailApi = null;
    await _storage.delete(key: 'gmail_access_token');
  }
  
  /// Initialize Gmail API with authenticated client
  Future<void> _initializeGmailApi() async {
    if (_currentUser == null) return;
    
    final auth = await _currentUser!.authentication;
    final accessToken = auth.accessToken;
    
    if (accessToken == null) return;
    
    // Store token for background processing
    await _storage.write(key: 'gmail_access_token', value: accessToken);
    
    final authClient = AuthenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken('Bearer', accessToken, DateTime.now().add(const Duration(hours: 1)).toUtc()),
        null,
        _scopes,
      ),
    );
    
    _gmailApi = gmail.GmailApi(authClient);
  }
  
  /// Fetch bank statement emails (with rate limiting)
  Future<List<StatementEmail>> fetchBankStatementEmails({
    int maxResults = 20,
    DateTime? after,
  }) async {
    await _enforceRateLimit();
    
    if (_gmailApi == null) {
      await _initializeGmailApi();
      if (_gmailApi == null) throw Exception('Gmail API not initialized');
    }
    
    final results = <StatementEmail>[];
    
    // Build query for bank statement emails
    final query = _buildBankStatementQuery(after);
    
    try {
      final response = await _gmailApi!.users.messages.list(
        'me',
        q: query,
        maxResults: maxResults,
      );
      
      if (response.messages == null) return results;
      
      for (final message in response.messages!) {
        await _enforceRateLimit();
        
        final fullMessage = await _gmailApi!.users.messages.get(
          'me',
          message.id!,
        );
        
        final statementEmail = _parseGmailMessage(fullMessage);
        if (statementEmail != null) {
          results.add(statementEmail);
        }
      }
      
      return results;
    } catch (e) {
      print('Error fetching emails: $e');
      rethrow;
    }
  }
  
  /// Build Gmail query for bank statements
  String _buildBankStatementQuery(DateTime? after) {
    final parts = <String>[];
    
    // From any known bank sender
    final fromParts = <String>[];
    for (final senders in _bankSenders.values) {
      for (final sender in senders) {
        fromParts.add('from:$sender');
      }
    }
    parts.add('(${fromParts.join(' OR ')})');
    
    // Has attachment (PDF)
    parts.add('has:attachment');
    parts.add('filename:pdf');
    
    // Subject contains statement-related keywords
    parts.add('(subject:statement OR subject:estatement OR subject:account statement)');
    
    // Date filter
    if (after != null) {
      parts.add('after:${after.year}/${after.month}/${after.day}');
    }
    
    return parts.join(' ');
  }
  
  /// Parse Gmail message into StatementEmail
  StatementEmail? _parseGmailMessage(gmail.Message message) {
    final headers = message.payload?.headers ?? [];
    
    String? from, subject;
    DateTime? date;
    
    for (final header in headers) {
      switch (header.name?.toLowerCase()) {
        case 'from':
          from = header.value;
          break;
        case 'subject':
          subject = header.value;
          break;
        case 'date':
          date = _parseEmailDate(header.value);
          break;
      }
    }
    
    if (from == null || subject == null) return null;
    
    // Detect bank from sender
    String? bankName;
    for (final entry in _bankSenders.entries) {
      for (final sender in entry.value) {
        if (from.toLowerCase().contains(sender.toLowerCase())) {
          bankName = entry.key;
          break;
        }
      }
      if (bankName != null) break;
    }
    
    // Find PDF attachments
    final attachments = <AttachmentInfo>[];
    _findAttachments(message.payload, message.id!, attachments);
    
    if (attachments.isEmpty) return null;
    
    return StatementEmail(
      messageId: message.id!,
      from: from,
      subject: subject,
      date: date ?? DateTime.now(),
      bankName: bankName,
      attachments: attachments,
    );
  }
  
  /// Find PDF attachments in message parts
  void _findAttachments(gmail.MessagePart? part, String messageId, List<AttachmentInfo> attachments) {
    if (part == null) return;
    
    if (part.filename != null && 
        part.filename!.isNotEmpty && 
        part.filename!.toLowerCase().endsWith('.pdf')) {
      attachments.add(AttachmentInfo(
        attachmentId: part.body?.attachmentId ?? '',
        filename: part.filename!,
        messageId: messageId,
        mimeType: part.mimeType ?? 'application/pdf',
      ));
    }
    
    // Recursively check parts
    if (part.parts != null) {
      for (final subPart in part.parts!) {
        _findAttachments(subPart, messageId, attachments);
      }
    }
  }
  
  /// Download PDF attachment
  Future<Uint8List> downloadAttachment(String messageId, String attachmentId) async {
    await _enforceRateLimit();
    
    if (_gmailApi == null) throw Exception('Gmail API not initialized');
    
    final attachment = await _gmailApi!.users.messages.attachments.get(
      'me',
      messageId,
      attachmentId,
    );
    
    if (attachment.data == null) throw Exception('Attachment data is null');
    
    // Gmail API returns base64url encoded data
    return base64Url.decode(attachment.data!);
  }
  
  /// Parse email date header
  DateTime? _parseEmailDate(String? dateStr) {
    if (dateStr == null) return null;
    
    try {
      // Simple parsing - may need more robust handling
      return DateTime.parse(dateStr);
    } catch (e) {
      // Try common email date formats
      try {
        // Remove timezone abbreviation
        final cleaned = dateStr.replaceAll(RegExp(r' \([A-Z]+\)$'), '');
        return DateTime.parse(cleaned);
      } catch (e) {
        return null;
      }
    }
  }
  
  /// Enforce rate limiting
  Future<void> _enforceRateLimit() async {
    if (_lastApiCall != null) {
      final elapsed = DateTime.now().difference(_lastApiCall!);
      if (elapsed < _apiCallDelay) {
        await Future.delayed(_apiCallDelay - elapsed);
      }
    }
    _lastApiCall = DateTime.now();
  }
  
  /// Try to restore session from stored credentials
  Future<bool> tryRestoreSession() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        _currentUser = account;
        await _initializeGmailApi();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

/// Custom authenticated HTTP client for Gmail API
class AuthenticatedClient extends http.BaseClient {
  final http.Client _client;
  final AccessCredentials _credentials;
  
  AuthenticatedClient(this._client, this._credentials);
  
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer ${_credentials.accessToken.data}';
    return _client.send(request);
  }
  
  @override
  void close() {
    _client.close();
  }
}

/// Parsed statement email data
class StatementEmail {
  final String messageId;
  final String from;
  final String subject;
  final DateTime date;
  final String? bankName;
  final List<AttachmentInfo> attachments;
  
  StatementEmail({
    required this.messageId,
    required this.from,
    required this.subject,
    required this.date,
    this.bankName,
    required this.attachments,
  });
}

/// PDF attachment information
class AttachmentInfo {
  final String attachmentId;
  final String filename;
  final String messageId;
  final String mimeType;
  
  AttachmentInfo({
    required this.attachmentId,
    required this.filename,
    required this.messageId,
    required this.mimeType,
  });
}
