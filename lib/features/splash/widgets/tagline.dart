import 'package:flutter/material.dart';

class Tagline extends StatefulWidget {
  const Tagline({super.key});

  @override
  State<Tagline> createState() => _TaglineState();
}

class _TaglineState extends State<Tagline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          "Train Your Brain",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}