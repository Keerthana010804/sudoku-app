import 'package:flutter/material.dart';
import 'package:sudoku_app/features/splash/widgets/animated_cell.dart';

class SudokuGridAnimation extends StatelessWidget {
  const SudokuGridAnimation({super.key});

  static const int gridSize = 3;

  final List<List<int?>> grid = const [
    [5, null, 3],
    [null, 2, null],
    [1, null, 4],
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 180,
        width: 180,
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridSize * gridSize,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
            ),
            itemBuilder: (context, index) {
              final row = index ~/ gridSize;
              final col = index % gridSize;
              final value = grid[row][col];

              return AnimatedCell(
                index: index,
                child: _buildCell(row, col, value),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int row, int col, int? value) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
      child: value != null
          ? _AnimatedNumber(
        number: value,
      )
          : null,
    );
  }
}

class _AnimatedNumber extends StatefulWidget {
  final int number;

  const _AnimatedNumber({required this.number});

  @override
  State<_AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<_AnimatedNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.5), // comes from top
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scale = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // slight bounce effect
    ));

    // Delay so it appears after cell animation
    Future.delayed(const Duration(milliseconds: 300), () {
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
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: Text(
            widget.number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}