import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

class TimeView extends StatelessWidget {
  const TimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SudokuViewModel, String>(
      selector: (_, vm) => vm.formattedTime,
      builder: (_, time, __) {
        return Selector<SudokuViewModel, int>(
          selector: (_, vm) => vm.mistakes,
          builder: (_, mistakes, __) {
            final maxMistakes =
                context.read<SudokuViewModel>().maxMistakes;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 🔹 Timer Section
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  /// 🔹 Mistakes Section
                  Row(
                    children: [
                      const Icon(Icons.close, color: Colors.redAccent),
                      const SizedBox(width: 6),
                      Text(
                        "$mistakes / $maxMistakes",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}