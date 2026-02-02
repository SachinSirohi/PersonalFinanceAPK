import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth_orbit/data/services/secure_vault.dart';
import 'package:wealth_orbit/data/services/gemini_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Form controllers
  final _apiKeyController = TextEditingController();
  String _selectedCurrency = 'AED';
  bool _isValidatingKey = false;
  bool _keyValidated = false;
  String? _keyError;

  final List<String> _currencies = ['AED', 'USD', 'INR', 'EUR', 'GBP'];

  @override
  void dispose() {
    _pageController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildWelcomePage(),
                  _buildCurrencyPage(),
                  _buildApiKeyPage(),
                  _buildPermissionsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: index <= _currentPage 
                    ? const Color(0xFFCFB53B) 
                    : Colors.white.withOpacity(0.2),
              ),
            ).animate(delay: Duration(milliseconds: index * 100))
              .fadeIn()
              .slideX(begin: -0.2),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCFB53B).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.globe,
              size: 60,
              color: Color(0xFFCFB53B),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          
          const SizedBox(height: 40),
          
          Text(
            'WealthOrbit',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
          
          const SizedBox(height: 16),
          
          Text(
            'Your Global Finance\nCommand Center',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 400.ms),
          
          const SizedBox(height: 60),
          
          // Features list
          ...[
            ('🔐', 'Bank-grade Security'),
            ('🤖', 'AI-Powered Automation'),
            ('🌍', 'Multi-Currency Support'),
          ].asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(entry.value.$1, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    entry.value.$2,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ).animate(delay: Duration(milliseconds: 500 + entry.key * 100))
                .fadeIn()
                .slideX(begin: -0.2),
            );
          }),
          
          const Spacer(),
          
          _buildPrimaryButton('Get Started', () => _nextPage()),
        ],
      ),
    );
  }

  Widget _buildCurrencyPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          Text(
            'Select Your\nBase Currency',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ).animate().fadeIn().slideY(begin: 0.2),
          
          const SizedBox(height: 16),
          
          Text(
            'All your assets and transactions will be consolidated in this currency for reporting.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ).animate().fadeIn(delay: 200.ms),
          
          const SizedBox(height: 40),
          
          Expanded(
            child: ListView.builder(
              itemCount: _currencies.length,
              itemBuilder: (context, index) {
                final currency = _currencies[index];
                final isSelected = currency == _selectedCurrency;
                final symbols = {
                  'AED': ('🇦🇪', 'UAE Dirham'),
                  'USD': ('🇺🇸', 'US Dollar'),
                  'INR': ('🇮🇳', 'Indian Rupee'),
                  'EUR': ('🇪🇺', 'Euro'),
                  'GBP': ('🇬🇧', 'British Pound'),
                };
                
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedCurrency = currency);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFFCFB53B).withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFFCFB53B)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          symbols[currency]!.$1,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currency,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                symbols[currency]!.$2,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            CupertinoIcons.checkmark_circle_fill,
                            color: Color(0xFFCFB53B),
                            size: 28,
                          ),
                      ],
                    ),
                  ).animate(delay: Duration(milliseconds: index * 100))
                    .fadeIn()
                    .slideX(begin: 0.1),
                );
              },
            ),
          ),
          
          _buildPrimaryButton('Continue', () async {
            await SecureVault.setBaseCurrency(_selectedCurrency);
            _nextPage();
          }),
        ],
      ),
    );
  }

  Widget _buildApiKeyPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            
            Text(
              'Activate AI\nIntelligence',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ).animate().fadeIn().slideY(begin: 0.2),
            
            const SizedBox(height: 16),
            
            Text(
              'WealthOrbit uses Google Gemini AI to automatically parse your bank statements. You need to provide your own API key (it\'s free!).',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Steps
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to get your free API key:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCFB53B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStep('1', 'Go to aistudio.google.com'),
                  _buildStep('2', 'Sign in with your Google account'),
                  _buildStep('3', 'Click "Get API Key" → "Create API Key"'),
                  _buildStep('4', 'Copy and paste the key below'),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
            
            const SizedBox(height: 24),
            
            // API Key Input
            TextField(
              controller: _apiKeyController,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Paste your Gemini API key here',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.3),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCFB53B), width: 2),
                ),
                errorText: _keyError,
                suffixIcon: _keyValidated
                    ? const Icon(CupertinoIcons.checkmark_circle_fill, color: Colors.green)
                    : null,
              ),
              obscureText: true,
            ),
            
            const SizedBox(height: 16),
            
            // Validate button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isValidatingKey ? null : _validateApiKey,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isValidatingKey
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Validate Key',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            _buildPrimaryButton(
              'Continue',
              _keyValidated ? () async {
                await SecureVault.setGeminiApiKey(_apiKeyController.text.trim());
                _nextPage();
              } : null,
            ),
            
            const SizedBox(height: 16),
            
            // Skip option
            Center(
              child: TextButton(
                onPressed: () => _nextPage(),
                child: Text(
                  'Skip for now (limited features)',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFCFB53B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFCFB53B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          Text(
            'Almost\nThere!',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ).animate().fadeIn().slideY(begin: 0.2),
          
          const SizedBox(height: 16),
          
          Text(
            'Grant permissions to enable automatic statement syncing from your email.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ).animate().fadeIn(delay: 200.ms),
          
          const SizedBox(height: 40),
          
          // Permission cards
          _buildPermissionCard(
            icon: CupertinoIcons.mail,
            title: 'Gmail Access',
            description: 'Read bank statements from your email',
            isGranted: false,
            onTap: () {
              // TODO: Implement Gmail sign-in
              HapticFeedback.mediumImpact();
            },
          ).animate(delay: 300.ms).fadeIn().slideX(begin: 0.1),
          
          const SizedBox(height: 16),
          
          _buildPermissionCard(
            icon: CupertinoIcons.bell,
            title: 'Notifications',
            description: 'Get alerts for new statements and budget warnings',
            isGranted: false,
            onTap: () {
              // TODO: Request notification permission
              HapticFeedback.mediumImpact();
            },
          ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.1),
          
          const Spacer(),
          
          _buildPrimaryButton('Launch WealthOrbit', () async {
            await SecureVault.setOnboardingComplete(true);
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          }),
          
          const SizedBox(height: 16),
          
          Center(
            child: TextButton(
              onPressed: () async {
                await SecureVault.setOnboardingComplete(true);
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              child: Text(
                'Set up later',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isGranted ? Colors.green : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFCFB53B).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFCFB53B), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isGranted 
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.chevron_right,
              color: isGranted ? Colors.green : Colors.white.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCFB53B),
          foregroundColor: const Color(0xFF0A1628),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _validateApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) {
      setState(() => _keyError = 'Please enter your API key');
      return;
    }
    
    setState(() {
      _isValidatingKey = true;
      _keyError = null;
    });
    
    try {
      final isValid = await GeminiService.validateApiKey(key);
      setState(() {
        _isValidatingKey = false;
        if (isValid) {
          _keyValidated = true;
          _keyError = null;
        } else {
          _keyError = 'Invalid API key. Please check and try again.';
        }
      });
    } catch (e) {
      setState(() {
        _isValidatingKey = false;
        _keyError = 'Error validating key: $e';
      });
    }
  }
}
