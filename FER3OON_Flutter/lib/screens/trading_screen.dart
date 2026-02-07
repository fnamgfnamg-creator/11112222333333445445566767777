import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../widgets/signal_button.dart';
import '../widgets/support_button.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../core/animation.dart';
import 'welcome_screen.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({Key? key}) : super(key: key);

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  late final WebViewController _webViewController;
  final StorageService _storage = StorageService();
  final AuthService _auth = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.primaryBlack)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConstants.quotexWebUrl));
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGray,
        title: const Text(
          'Logout',
          style: TextStyle(color: AppTheme.gold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppTheme.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.white)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout', style: TextStyle(color: AppTheme.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _auth.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          AppAnimations.fadeRoute(const WelcomeScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _openSupport() async {
    final uri = Uri.parse(AppConstants.supportTelegram);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _storage.getUID() ?? '';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('FER3OON Trading'),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: _openSupport,
            tooltip: 'Support',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView - 90% of screen
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _webViewController),
                    
                    // Loading indicator
                    if (_isLoading)
                      Container(
                        color: AppTheme.primaryBlack,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Loading Trading Platform...',
                                style: TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Signal Button Container - Fixed at bottom, doesn't overlap WebView
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.darkGray,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlack.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Center(
                  child: SignalButton(uid: uid),
                ),
              ),
            ],
          ),
          
          // Support Button (Floating)
          const Positioned(
            right: 16,
            bottom: 100,
            child: SupportButton(),
          ),
        ],
      ),
    );
  }
}
