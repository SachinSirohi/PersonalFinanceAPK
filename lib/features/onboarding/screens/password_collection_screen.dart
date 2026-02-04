import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/discovered_source.dart';
import '../../../data/services/imap_service.dart';
import '../../../data/services/pdf_extraction_service.dart';
import '../../../data/services/secure_vault.dart';
import 'extraction_progress_screen.dart';

/// Screen for collecting PDF passwords per sender
class PasswordCollectionScreen extends StatefulWidget {
  final List<DiscoveredSource> sources;
  
  const PasswordCollectionScreen({super.key, required this.sources});

  @override
  State<PasswordCollectionScreen> createState() => _PasswordCollectionScreenState();
}

class _PasswordCollectionScreenState extends State<PasswordCollectionScreen> {
  final ImapService _imapService = ImapService();
  final TextEditingController _passwordController = TextEditingController();
  
  int _currentSourceIndex = 0;
  bool _isLoading = false;
  bool _isTesting = false;
  String _statusMessage = '';
  String _emailSubject = '';
  String _emailBody = '';
  Uint8List? _samplePdf;
  bool _testPassed = false;
  String? _errorMessage;
  
  // Store collected passwords
  final Map<String, String> _passwords = {};

  @override
  void initState() {
    super.initState();
    _connectAndLoadEmail();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _imapService.disconnect();
    super.dispose();
  }

  DiscoveredSource get _currentSource => widget.sources[_currentSourceIndex];

  /// Connect to IMAP and load the first email
  Future<void> _connectAndLoadEmail() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Connecting to email...';
      _emailSubject = '';
      _emailBody = '';
      _samplePdf = null;
      _testPassed = false;
      _errorMessage = null;
      _passwordController.clear();
    });

    try {
      // Connect to IMAP
      final connected = await _imapService.connect();
      if (!connected) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to connect to email server';
        });
        return;
      }

      await _fetchEmailFromSender();

    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString().split('\n').first}';
      });
    }
  }

  /// Fetch an email from the current sender
  Future<void> _fetchEmailFromSender() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Searching for emails...';
      _emailSubject = '';
      _emailBody = '';
      _samplePdf = null;
      _testPassed = false;
      _errorMessage = null;
      _passwordController.clear();
    });

    try {
      if (!_imapService.isConnected) {
        final connected = await _imapService.connect();
        if (!connected) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Connection lost. Please try again.';
          });
          return;
        }
      }

      // Search for emails from this sender using IMAP SEARCH
      setState(() => _statusMessage = 'Searching for ${_currentSource.senderName}...');
      
      final senderEmail = _currentSource.senderEmail;
      print('🔍 Searching for emails from: $senderEmail');
      
      // Fetch latest high-fidelity message 
      final email = await _imapService.fetchLatestMessageForSender(senderEmail);
      
      if (email == null) {
        // Try discovery first to populate cache
        setState(() => _statusMessage = 'Scanning inbox...');
        await _imapService.discoverStatementSenders();
        
        // Try again
        final retryEmail = await _imapService.fetchLatestMessageForSender(senderEmail);
        if (retryEmail == null) {
          setState(() {
            _isLoading = false;
            _emailSubject = 'No emails found';
            _emailBody = 'Could not find emails from ${_currentSource.senderName}. This might be a filtering issue.';
            _testPassed = true; // Allow skip
          });
          return;
        }
        // Continue with retry results
        await _processEmail(retryEmail);
      } else {
        await _processEmail(email);
      }

    } catch (e) {
      print('❌ Error fetching email: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString().split('\n').first}';
      });
    }
  }

  /// Process a single email - fetch body and extract PDF
  Future<void> _processEmail(dynamic email) async {
    final uid = email.uid ?? 0;
    if (uid == 0) {
      setState(() {
        _isLoading = false;
        _emailSubject = 'Invalid email';
        _emailBody = 'Could not process this email.';
        _testPassed = true;
      });
      return;
    }

    setState(() => _statusMessage = 'Downloading email...');
    
    // Fetch full message
    final fullMessage = await _imapService.fetchFullMessage(uid);
    
    if (fullMessage == null) {
      setState(() {
        _isLoading = false;
        _emailSubject = 'Failed to load email';
        _emailBody = 'Could not download the email content.';
        _testPassed = true;
      });
      return;
    }

    // Get email details
    final subject = fullMessage.decodeSubject() ?? 'No Subject';
    final body = _imapService.getEmailBody(fullMessage);
    
    setState(() {
      _emailSubject = subject;
      _emailBody = body.length > 800 ? '${body.substring(0, 800)}...' : body;
    });

    setState(() => _statusMessage = 'Extracting PDF attachment...');

    // Extract PDF attachments
    final pdfs = await _imapService.extractPdfAttachments(fullMessage);
    
    if (pdfs.isEmpty) {
      setState(() {
        _isLoading = false;
        _samplePdf = null;
        _errorMessage = 'No PDF attachment found in this email.';
        _testPassed = true; // Allow skip
      });
      return;
    }

    print('📎 Found ${pdfs.length} PDF(s), using first (${pdfs.first.length} bytes)');
    
    setState(() {
      _samplePdf = pdfs.first;
      _isLoading = false;
      _statusMessage = '';
    });

    // Check if PDF needs password
    setState(() => _statusMessage = 'Checking PDF...');
    
    try {
      final needsPassword = await PdfExtractionService.isPasswordProtected(_samplePdf!);
      
      if (!needsPassword) {
        // Try to extract without password
        final text = await PdfExtractionService.extractText(_samplePdf!);
        if (text != null && text.isNotEmpty) {
          setState(() {
            _testPassed = true;
            _statusMessage = '';
            _errorMessage = null;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ PDF opened successfully - no password needed'),
                backgroundColor: Colors.green,
              ),
            );
          }
          return;
        }
      }
      
      // Password required
      setState(() {
        _statusMessage = '';
        _errorMessage = '🔒 This PDF requires a password.';
      });
      
    } catch (e) {
      print('PDF check error: $e');
      setState(() {
        _statusMessage = '';
        _errorMessage = '🔒 This PDF requires a password.';
      });
    }
  }

  /// Test the entered password
  Future<void> _testPassword() async {
    if (_samplePdf == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No PDF to test')),
      );
      return;
    }

    final password = _passwordController.text.trim();
    
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a password')),
      );
      return;
    }
    
    setState(() {
      _isTesting = true;
      _statusMessage = 'Testing password...';
      _errorMessage = null;
    });

    try {
      // Test if we can open the PDF
      final canOpen = await PdfExtractionService.testPassword(_samplePdf!, password);
      
      if (canOpen) {
        // SUCCESS - password worked!
        setState(() {
          _isTesting = false;
          _testPassed = true;
          _statusMessage = '';
        });
        
        // Save password
        _passwords[_currentSource.senderEmail] = password;
        await SecureVault.setPdfPassword(_currentSource.senderEmail, password);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Password verified!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // FAILED - password wrong
        setState(() {
          _isTesting = false;
          _testPassed = false;
          _errorMessage = '❌ Wrong password. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testPassed = false;
        _errorMessage = '❌ Could not verify password. Error: ${e.toString().split('\n').first}';
      });
    }
  }

  void _nextSource() {
    if (_currentSourceIndex < widget.sources.length - 1) {
      setState(() {
        _currentSourceIndex++;
      });
      _fetchEmailFromSender();
    } else {
      // All done, go to extraction
      _startExtraction();
    }
  }

  void _skipSource() {
    widget.sources.removeAt(_currentSourceIndex);
    
    if (widget.sources.isEmpty) {
      Navigator.pop(context);
      return;
    }
    
    if (_currentSourceIndex >= widget.sources.length) {
      _currentSourceIndex = widget.sources.length - 1;
    }
    
    _fetchEmailFromSender();
  }

  void _startExtraction() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ExtractionProgressScreen(
          sources: widget.sources,
          passwords: _passwords,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: _isLoading ? _buildLoadingState() : _buildPasswordForm(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFFCFB53B)),
          const SizedBox(height: 24),
          Text(
            _statusMessage,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentSource.senderName,
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      children: [
        // Progress indicator
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: List.generate(widget.sources.length, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: index <= _currentSourceIndex
                        ? const Color(0xFFCFB53B)
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
              );
            }),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance, color: Color(0xFF1E88E5), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentSource.senderName,
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Source ${_currentSourceIndex + 1} of ${widget.sources.length} • ${_currentSource.statementCount} statements',
                            style: GoogleFonts.inter(color: const Color(0xFFCFB53B), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(),
                const SizedBox(height: 24),

                // Email Preview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2744),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email, color: Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Email Preview',
                            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _emailSubject.isEmpty ? 'Loading...' : _emailSubject,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_emailBody.isNotEmpty) ...[
                        const Divider(color: Colors.white12, height: 24),
                        Text(
                          _emailBody,
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, height: 1.5),
                          maxLines: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (_samplePdf != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'PDF Attachment (${(_samplePdf!.length / 1024).toStringAsFixed(0)} KB)',
                                style: GoogleFonts.inter(color: Colors.red.shade200, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 20),

                // Success indicator
                if (_testPassed) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ready to continue',
                            style: GoogleFonts.inter(color: const Color(0xFF4CAF50), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Error/Info message
                if (_errorMessage != null && !_testPassed) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.inter(color: Colors.orange.shade200, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Password input (only if PDF exists and test not passed)
                if (_samplePdf != null && !_testPassed) ...[
                  Text(
                    'Enter PDF Password',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1A2744),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                    ),
                    onSubmitted: (_) => _testPassword(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Common: DOB (DDMMYYYY), PAN, Last 4 digits of account',
                    style: GoogleFonts.inter(color: Colors.white38, fontSize: 11),
                  ),
                  const SizedBox(height: 16),
                  
                  // Test button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isTesting ? null : _testPassword,
                      icon: _isTesting 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Icon(Icons.vpn_key),
                      label: Text(_isTesting ? 'Testing...' : 'Test Password'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCFB53B),
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Bottom buttons
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2744),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _skipSource,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _testPassed ? _nextSource : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCFB53B),
                      disabledBackgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _currentSourceIndex < widget.sources.length - 1 ? 'Next Source' : 'Start Extraction',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
