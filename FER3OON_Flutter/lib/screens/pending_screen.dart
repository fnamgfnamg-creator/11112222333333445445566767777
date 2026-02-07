import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import '../core/animation.dart';
import '../services/auth_service.dart';
import '../core/constants.dart';
import 'trading_screen.dart';
import 'welcome_screen.dart';

class PendingScreen extends StatefulWidget {
  final bool isBlocked;
  
  const PendingScreen({
    Key? key,
    this.isBlocked = false,
  }) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final AuthService _auth = AuthService();
  bool _isChecking = false;

  Future<void> _checkStatus() async {
    setState(() {
      _isChecking = true;
    });

    final result = await _auth.checkStatus();

    if (mounted) {
      setState(() {
        _isChecking = false;
      });

      if (result['success']) {
        final status = result['status'];
        
        if (status == AppConstants.statusApproved) {
          Navigator.of(context).pushReplacement(
            AppAnimations.fadeRoute(const TradingScreen()),
          );
        } else if (status == AppConstants.statusBlocked) {
          if (!widget.isBlocked) {
            Navigator.of(context).pushReplacement(
              AppAnimations.fadeRoute(const PendingScreen(isBlocked: true)),
            );
          }
        }
      }
    }
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        AppAnimations.fadeRoute(const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Logout button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: AppTheme.gold),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: AppTheme.gold),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Icon
                FadeInDown(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.darkGray,
                      border: Border.all(
                        color: widget.isBlocked ? AppTheme.red : AppTheme.gold,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      widget.isBlocked ? Icons.block : Icons.hourglass_empty,
                      size: 60,
                      color: widget.isBlocked ? AppTheme.red : AppTheme.gold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Title
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    widget.isBlocked ? 'Account Blocked' : 'Pending Approval',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.isBlocked ? AppTheme.red : AppTheme.gold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Message
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    widget.isBlocked
                        ? 'Your account has been blocked. This may be due to multiple device logins or policy violations. Please contact support.'
                        : 'Your account is currently under review by our admin team. You\'ll receive a notification once approved.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.white.withOpacity(0.8),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Animated waiting indicator (only for pending)
                if (!widget.isBlocked)
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        Pulse(
                          infinite: true,
                          duration: const Duration(seconds: 2),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.gold.withOpacity(0.1),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              size: 40,
                              color: AppTheme.gold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Please wait...',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const Spacer(),
                
                // Refresh Button
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isChecking ? null : _checkStatus,
                      icon: _isChecking
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                              ),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(_isChecking ? 'Checking...' : 'Check Status'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: widget.isBlocked ? AppTheme.red : AppTheme.gold,
                          width: 2,
                        ),
                        foregroundColor: widget.isBlocked ? AppTheme.red : AppTheme.gold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Info Box
                FadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.darkGray.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (widget.isBlocked ? AppTheme.red : AppTheme.gold)
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.isBlocked ? Icons.warning : Icons.info_outline,
                          color: widget.isBlocked ? AppTheme.red : AppTheme.gold,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.isBlocked
                                ? 'Contact support via Telegram for assistance.'
                                : 'This usually takes a few minutes. You can close the app and return later.',
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
