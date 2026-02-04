import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../repositories/app_repository.dart';
import 'imap_service.dart';
import 'pdf_service.dart';
import 'pdf_extraction_service.dart';
import 'gemini_service.dart';
import 'notification_service.dart';
import 'secure_vault.dart';
import 'exit_rules_service.dart';

/// Background Service for automated statement processing and monitoring
class BackgroundService {
  static const String statementProcessingTask = 'statement_processing';
  static const String budgetCheckTask = 'budget_check';
  static const String sipReminderTask = 'sip_reminder';
  static const String exitRulesCheckTask = 'exit_rules_check';
  
  /// Initialize WorkManager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }
  
  /// Register periodic tasks
  static Future<void> registerTasks() async {
    // Statement processing - check every 6 hours
    await Workmanager().registerPeriodicTask(
      statementProcessingTask,
      statementProcessingTask,
      frequency: const Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
    
    // Budget check - check daily
    await Workmanager().registerPeriodicTask(
      budgetCheckTask,
      budgetCheckTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        requiresBatteryNotLow: true,
      ),
    );
    
    // SIP reminder - check daily at startup
    await Workmanager().registerPeriodicTask(
      sipReminderTask,
      sipReminderTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        requiresBatteryNotLow: true,
      ),
    );
    
    // Exit Rules check - check daily
    await Workmanager().registerPeriodicTask(
      exitRulesCheckTask,
      exitRulesCheckTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        requiresBatteryNotLow: true,
      ),
    );
  }
  
  /// Cancel all tasks
  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
  }
  
  /// Execute a task immediately
  static Future<void> executeNow(String taskName) async {
    await Workmanager().registerOneOffTask(
      '${taskName}_immediate',
      taskName,
    );
  }
}

/// Background task callback dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case BackgroundService.statementProcessingTask:
          await _processStatementQueue();
          break;
        case BackgroundService.budgetCheckTask:
          await _checkBudgetAlerts();
          break;
        case BackgroundService.sipReminderTask:
          await _checkSipReminders();
          break;
        case BackgroundService.exitRulesCheckTask:
          await _checkExitRules();
          break;
        default:
          print('Unknown task: $task');
      }
      return true;
    } catch (e) {
      print('Background task error: $e');
      return false;
    }
  });
}

/// Process statement queue using IMAP (new implementation)
Future<void> _processStatementQueue() async {
  final db = AppDatabase();
  final repository = AppRepository.withDatabase(db);
  final imapService = ImapService();
  final notificationService = NotificationService();
  
  try {
    // Check if we have email credentials
    final hasCredentials = await SecureVault.hasEmailCredentials();
    if (!hasCredentials) {
      print('📧 No email credentials configured, skipping statement processing');
      return;
    }
    
    // Try to connect to IMAP
    final isConnected = await imapService.connect();
    if (!isConnected) {
      print('❌ Could not connect to IMAP server, skipping statement processing');
      return;
    }
    
    try {
      // Get pending items from statement queue
      final queueItems = await (db.select(db.statementQueue)
        ..where((q) => q.status.equals('pending'))
        ..orderBy([(q) => OrderingTerm.asc(q.queuedAt)])
        ..limit(5)).get();
      
      if (queueItems.isEmpty) {
        // Discover and add new emails if queue is empty
        await _fetchNewStatementEmails(imapService, db);
      }
      
      // Re-fetch queue after potential additions
      final itemsToProcess = await (db.select(db.statementQueue)
        ..where((q) => q.status.equals('pending'))
        ..orderBy([(q) => OrderingTerm.asc(q.queuedAt)])
        ..limit(5)).get();
      
      // Process queue items
      for (final item in itemsToProcess) {
        try {
          // Update status to processing
          await (db.update(db.statementQueue)
            ..where((q) => q.id.equals(item.id))).write(
            StatementQueueCompanion(status: const Value('processing')),
          );
          
          // Fetch full message by UID (emailId should contain UID)
          final uid = int.tryParse(item.emailId);
          if (uid != null) {
            final message = await imapService.fetchFullMessage(uid);
            if (message != null) {
              // Extract PDF attachments
              final pdfs = await imapService.extractPdfAttachments(message);
              int transactionCount = 0;
              
              for (final pdf in pdfs) {
                // Get password for this source
                final password = await SecureVault.getPdfPassword(item.sourceId ?? '');
                
                // Extract text from PDF
                final pdfText = await PdfExtractionService.extractText(
                  pdf, 
                  password: password,
                );
                
                if (pdfText != null && pdfText.isNotEmpty) {
                  // Parse transactions using Gemini
                  final transactions = await GeminiService.parseStatementText(pdfText);
                  
                  // Save transactions to database
                  for (final tx in transactions) {
                    await repository.insertTransaction(TransactionsCompanion.insert(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: DateTime.tryParse(tx['date'] ?? '') ?? DateTime.now(),
                      amount: (tx['amount'] as num?)?.toDouble() ?? 0,
                      currencyCode: tx['currency'] ?? 'AED',
                      description: tx['description'] ?? '',
                      categoryId: Value(tx['category_hint']),
                      type: tx['type'] ?? 'expense',
                      merchantName: Value(tx['merchant']),
                    ));
                    transactionCount++;
                  }
                }
              }
              
              // Mark as completed
              await (db.update(db.statementQueue)
                ..where((q) => q.id.equals(item.id))).write(
                StatementQueueCompanion(
                  status: const Value('completed'),
                  processedAt: Value(DateTime.now()),
                ),
              );
              
              await notificationService.showStatementProcessed(
                bankName: item.sourceId ?? 'Unknown Bank',
                transactionCount: transactionCount,
              );
            }
          }
          
        } catch (e) {
          // Update queue status to failed
          await (db.update(db.statementQueue)
            ..where((q) => q.id.equals(item.id))).write(
            StatementQueueCompanion(
              status: const Value('failed'),
              errorMessage: Value(e.toString()),
            ),
          );
          
          await notificationService.showStatementError(
            bankName: item.sourceId ?? 'Unknown Bank',
            error: e.toString(),
          );
        }
      }
    } finally {
      await imapService.disconnect();
    }
  } finally {
    await db.close();
  }
}

/// Fetch new statement emails using IMAP and add to queue
Future<void> _fetchNewStatementEmails(ImapService imapService, AppDatabase db) async {
  try {
    // Discover statement senders
    final sources = await imapService.discoverStatementSenders(daysBack: 90);
    
    // Get list of sender emails
    final senderEmails = sources.map((s) => s.senderEmail).toList();
    if (senderEmails.isEmpty) {
      print('📭 No statement senders discovered');
      return;
    }
    
    // Search for emails from discovered senders
    final headers = await imapService.searchStatementEmails(senderEmails, daysBack: 30);
    
    // Add to queue
    for (final header in headers) {
      final uid = header.uid?.toString() ?? '';
      if (uid.isEmpty) continue;
      
      // Check if already in queue
      final existing = await (db.select(db.statementQueue)
        ..where((q) => q.emailId.equals(uid))).getSingleOrNull();
      
      if (existing == null) {
        // Detect bank name from sender
        final fromAddress = header.from?.firstOrNull?.email ?? '';
        String bankName = _detectBankName(fromAddress);
        
        await db.into(db.statementQueue).insert(StatementQueueCompanion.insert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          emailId: uid,
          sourceId: Value(bankName),
          subject: header.decodeSubject() ?? 'Statement',
          emailDate: header.decodeDate() ?? DateTime.now(),
        ));
        print('📥 Queued statement from $bankName');
      }
    }
  } catch (e) {
    print('Error fetching statement emails: $e');
  }
}

/// Detect bank name from email address
String _detectBankName(String email) {
  final domain = email.split('@').lastOrNull?.toLowerCase() ?? '';
  
  final bankMap = {
    'emirates': 'Emirates NBD',
    'enbd': 'Emirates NBD',
    'adcb': 'ADCB',
    'mashreq': 'Mashreq',
    'fab': 'First Abu Dhabi Bank',
    'dib': 'Dubai Islamic Bank',
    'cbd': 'Commercial Bank of Dubai',
    'rakbank': 'RAK Bank',
    'hsbc': 'HSBC',
    'citi': 'Citibank',
    'sc.com': 'Standard Chartered',
    'standardchartered': 'Standard Chartered',
    'hdfc': 'HDFC Bank',
    'icici': 'ICICI Bank',
    'sbi': 'State Bank of India',
    'axis': 'Axis Bank',
    'kotak': 'Kotak Mahindra',
  };
  
  for (final entry in bankMap.entries) {
    if (domain.contains(entry.key)) {
      return entry.value;
    }
  }
  
  return 'Unknown Bank';
}

/// Check budget alerts
Future<void> _checkBudgetAlerts() async {
  final db = AppDatabase();
  final repository = AppRepository.withDatabase(db);
  final notificationService = NotificationService();
  
  try {
    final alerts = await repository.checkBudgetThresholds();
    
    for (final alert in alerts) {
      await notificationService.showBudgetWarning(
        categoryName: alert['categoryName'] as String,
        percentUsed: (alert['percentUsed'] as double).round(),
      );
    }
  } finally {
    await db.close();
  }
}

/// Check SIP reminders
Future<void> _checkSipReminders() async {
  final db = AppDatabase();
  final notificationService = NotificationService();
  
  try {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    
    // Get SIPs due tomorrow
    final sips = await (db.select(db.sipRecords)
      ..where((s) => s.isActive.equals(true))
      ..where((s) => s.dayOfMonth.equals(tomorrow.day))).get();
    
    for (final sip in sips) {
      await notificationService.showSipReminderDue(
        sipName: sip.name,
        amount: sip.amount,
        currency: sip.currencyCode,
      );
    }
    
    // Also check EMI due dates
    final liabilities = await (db.select(db.liabilities)
      ..where((l) => l.isActive.equals(true))).get();
    
    for (final liability in liabilities) {
      // Assume EMI due on the same day of month as start date
      if (liability.startDate.day == tomorrow.day + 3) { // 3 days notice
        await notificationService.showEmiDueReminder(
          loanName: liability.name,
          amount: liability.emi,
          currency: liability.currencyCode,
        );
      }
    }
  } finally {
    await db.close();
  }
}

/// Check Exit Rules for real estate properties
Future<void> _checkExitRules() async {
  final db = AppDatabase();
  final repository = AppRepository.withDatabase(db);
  final notificationService = NotificationService();
  
  try {
    final exitRulesService = ExitRulesService(repository);
    final alerts = await exitRulesService.evaluateAllRules();
    
    for (final alert in alerts) {
      await notificationService.showExitRuleTriggered(
        propertyName: alert.assetName,
        message: alert.message,
      );
    }
    
    if (alerts.isNotEmpty) {
      print('🏠 ${alerts.length} exit rule(s) triggered');
    }
  } catch (e) {
    print('Error checking exit rules: $e');
  } finally {
    await db.close();
  }
}
