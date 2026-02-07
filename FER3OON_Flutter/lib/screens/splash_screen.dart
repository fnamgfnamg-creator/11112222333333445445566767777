import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../core/animation.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';
import 'pending_screen.dart';
import 'trading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StorageService _storage = StorageService();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize storage
    await _storage.init();
    
    // Wait for splash duration
    await Future.delayed(const Duration(seconds: AppConstants.splashDuration));
    
    // Check if user has session
    if (_storage.hasSession()) {
      // Check current status from backend
      final result = await _auth.checkStatus();
      
      if (result['success']) {
        final status = result['status'];
        
        if (status == AppConstants.statusApproved) {
          _navigateToTrading();
        } else if (status == AppConstants.statusBlocked) {
          _navigateToPending(isBlocked: true);
        } else {
          _navigateToPending();
        }
      } else {
        _navigateToWelcome();
      }
    } else {
      _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    Navigator.of(context).pushReplacement(
      AppAnimations.fadeRoute(const WelcomeScreen()),
    );
  }

  void _navigateToPending({bool isBlocked = false}) {
    Navigator.of(context).pushReplacement(
      AppAnimations.fadeRoute(PendingScreen(isBlocked: isBlocked)),
    );
  }

  void _navigateToTrading() {
    Navigator.of(context).pushReplacement(
      AppAnimations.fadeRoute(const TradingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              ZoomIn(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.gold,
                        AppTheme.darkGold,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.gold.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.show_chart,
                      size: 80,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // App Name
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: const Text(
                  'FER3OON',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gold,
                    letterSpacing: 4,
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Subtitle
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: Text(
                  'Premium Trading Signals',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.white.withOpacity(0.7),
                    letterSpacing: 2,
                  ),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Loading Indicator
              FadeIn(
                delay: const Duration(milliseconds: 1000),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
