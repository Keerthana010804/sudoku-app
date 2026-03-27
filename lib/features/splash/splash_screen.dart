import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sudoku_app/features/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  static const _animationDuration = Duration(seconds: 2);
  static const _navigationDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _navigateToHome();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  void _navigateToHome() {
    Future.delayed(_navigationDelay, () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _SplashBody(fadeAnimation: _fadeAnimation));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Extracted UI
class _SplashBody extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const _SplashBody({required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: FadeTransition(opacity: fadeAnimation, child: const _AppTitle()),
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Sudoku",
      style: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
      ),
    );
  }
}
