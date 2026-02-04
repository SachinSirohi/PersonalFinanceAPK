import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/discovered_source.dart';
import '../../../data/services/imap_service.dart';
import 'password_collection_screen.dart';

/// Screen showing discovered statement sources after email scan
class StatementDiscoveryScreen extends StatefulWidget {
  const StatementDiscoveryScreen({super.key});

  @override
  State<StatementDiscoveryScreen> createState() => _StatementDiscoveryScreenState();
}

class _StatementDiscoveryScreenState extends State<StatementDiscoveryScreen> {
  final ImapService _imapService = ImapService();
  List<DiscoveredSource> _sources = [];
  bool _isLoading = true;
  String _statusMessage = 'Connecting to your email...';
  String? _error;

  @override
  void initState() {
    super.initState();
    _discoverSources();
  }

  Future<void> _discoverSources() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = 'Connecting to your email...';
        _error = null;
      });

      final connected = await _imapService.connect();
      if (!connected) {
        setState(() {
          _error = 'Failed to connect to email. Please check your credentials.';
          _isLoading = false;
        });
        return;
      }

      setState(() => _statusMessage = 'Scanning your inbox for statements...');

      final sources = await _imapService.discoverStatementSenders(daysBack: 365);

      await _imapService.disconnect();

      if (!mounted) return;

      setState(() {
        _sources = sources;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Discovery failed: $e';
          _isLoading = false;
        });
      }
    }
  }

  int get _selectedCount => _sources.where((s) => s.isSelected).length;
  int get _totalStatements => _sources.where((s) => s.isSelected).fold(0, (sum, s) => sum + s.statementCount);

  void _continue() {
    final selectedSources = _sources.where((s) => s.isSelected).toList();
    if (selectedSources.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one source')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordCollectionScreen(sources: selectedSources),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: _isLoading ? _buildLoadingState() : (_error != null ? _buildErrorState() : _buildDiscoveryResults()),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              color: Color(0xFFCFB53B),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _statusMessage,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a minute...',
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
          ),
        ],
      ).animate().fadeIn(),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 24),
            Text(
              'Discovery Failed',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _error ?? 'Unknown error occurred',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _discoverSources,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCFB53B),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryResults() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We Found Your Statements!',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$_totalStatements statements from $_selectedCount sources',
                          style: GoogleFonts.inter(color: const Color(0xFFCFB53B), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Select the accounts you want to import:',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.1),

        // Sources List
        Expanded(
          child: _sources.isEmpty
              ? _buildNoSourcesFound()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sources.length,
                  itemBuilder: (context, index) {
                    return _buildSourceCard(_sources[index], index);
                  },
                ),
        ),

        // Continue Button
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2744),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedCount > 0 ? _continue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCFB53B),
                  disabledBackgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _selectedCount > 0 ? 'Continue with $_selectedCount Sources' : 'Select Sources to Continue',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ).animate().fadeIn().slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildNoSourcesFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, color: Colors.white24, size: 64),
          const SizedBox(height: 24),
          Text(
            'No Statement Sources Found',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'We couldn\'t find recurring emails with PDF attachments.\nCheck if your bank sends e-statements.',
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard(DiscoveredSource source, int index) {
    final iconData = _getIconForSource(source.iconName);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: source.isSelected ? const Color(0xFF1A3A5C) : const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: source.isSelected ? const Color(0xFFCFB53B) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() => source.isSelected = !source.isSelected);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getColorForSource(source.senderName).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: _getColorForSource(source.senderName), size: 24),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.senderName,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      source.senderEmail,
                      style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCFB53B).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${source.statementCount} statements',
                        style: GoogleFonts.inter(color: const Color(0xFFCFB53B), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              // Checkbox
              Checkbox(
                value: source.isSelected,
                onChanged: (val) {
                  setState(() => source.isSelected = val ?? false);
                },
                activeColor: const Color(0xFFCFB53B),
                checkColor: Colors.black,
                side: const BorderSide(color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 50)).fadeIn().slideX(begin: 0.1);
  }

  IconData _getIconForSource(String iconName) {
    switch (iconName) {
      case 'account_balance': return Icons.account_balance;
      case 'trending_up': return Icons.trending_up;
      case 'credit_card': return Icons.credit_card;
      case 'payment': return Icons.payment;
      default: return Icons.email;
    }
  }

  Color _getColorForSource(String name) {
    final hash = name.hashCode;
    final colors = [
      const Color(0xFF1E88E5), // Blue
      const Color(0xFF43A047), // Green
      const Color(0xFFE53935), // Red
      const Color(0xFF8E24AA), // Purple
      const Color(0xFFFF8F00), // Orange
      const Color(0xFF00ACC1), // Cyan
    ];
    return colors[hash.abs() % colors.length];
  }
}
