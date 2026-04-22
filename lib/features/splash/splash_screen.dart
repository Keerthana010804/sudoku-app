import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sudoku_app/features/home/home_screen.dart';
import 'package:sudoku_app/features/splash/widgets/app_title.dart';
import 'package:sudoku_app/features/splash/widgets/background_pattern.dart';
import 'package:sudoku_app/features/splash/widgets/sudoku_grid_animation.dart';
import 'package:sudoku_app/features/splash/widgets/tagline.dart';

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
  static const _navigationDelay = Duration(seconds: 4);

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
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            const BackgroundPattern(),
            _SplashBody(fadeAnimation: _fadeAnimation)
          ]
    ),
    );
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
    return Center(
      child: FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SudokuGridAnimation(),
              SizedBox(height: 30,),
              AppTitle(),
              SizedBox(height: 15,),
              Tagline(),
            ],
          )
      ),
    );
  }
}

