import 'package:flutter/material.dart';

class BackgroundPattern extends StatelessWidget {
  const BackgroundPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: Container(
        color: const Color(0xFF0F172A),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..strokeWidth = 1;

        const double cellSize = 40;

        // Draw vertical lines
        for (double x = 0; x <= size.width; x += cellSize) {
          canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
          );
    }
        // Draw horizontal lines
        for (double y = 0; y <= size.height; y += cellSize) {
          canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          paint,
    );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}