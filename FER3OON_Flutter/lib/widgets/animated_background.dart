import 'package:flutter/material.dart';
import '../core/theme.dart';

class AnimatedBackgroundWidget extends StatefulWidget {
  final Widget child;

  const AnimatedBackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedBackgroundWidget> createState() => _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState extends State<AnimatedBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryBlack,
                Color.lerp(
                  AppTheme.darkGray,
                  AppTheme.mediumGray,
                  _controller.value,
                )!,
                AppTheme.primaryBlack,
              ],
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
