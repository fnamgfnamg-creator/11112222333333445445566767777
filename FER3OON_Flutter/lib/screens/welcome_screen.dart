import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../core/animation.dart';
import 'uid_input_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  Future<void> _launchRegistration() async {
    final uri = Uri.parse(AppConstants.registrationUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToUIDInput(BuildContext context) {
    Navigator.of(context).push(
      AppAnimations.createRoute(const UIDInputScreen()),
    );
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
                const Spacer(),
                
                // Logo
                FadeInDown(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.gold, AppTheme.darkGold],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.gold.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.show_chart,
                      size: 60,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // App Name
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: const Text(
                    'FER3OON',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Tagline
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    'Premium Trading Signals\nFor Quotex Platform',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Register Button
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _launchRegistration,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppTheme.gold,
                      ),
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Already Have Account Button
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _navigateToUIDInput(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: const BorderSide(color: AppTheme.gold, width: 2),
                      ),
                      child: const Text(
                        'I ALREADY HAVE ACCOUNT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Info Text
                FadeIn(
                  delay: const Duration(milliseconds: 1000),
                  child: Text(
                    'Get accurate trading signals\nand maximize your profits',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.white.withOpacity(0.5),
                      height: 1.5,
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
