import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SudokuViewModel>();

    return Container(
      color: Colors.black.withOpacity(0.6), // softer overlay
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pause_circle,
                size: 70,
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              const Text(
                "Game Paused",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Time: ${vm.formattedTime}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Gradient Resume Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: vm.resumeGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Resume",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}