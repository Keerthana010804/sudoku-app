import 'package:flutter/material.dart';

class AnimatedCell extends StatefulWidget {
  final int index;
  final Widget child;

  const AnimatedCell({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<AnimatedCell> createState() => _AnimatedCellState();
}

class _AnimatedCellState extends State<AnimatedCell> {
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();

    // Create delay based on index
    final delay = Duration(milliseconds: widget.index * 30);

    Future.delayed(delay, () {
      if (mounted) {
        setState(() {
          _startAnimation = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _startAnimation ? 1 : 0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 400),
        scale: _startAnimation ? 1 : 0.8,
        child: widget.child,
      ),
    );
  }
}