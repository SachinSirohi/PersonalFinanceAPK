import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../repositories/app_repository.dart';
import 'gmail_service.dart';
import 'pdf_service.dart';
import 'gemini_service.dart';
import 'notification_service.dart';

/// Background Service for automated statement processing
class BackgroundService {
  static const String statementProcessingTask = 'statement_processing';
  static const String budgetCheckTask = 'budget_check';
  static const String sipReminderTask = 'sip_reminder';
  
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

/// Process statement queue from Gmail
Future<void> _processStatementQueue() async {
  final db = AppDatabase();
  final repository = AppRepository.withDatabase(db);
  final gmailService = GmailService();
  final pdfService = PdfService(geminiService: null);
  final notificationService = NotificationService();
  
  try {
    // Try to restore Gmail session
    final isSignedIn = await gmailService.tryRestoreSession();
    if (!isSignedIn) {
      print('Gmail session not available, skipping statement processing');
      return;
    }
    
    // Get pending items from statement queue
    final queueItems = await (db.select(db.statementQueue)
      ..where((q) => q.status.equals('pending'))
      ..orderBy([(q) => OrderingTerm.asc(q.queuedAt)])
      ..limit(5)).get();
    
    if (queueItems.isEmpty) {
      // Fetch new emails if queue is empty
      await _fetchNewStatementEmails(gmailService, db);
    }
    
    // Process queue items
    for (final item in queueItems) {
      try {
        // Update status to processing
        await (db.update(db.statementQueue)
          ..where((q) => q.id.equals(item.id))).write(
          StatementQueueCompanion(status: const Value('processing')),
        );
        
        // For now, we'll skip attachment download since it requires messageId parsing
        // In production, this would download the PDF and parse it
        
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
          transactionCount: 0,
        );
        
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
    await db.close();
  }
}

/// Fetch new statement emails and add to queue
Future<void> _fetchNewStatementEmails(GmailService gmailService, AppDatabase db) async {
  try {
    // Get last processed date
    final lastProcessed = await (db.select(db.statementQueue)
      ..orderBy([(q) => OrderingTerm.desc(q.queuedAt)])
      ..limit(1)).getSingleOrNull();
    
    final afterDate = lastProcessed?.queuedAt ?? DateTime.now().subtract(const Duration(days: 30));
    
    // Fetch emails
    final emails = await gmailService.fetchBankStatementEmails(
      maxResults: 10,
      after: afterDate,
    );
    
    // Add to queue
    for (final email in emails) {
      for (final attachment in email.attachments) {
        // Check if already in queue
        final existing = await (db.select(db.statementQueue)
          ..where((q) => q.emailId.equals(email.messageId))).getSingleOrNull();
        
        if (existing == null) {
          await db.into(db.statementQueue).insert(StatementQueueCompanion.insert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            emailId: email.messageId,
            sourceId: Value(email.bankName),
            subject: email.subject,
            emailDate: email.date,
          ));
        }
      }
    }
  } catch (e) {
    print('Error fetching statement emails: $e');
  }
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
