import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants.dart';
import 'signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Total duration: 2600ms (2s rotation + 600ms zoom)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // Rotation happens during the first 75% of the controller.
    // Use a Tween that goes many turns so it looks smooth.
    _rotationAnim = Tween<double>(begin: 0, end: 3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeInOut),
      ),
    );

    // Scale animation runs in the final 25% (zoom in)
    _scaleAnim = Tween<double>(begin: 1.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start the animation
    _controller.forward();

    // When done, navigate to SignInScreen.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // A short delay to let the final frame settle (optional)
        Future.delayed(const Duration(milliseconds: 80), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPill(double scale) {
    // The pill styled with gradient and shadow (capsule look)
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 140,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.appColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 2,
              offset: const Offset(-2, -2),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // glossy highlight
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // black/white or other background: choose to match brand
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // rotation value (in turns) for RotationTransition -> Fractional turns
            final rotationTurns = _rotationAnim.value;
            // scale is the zoom anim; clamp small values for the initial rotate period
            final scaleValue = _scaleAnim.value;

            // When not zooming yet, we want the pill size to remain 1.0
            final effectiveScale = scaleValue; // _scaleAnim begins at 1.0

            return Transform.scale(
              scale: effectiveScale,
              child: Transform.rotate(
                angle:
                    rotationTurns *
                    2 *
                    3.1415926535897932, // convert turns to radians
                child: _buildPill(
                  1.0,
                ), // pill drawn at natural size; outer Transform.scale handles zoom
              ),
            );
          },
        ),
      ),
    );
  }
}
