import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../services/api_service.dart';
import 'dart:async';

class SignalButton extends StatefulWidget {
  final String uid;

  const SignalButton({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<SignalButton> createState() => _SignalButtonState();
}

class _SignalButtonState extends State<SignalButton> {
  final ApiService _api = ApiService();
  bool _isLoading = false;
  String? _currentSignal;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _canRequestSignal = true;

  @override
  void initState() {
    super.initState();
    _checkIfNewMinute();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Check if we're at the start of a new minute
  void _checkIfNewMinute() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      
      // Enable signal request only at the start of new minute
      if (now.second == 0 || now.second == 1) {
        if (!_canRequestSignal) {
          setState(() {
            _canRequestSignal = true;
          });
        }
      }

      // Update countdown if signal is active
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          if (_remainingSeconds == 0) {
            _currentSignal = null;
            _canRequestSignal = false;
          }
        });
      }
    });
  }

  Future<void> _getSignal() async {
    if (_isLoading || !_canRequestSignal) return;

    final now = DateTime.now();
    
    // Only allow signal generation at start of new minute (0-5 seconds)
    if (now.second > 5) {
      _showMessage('Wait for the next minute to start');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _api.getSignal(widget.uid);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        setState(() {
          _currentSignal = result['signal'];
          _remainingSeconds = AppConstants.signalDuration;
          _canRequestSignal = false;
        });
      } else {
        _showMessage(result['message'] ?? 'Failed to get signal');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.darkGray,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getSignalColor() {
    if (_currentSignal == null) return AppTheme.gold;
    return _currentSignal == 'CALL' ? AppTheme.green : AppTheme.red;
  }

  IconData _getSignalIcon() {
    if (_currentSignal == null) return Icons.flash_on;
    return _currentSignal == 'CALL' ? Icons.arrow_upward : Icons.arrow_downward;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Signal display (if active)
          if (_currentSignal != null)
            Pulse(
              infinite: true,
              duration: const Duration(milliseconds: 1500),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: _getSignalColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getSignalColor(),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getSignalIcon(),
                      color: _getSignalColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_currentSignal - ${_remainingSeconds}s',
                      style: TextStyle(
                        color: _getSignalColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (_currentSignal != null) const SizedBox(height: 10),
          
          // Get Signal Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isLoading || !_canRequestSignal || _currentSignal != null)
                  ? null
                  : _getSignal,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getSignalColor(),
                foregroundColor: AppTheme.primaryBlack,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                disabledBackgroundColor: AppTheme.lightGray,
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentSignal != null
                              ? Icons.check_circle
                              : Icons.flash_on,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _currentSignal != null
                              ? 'SIGNAL ACTIVE'
                              : (_canRequestSignal
                                  ? 'GET SIGNAL'
                                  : 'WAIT FOR NEW MINUTE'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
