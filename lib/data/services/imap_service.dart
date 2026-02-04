import 'dart:typed_data';
import 'package:enough_mail/enough_mail.dart';
import '../models/discovered_source.dart';
import 'secure_vault.dart';

/// Service for interacting with IMAP servers to fetch bank statements
class ImapService {
  ImapClient? _client;
  bool _isConnecting = false;
  
  // Cache of fetched message headers (UID, ENVELOPE only)
  List<MimeMessage> _cachedHeaders = [];
  // Cache of full messages with body
  Map<int, MimeMessage> _fullMessageCache = {};

  /// Connect to IMAP server using stored credentials
  Future<bool> connect({String? host, int? port}) async {
    if (_client != null && _client!.isConnected) return true;
    if (_isConnecting) return false;

    _isConnecting = true;
    try {
      final email = await SecureVault.getGmailEmail();
      final password = await SecureVault.getGmailPassword();
      
      if (email == null || password == null) {
        throw Exception('Email credentials not found');
      }

      final finalHost = host ?? _detectHost(email);
      final finalPort = port ?? 993;

      print('🔌 Connecting to IMAP: $finalHost:$finalPort for $email');
      
      _client = ImapClient(isLogEnabled: false);
      
      await _client!.connectToServer(finalHost, finalPort, isSecure: true);
      await _client!.login(email, password);
      
      // Select inbox immediately after login
      final mailboxes = await _client!.listMailboxes();
      final inbox = mailboxes.firstWhere(
        (m) => m.name.toLowerCase() == 'inbox', 
        orElse: () => mailboxes.first
      );
      await _client!.selectMailbox(inbox);
      
      print('✅ IMAP Connected successfully');
      return true;
    } catch (e) {
      print('❌ IMAP Connection failed: $e');
      _client = null;
      return false;
    } finally {
      _isConnecting = false;
    }
  }

  /// Disconnect from IMAP server
  Future<void> disconnect() async {
    _cachedHeaders = [];
    _fullMessageCache = {};
    if (_client != null && _client!.isConnected) {
      try {
        await _client!.logout();
      } catch (e) {
        // Ignore logout errors
      } finally {
        _client = null;
      }
    }
  }

  /// Check connection status
  bool get isConnected => _client != null && _client!.isConnected;

  /// Discover statement senders from inbox using optimized search
  Future<List<DiscoveredSource>> discoverStatementSenders({int daysBack = 365}) async {
    if (!isConnected) throw Exception('Not connected to IMAP');

    try {
      print('🔍 Searching for statement emails...');
      
      List<MimeMessage> messages = [];
      
      // STRATEGY 1: Manual Sequence (Preferred for Control)
      try {
        print('Trying Strategy 1: Manual Sequence...');
        final mailboxes = await _client!.listMailboxes();
        final inbox = mailboxes.firstWhere(
          (m) => m.name.toLowerCase() == 'inbox', 
          orElse: () => mailboxes.first
        );
        final selectedInbox = await _client!.selectMailbox(inbox);
        final totalMessages = selectedInbox.messagesExists;
        
        if (totalMessages > 0) {
          final start = totalMessages - 500 > 0 ? totalMessages - 500 + 1 : 1;
          final sequence = MessageSequence.fromRange(start, totalMessages);
          
          final fetchResult = await _client!.fetchMessages(sequence, 'UID ENVELOPE');
          if (fetchResult.messages.isNotEmpty) {
            messages = fetchResult.messages;
            print('✅ Strategy 1 success: Fetched ${messages.length} messages');
          }
        }
      } catch (e) {
        print('⚠️ Strategy 1 failed: $e');
      }

      // STRATEGY 2: Recent Messages with UID (Fallback)
      if (messages.isEmpty) {
        try {
          print('Trying Strategy 2: Recent Messages (UID ENVELOPE)...');
          final fetchResult = await _client!.fetchRecentMessages(
            messageCount: 500, 
            criteria: 'UID ENVELOPE'
          );
          if (fetchResult.messages.isNotEmpty) {
            messages = fetchResult.messages;
            print('✅ Strategy 2 success: Fetched ${messages.length} messages');
          }
        } catch (e) {
          print('⚠️ Strategy 2 failed: $e');
        }
      }

      // STRATEGY 3: Recent Messages (Original Working Method - No UID guarantee)
      if (messages.isEmpty) {
        try {
          print('Trying Strategy 3: Recent Messages (ENVELOPE only)...');
          final fetchResult = await _client!.fetchRecentMessages(
            messageCount: 500, 
            criteria: 'ENVELOPE'
          );
          messages = fetchResult.messages;
          print('✅ Strategy 3 success: Fetched ${messages.length} messages');
        } catch (e) {
          print('❌ All strategies failed: $e');
        }
      }

      _cachedHeaders = messages;
       
      // Log filter stats
      print('🔍 Filtering ${messages.length} messages for keywords...');
      
      // Group by sender, filtering for statement-related keywords
      final Map<String, List<MimeMessage>> senderMap = {};
      
      for (final msg in _cachedHeaders) {
        final fromList = msg.from;
        final from = (fromList != null && fromList.isNotEmpty ? fromList.first.email : '').toLowerCase();
        if (from.isEmpty) continue;
        
        // Check if subject contains statement-related keywords
        final subject = msg.decodeSubject()?.toLowerCase() ?? '';
        final isMatch = subject.contains('statement') || 
            subject.contains('e-statement') ||
            subject.contains('account summary') ||
            subject.contains('transaction') ||
            subject.contains('credit card') ||
            subject.contains('bank');
            
        if (isMatch) {
          senderMap.putIfAbsent(from, () => []);
          senderMap[from]!.add(msg);
        }
      }
      
      // Convert to DiscoveredSource list
      final sources = <DiscoveredSource>[];
      
      for (final entry in senderMap.entries) {
        final senderEmail = entry.key;
        final emails = entry.value;
        
        if (emails.isNotEmpty) {
          emails.sort((a, b) {
            final dateA = a.decodeDate() ?? DateTime(2000);
            final dateB = b.decodeDate() ?? DateTime(2000);
            return dateB.compareTo(dateA);
          });

          final firstUid = emails.first.uid?.toString() ?? '';
          
          sources.add(DiscoveredSource(
            senderEmail: senderEmail,
            senderName: DiscoveredSource.guessNameFromEmail(senderEmail),
            statementCount: emails.length,
            sampleMessageIds: [firstUid],
          ));
        }
      }
      
      sources.sort((a, b) => b.statementCount.compareTo(a.statementCount));
      
      print('✅ Found ${sources.length} statement sources');
      return sources;
      
    } catch (e) {
      print('❌ Discovery failed: $e');
      return [];
    }
  }

  /// Fetch a single email with full body for preview
  Future<MimeMessage?> fetchEmailForPreview(String senderEmail) async {
    if (!isConnected) throw Exception('Not connected to IMAP');
    
    try {
      final header = _cachedHeaders.where(
        (m) {
          final f = m.from;
          return (f != null && f.isNotEmpty ? f.first.email : '').toLowerCase() == senderEmail.toLowerCase();
        } 
      ).firstOrNull;
      
      if (header == null || header.uid == null) {
        print('⚠️ No cached header for $senderEmail');
        return null;
      }
      
      final uid = header.uid!;
      
      // Check if already fetched full message
      if (_fullMessageCache.containsKey(uid)) {
        return _fullMessageCache[uid];
      }
      
      // Fetch full message with body using BODY.PEEK[] to avoid marking as read
      print('📥 Fetching full message UID $uid...');
      final sequence = MessageSequence.fromId(uid, isUid: true);
      
      // KEY FIX: Use 'BODY.PEEK[]' to fetch the full message without marking as read
      final fetchResult = await _client!.fetchMessages(sequence, 'BODY.PEEK[]');
      
      if (fetchResult.messages.isNotEmpty) {
        final fullMessage = fetchResult.messages.first;
        _fullMessageCache[uid] = fullMessage;
        return fullMessage;
      }
      
      return null;
    } catch (e) {
      print('❌ Failed to fetch preview: $e');
      return null;
    }
  }

  /// Search for emails from specific senders
  Future<List<MimeMessage>> searchStatementEmails(List<String> senders, {int daysBack = 365}) async {
    if (!isConnected) throw Exception('Not connected to IMAP');

    final relevantMessages = _cachedHeaders.where((msg) {
      final f = msg.from;
      final from = (f != null && f.isNotEmpty ? f.first.email : '').toLowerCase();
      return senders.any((s) => from.contains(s.toLowerCase()));
    }).toList();
    
    // Sort by date descending (newest first)
    relevantMessages.sort((a, b) {
      final dateA = a.decodeDate() ?? DateTime(2000);
      final dateB = b.decodeDate() ?? DateTime(2000);
      return dateB.compareTo(dateA);
    });
    
    return relevantMessages;
  }

  /// Download a specific message with full body
  Future<MimeMessage?> fetchFullMessage(int uid) async {
    if (!isConnected) throw Exception('Not connected to IMAP');
    
    // Check cache first
    if (_fullMessageCache.containsKey(uid)) {
      return _fullMessageCache[uid];
    }
    
    try {
      final sequence = MessageSequence.fromId(uid, isUid: true);
      // KEY FIX: Use 'BODY.PEEK[]' instead of 'BODY[]'
      final fetchResult = await _client!.fetchMessages(sequence, 'BODY.PEEK[]');
      if (fetchResult.messages.isNotEmpty) {
        final msg = fetchResult.messages.first;
        _fullMessageCache[uid] = msg;
        return msg;
      }
    } catch (e) {
      print('❌ Failed to fetch message $uid: $e');
    }
    return null;
  }

  /// Extract PDF attachments from a message
  Future<List<Uint8List>> extractPdfAttachments(MimeMessage message) async {
    final pdfs = <Uint8List>[];
    
    try {
      // KEY FIX: Use findContentInfo() to get attachment info first
      final contentInfos = message.findContentInfo();
      
      for (final contentInfo in contentInfos) {
        final mediaType = contentInfo.mediaType;
        final filename = contentInfo.fileName?.toLowerCase() ?? '';
        
        // Check for PDF attachments
        if (mediaType?.sub == MediaSubtype.applicationPdf || 
            filename.endsWith('.pdf') ||
            (mediaType?.text.contains('pdf') ?? false)) {
          
          // Get the part fetch ID (e.g., "1.2", "2", etc.)
          final fetchId = contentInfo.fetchId;
          
          if (fetchId.isNotEmpty) {
            // Fetch the part content from server if not already available
            final part = await _fetchPart(message, fetchId);
            
            if (part != null) {
              final data = part.decodeContentBinary();
              if (data != null && data.isNotEmpty) {
                pdfs.add(Uint8List.fromList(data));
                print('📎 Found PDF: $filename (${data.length} bytes)');
              }
            }
          }
        }
      }
    } catch (e, stackTrace) {
      print('⚠️ Error extracting attachments: $e');
      print(stackTrace);
    }
    
    return pdfs;
  }

  /// Fetch a specific part of a message by its fetch ID
  Future<MimePart?> _fetchPart(MimeMessage message, String fetchId) async {
    try {
      // First check if the part is already available in the message
      final existingPart = message.getPart(fetchId);
      if (existingPart != null && existingPart.decodeContentBinary() != null) {
        return existingPart;
      }
      
      // If not available, fetch it from the server
      if (_client != null && _client!.isConnected && message.uid != null) {
        final sequence = MessageSequence.fromId(message.uid!, isUid: true);
        // Fetch specific part using BODY.PEEK[fetchId]
         final criteria = 'BODY.PEEK[$fetchId]';
        final fetchResult = await _client!.fetchMessages(sequence, criteria);
        
        if (fetchResult.messages.isNotEmpty) {
          // The fetched message should now contain the part data
          final fetchedMessage = fetchResult.messages.first;
          return fetchedMessage.getPart(fetchId);
        }
      }
    } catch (e) {
      print('⚠️ Error fetching part $fetchId: $e');
    }
    return null;
  }

  /// Get all attachment info from a message
  List<AttachmentInfo> getAttachmentInfo(MimeMessage message) {
    final attachments = <AttachmentInfo>[];
    
    try {
      final contentInfos = message.findContentInfo();
      
      for (final info in contentInfos) {
        final filename = info.fileName ?? 'unnamed';
        final size = info.size ?? 0;
        final mediaType = info.mediaType;
        
        attachments.add(AttachmentInfo(
          filename: filename,
          size: size,
          contentType: mediaType?.toString() ?? 'application/octet-stream',
          fetchId: info.fetchId,
        ));
      }
    } catch (e) {
      print('⚠️ Error getting attachment info: $e');
    }
    
    return attachments;
  }

  /// Get plain text body from email
  String getEmailBody(MimeMessage message) {
    try {
      // Try to get plain text first
      final plainText = message.decodeTextPlainPart();
      if (plainText != null && plainText.trim().isNotEmpty) {
        return plainText.trim();
      }
      
      // Fallback to HTML (strip tags)
      final html = message.decodeTextHtmlPart();
      if (html != null && html.isNotEmpty) {
        String text = _stripHtmlTags(html);
        
        if (text.isNotEmpty) {
          return text;
        }
      }
      
      return 'Email body is empty or could not be decoded.';
    } catch (e) {
      print('⚠️ Error decoding email body: $e');
      return 'Error loading email content: ${e.toString().split('\n').first}';
    }
  }

  /// Strip HTML tags to get plain text
  String _stripHtmlTags(String html) {
    return html
        .replaceAll(RegExp(r'<style[^>]*>.*?</style>', dotAll: true, caseSensitive: false), '')
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', dotAll: true, caseSensitive: false), '')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'&nbsp;', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'&amp;', caseSensitive: false), '&')
        .replaceAll(RegExp(r'&lt;', caseSensitive: false), '<')
        .replaceAll(RegExp(r'&gt;', caseSensitive: false), '>')
        .replaceAll(RegExp(r'&quot;', caseSensitive: false), '"')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Fetch the latest message for a specific sender
  Future<MimeMessage?> fetchLatestMessageForSender(String senderEmail) async {
    if (!isConnected) throw Exception('Not connected to IMAP');
    
    try {
      print('🎯 SEARCHING latest message for $senderEmail via server...');
      
      // 1. Precise Server-Side SEARCH
      final searchCriteria = 'FROM "$senderEmail"';
      final searchResult = await _client!.searchMessages(searchCriteria: searchCriteria);
      
      MimeMessage? latestMessage;
      
      if (searchResult.matchingSequence != null && searchResult.matchingSequence!.isNotEmpty) {
        // Fetch UIDs for the matching sequence to pick the latest one
        final uidFetch = await _client!.fetchMessages(searchResult.matchingSequence!, 'UID');
        final uids = uidFetch.messages.map((m) => m.uid ?? 0).where((id) => id != 0).toList();
        
        if (uids.isNotEmpty) {
          print('✅ Found ${uids.length} messages for sender. Picking latest UID...');
          uids.sort();
          final latestUid = uids.last;
        
          // Fetch full message with body
          final fullMessage = await fetchFullMessage(latestUid);
          if (fullMessage != null) {
            latestMessage = fullMessage;
          }
        }
      }
      
      if (latestMessage != null) {
        return latestMessage;
      }
      
      print('⚠️ Server SEARCH returned no results for $senderEmail. Falling back to Cache check...');

      // 2. Fallback: Search Cache (If Discovery Step 3 already found valid UIDs)
      final cached = _cachedHeaders.where(
        (m) {
          final f = m.from;
          return (f != null && f.isNotEmpty ? f.first.email : '').toLowerCase() == senderEmail.toLowerCase();
        }
      ).toList();
      
      if (cached.isNotEmpty) {
        cached.sort((a, b) {
            final dateA = a.decodeDate() ?? DateTime(2000);
            final dateB = b.decodeDate() ?? DateTime(2000);
            return dateB.compareTo(dateA);
        });
        
        // Find best cached message with a valid UID
        final bestCached = cached.firstWhere(
          (m) => m.uid != null && m.uid != 0, 
          orElse: () => cached.first
        );
        
        if (bestCached.uid != null && bestCached.uid != 0) {
          print('✅ Found valid UID in cache: ${bestCached.uid}');
          // Ensure we have the full message
          return await fetchFullMessage(bestCached.uid!);
        }
      }
      
      return null;
    } catch (e) {
      print('❌ Error fetching latest message: $e');
      return null;
    }
  }

  /// Helper to detect IMAP host from email domain
  String _detectHost(String email) {
    if (email.contains('@gmail.com')) return 'imap.gmail.com';
    if (email.contains('@outlook.com') || email.contains('@hotmail.com')) return 'outlook.office365.com';
    if (email.contains('@yahoo.com')) return 'imap.mail.yahoo.com';
    return 'imap.gmail.com';
  }
}

/// Helper class for attachment info
class AttachmentInfo {
  final String filename;
  final int size;
  final String contentType;
  final String? fetchId;

  AttachmentInfo({
    required this.filename,
    required this.size,
    required this.contentType,
    this.fetchId,
  });
}
