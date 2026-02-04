import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' show Value;
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../data/services/secure_vault.dart';
import '../../../data/services/imap_service.dart';
import '../../onboarding/screens/onboarding_screen.dart';

class StatementAutomationScreen extends StatefulWidget {
  const StatementAutomationScreen({super.key});

  @override
  State<StatementAutomationScreen> createState() => _StatementAutomationScreenState();
}

class _StatementAutomationScreenState extends State<StatementAutomationScreen> {
  AppRepository? _repo;
  List<StatementSource> _sources = [];
  List<StatementQueueData> _queue = [];
  bool _isLoading = true;
  bool _isGmailConnected = false;
  DateTime? _lastSync;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _repo = await AppRepository.getInstance();
      if (!mounted) return;
      await _loadData();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final sources = await _repo!.getAllStatementSources();
      if (!mounted) return;
      final queue = await _repo!.getPendingStatementQueue();
      if (!mounted) return;
      
      final hasCreds = await SecureVault.hasEmailCredentials();
      
      if (!mounted) return;
      setState(() {
        _sources = sources;
        _queue = queue;
        _isGmailConnected = hasCreds;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        title: Text('Statement Automation', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFCFB53B)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildGmailIntegrationCard(),
                   const SizedBox(height: 24),
                   _buildQueueSection(),
                   const SizedBox(height: 24),
                   _buildSourcesSection(),
                   const SizedBox(height: 100),
                ],
              ),
            ),
       floatingActionButton: FloatingActionButton.extended(
        onPressed: _uploadManualStatement,
        backgroundColor: const Color(0xFFCFB53B),
        icon: const Icon(Icons.upload_file, color: Colors.black),
        label: Text('Upload Statement', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
    );
  }
  
  Widget _buildGmailIntegrationCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isGmailConnected 
              ? [const Color(0xFF1E88E5), const Color(0xFF1565C0)]
              : [const Color(0xFF424242), const Color(0xFF212121)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_isGmailConnected ? const Color(0xFF1E88E5) : Colors.black).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.email_outlined, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gmail Sync', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(
                        _isGmailConnected ? 'Connected' : 'Not Connected',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: _isGmailConnected,
                onChanged: (val) {
                  _showEmailConfigSheet();
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
          if (_isGmailConnected) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            TextButton.icon(
              onPressed: _syncEmails,
              icon: const Icon(Icons.sync, color: Colors.white),
              label: Text('Sync Now', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildQueueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Processing Queue', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            if (_queue.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFCFB53B), borderRadius: BorderRadius.circular(10)),
                child: Text('${_queue.length} Pending', style: GoogleFonts.inter(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_queue.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2744),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                 const Icon(CupertinoIcons.checkmark_circle, color: Color(0xFF4CAF50), size: 40),
                 const SizedBox(height: 12),
                 Text('All caught up!', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                 Text('No pending statements to process', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _queue.length > 3 ? 3 : _queue.length,
            itemBuilder: (context, index) {
              final item = _queue[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2744),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.picture_as_pdf, color: Colors.white70, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.subject, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              SizedBox(
                                width: 12, 
                                height: 12, 
                                child: CircularProgressIndicator(strokeWidth: 2, color: const Color(0xFFCFB53B)),
                              ),
                              const SizedBox(width: 8),
                              Text('Processing...', style: GoogleFonts.inter(color: const Color(0xFFCFB53B), fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildSourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Email Sources', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: _showAddSourceSheet,
              icon: const Icon(Icons.add_circle, color: Color(0xFFCFB53B)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_sources.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2744),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                 const Icon(Icons.mark_email_unread_outlined, color: Colors.white24, size: 40),
                 const SizedBox(height: 12),
                 Text('No sources configured', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                 Text('Add bank email addresses to auto-detect statements', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
              ],
            ),
          )
        else
          ..._sources.map((source) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2744),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF1E88E5).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.account_balance, color: Color(0xFF1E88E5), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(source.bankName, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(source.senderEmail, style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
                  onPressed: () async {
                    await _repo!.deleteStatementSource(source.id);
                    _loadData();
                  },
                ),
              ],
            ),
          )),
      ],
    );
  }

  Future<void> _uploadManualStatement() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        await _repo!.insertStatementQueueItem(StatementQueueCompanion(
          id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
          emailId: const Value('manual_upload'),
          subject: Value('Manual Upload: ${result.files.single.name}'),
          status: const Value('pending'),
          priority: const Value(100),
          emailDate: Value(DateTime.now()),
          queuedAt: Value(DateTime.now()),
        ));
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Statement queued for processing')));
        _loadData();
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  void _showAddSourceSheet() {
    final emailController = TextEditingController();
    final bankController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Color(0xFF1A2744),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Statement Source', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 24),
              TextField(
                controller: bankController,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Sender Email',
                  hintText: 'e.g., no-reply@bank.com',
                  hintStyle: const TextStyle(color: Colors.white24),
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (bankController.text.isNotEmpty && emailController.text.isNotEmpty) {
                      await _repo!.insertStatementSource(StatementSourcesCompanion(
                        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
                        bankName: Value(bankController.text),
                        senderEmail: Value(emailController.text),
                        accountType: const Value('bank'),
                      ));
                      if (context.mounted) Navigator.pop(context);
                      _loadData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCFB53B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Add Source', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showEmailConfigSheet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    ).then((_) => _loadData());
  }

  Future<void> _syncEmails() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⏳ Connecting to email...')),
    );
    
    final imap = ImapService();
    try {
      final connected = await imap.connect();
      if (!connected) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Connection failed'), backgroundColor: Colors.red),
          );
        }
        return;
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔍 Searching for statements...')),
        );
      }
      
      final sources = await _repo!.getAllStatementSources();
      final dbSenders = sources.map((s) => s.senderEmail).toList();
      
      final senders = <String>[
        ...dbSenders,
        'statements@bank.com', 
        'estatements@emiratesnbd.com', 
        'service@paypal.com',
        'no-reply@enbd.com', 
        'alert@emiratesnbd.com'
      ].toSet().toList();
      
      print('🔍 Searching emails from: $senders');
      
      final emails = await imap.searchStatementEmails(senders);
      
      if (mounted) {
        if (emails.isEmpty) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No new statements found')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Found ${emails.length} emails. Processing...')),
          );
        }
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      await imap.disconnect();
    }
  }
}
