import 'package:flutter/material.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

void showStartDialog(BuildContext context, SudokuViewModel vm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white24),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.grid_4x4,
                  size: 60,
                  color: Colors.orange,
                ),

                const SizedBox(height: 16),

                const Text(
                  "Ready to Start?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Take your time and get ready.\nTap start when you're ready.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                // Gradient Start Button
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
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      vm.startTimer();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Start Game",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}