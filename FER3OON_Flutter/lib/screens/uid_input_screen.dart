import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import '../core/animation.dart';
import '../core/constants.dart';
import '../services/auth_service.dart';
import 'pending_screen.dart';

class UIDInputScreen extends StatefulWidget {
  const UIDInputScreen({Key? key}) : super(key: key);

  @override
  State<UIDInputScreen> createState() => _UIDInputScreenState();
}

class _UIDInputScreenState extends State<UIDInputScreen> {
  final TextEditingController _uidController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  Future<void> _submitUID() async {
    final uid = _uidController.text.trim();
    
    if (uid.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your Quotex Account ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _auth.register(uid);

    if (mounted) {
      if (result['success']) {
        Navigator.of(context).pushReplacement(
          AppAnimations.createRoute(const PendingScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['message'] ?? 'Registration failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                
                // Icon
                FadeInDown(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.darkGray,
                      border: Border.all(color: AppTheme.gold, width: 3),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 50,
                      color: AppTheme.gold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Title
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: const Text(
                    'Enter Your Account ID',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Subtitle
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Enter your Quotex Account ID\nto verify your account',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // UID Input Field
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: TextField(
                    controller: _uidController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppTheme.white, fontSize: 18),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Account ID',
                      prefixIcon: const Icon(Icons.tag, color: AppTheme.gold),
                      errorText: _errorMessage,
                      filled: true,
                      fillColor: AppTheme.mediumGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.gold, width: 2),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Submit Button
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitUID,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppTheme.gold,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryBlack,
                                ),
                              ),
                            )
                          : const Text(
                              'VERIFY ACCOUNT',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Info
                FadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.darkGray.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.gold.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppTheme.gold,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your account will be verified by our admin team. You\'ll receive a notification once approved.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.white.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
