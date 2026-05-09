import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/widgets/number_pad.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

class NumberPadSection extends StatelessWidget {
  const NumberPadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();

    return IgnorePointer(
      ignoring: vm.isPaused,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white24),
        ),
        child: NumberPad(
          selectedNumber: vm.selectedNumber,
          getRemainingCount: vm.getRemainingCount,
          onNumberTap: (number) {
            final isValid = vm.enterNumber(number);
            if (!isValid) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid Move!"),
                  duration: Duration(seconds: 2),
                ),
              );
              vm.clearSelection();
              return;
            }
            vm.selectNumber(number);
          },
        ),
      ),
    );
  }
}