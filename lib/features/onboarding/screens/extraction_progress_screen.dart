import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/discovered_source.dart';
import '../../../data/services/imap_service.dart';
import '../../../data/services/pdf_extraction_service.dart';
import '../../../data/services/secure_vault.dart';
import '../../dashboard/screens/dashboard_screen.dart';

/// Screen showing extraction progress - user cannot skip until complete
class ExtractionProgressScreen extends StatefulWidget {
  final List<DiscoveredSource> sources;
  final Map<String, String> passwords;

  const ExtractionProgressScreen({
    super.key,
    required this.sources,
    required this.passwords,
  });

  @override
  State<ExtractionProgressScreen> createState() => _ExtractionProgressScreenState();
}

class _ExtractionProgressScreenState extends State<ExtractionProgressScreen> {
  final ImapService _imapService = ImapService();
  
  int _totalStatements = 0;
  int _processedStatements = 0;
  int _successfulExtractions = 0;
  int _failedExtractions = 0;
  String _currentSource = '';
  String _currentStatus = 'Initializing...';
  bool _isComplete = false;
  bool _hasError = false;
  String? _errorMessage;
  
  // Store extracted texts for later processing
  final List<String> _extractedTexts = [];
  
  // Time tracking
  DateTime? _startTime;
  
  @override
  void initState() {
    super.initState();
    _startExtraction();
  }

  @override
  void dispose() {
    _imapService.disconnect();
    super.dispose();
  }

  Future<void> _startExtraction() async {
    _startTime = DateTime.now();
    
    // Calculate total statements
    _totalStatements = widget.sources.fold(0, (sum, s) => sum + s.statementCount);
    
    setState(() {
      _currentStatus = 'Connecting to email...';
    });

    try {
      // Connect to IMAP
      final connected = await _imapService.connect();
      if (!connected) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to connect to email server';
        });
        return;
      }

      // First, discover emails to populate cache
      setState(() => _currentStatus = 'Scanning emails...');
      await _imapService.discoverStatementSenders();

      // Process each source
      for (int i = 0; i < widget.sources.length; i++) {
        final source = widget.sources[i];
        
        setState(() {
          _currentSource = source.senderName;
          _currentStatus = 'Processing ${source.senderName}...';
        });

        // Get password for this source
        final password = widget.passwords[source.senderEmail] ?? 
                         await SecureVault.getPdfPassword(source.senderEmail);

        // Get emails from this sender (uses cached headers)
        final emails = await _imapService.searchStatementEmails(
          [source.senderEmail],
        );

        print('📧 Found ${emails.length} emails from ${source.senderEmail}');

        // Process each email
        for (int j = 0; j < emails.length; j++) {
          final email = emails[j];
          final uid = email.uid ?? 0;
          
          if (uid == 0) {
            _processedStatements++;
            continue;
          }
          
          setState(() {
            _currentStatus = '${source.senderName}: ${j + 1}/${emails.length}';
          });

          try {
            // Fetch full message with attachments
            final fullMessage = await _imapService.fetchFullMessage(uid);
            if (fullMessage == null) {
              print('⚠️ Could not fetch message UID $uid');
              _failedExtractions++;
              _processedStatements++;
              continue;
            }

            // Extract PDF attachments
            final pdfs = await _imapService.extractPdfAttachments(fullMessage);
            
            if (pdfs.isEmpty) {
              // No PDF attachments - not a failure, just skip
              _processedStatements++;
              continue;
            }

            // Process first PDF
            final pdfBytes = pdfs.first;
            
            // Extract text
            try {
              final text = await PdfExtractionService.extractText(
                pdfBytes, 
                password: password,
              );
              
              if (text != null && text.length > 100) {
                _successfulExtractions++;
                _extractedTexts.add(text);
                print('✅ Extracted ${text.length} chars from ${source.senderName}');
              } else {
                _failedExtractions++;
                print('⚠️ Extracted text too short or empty');
              }
            } catch (e) {
              print('❌ PDF extraction failed: $e');
              _failedExtractions++;
            }

          } catch (e) {
            print('❌ Error processing email UID $uid: $e');
            _failedExtractions++;
          }

          setState(() {
            _processedStatements++;
          });

          // Small delay to prevent overwhelming the server
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }

      // Mark onboarding as complete
      await SecureVault.setOnboardingComplete(true);

      setState(() {
        _isComplete = true;
        _currentStatus = 'Extraction complete!';
      });

    } catch (e) {
      print('❌ Extraction error: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Extraction failed: ${e.toString().split('\n').first}';
      });
    } finally {
      await _imapService.disconnect();
    }
  }

  String get _timeElapsed {
    if (_startTime == null) return '0:00';
    final elapsed = DateTime.now().difference(_startTime!);
    final minutes = elapsed.inMinutes;
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _goToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
      (route) => false,
    );
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _processedStatements = 0;
      _successfulExtractions = 0;
      _failedExtractions = 0;
      _extractedTexts.clear();
    });
    _startExtraction();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isComplete,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1628),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                
                // Main progress indicator
                _buildProgressIndicator(),
                
                const SizedBox(height: 48),
                
                // Stats
                _buildStats(),
                
                const SizedBox(height: 32),
                
                // Current status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2744),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (!_isComplete && !_hasError)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFCFB53B)),
                        ),
                      if (_isComplete)
                        const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                      if (_hasError)
                        const Icon(Icons.error, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _hasError ? (_errorMessage ?? 'Error occurred') : _currentStatus,
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Warning message
                if (!_isComplete && !_hasError)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please keep the app open. You can minimize but don\'t close.',
                            style: GoogleFonts.inter(color: Colors.orange.shade200, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const Spacer(),
                
                // Continue button (only when complete)
                if (_isComplete)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goToDashboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCFB53B),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Go to Dashboard',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),
                
                if (_hasError)
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _retry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCFB53B),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            'Retry',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () async {
                          await SecureVault.setOnboardingComplete(true);
                          _goToDashboard();
                        },
                        child: Text(
                          'Skip & Continue to Dashboard',
                          style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = _totalStatements > 0 ? _processedStatements / _totalStatements : 0.0;
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: const Color(0xFF1A2744),
                valueColor: AlwaysStoppedAnimation(
                  _isComplete ? const Color(0xFF4CAF50) : const Color(0xFFCFB53B),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_currentSource.isNotEmpty)
                  Text(
                    _currentSource,
                    style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          _isComplete ? 'Extraction Complete!' : 'Extracting Statements...',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$_processedStatements of $_totalStatements processed',
          style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.timer_outlined,
            label: 'Time',
            value: _timeElapsed,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            label: 'Success',
            value: '$_successfulExtractions',
            color: const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.error_outline,
            label: 'Failed',
            value: '$_failedExtractions',
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
