import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({Key? key}) : super(key: key);

  Future<void> _openSupport() async {
    final uri = Uri.parse(AppConstants.supportTelegram);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _openSupport,
      backgroundColor: AppTheme.gold,
      child: const Icon(
        Icons.support_agent,
        color: AppTheme.primaryBlack,
        size: 28,
      ),
    );
  }
}
