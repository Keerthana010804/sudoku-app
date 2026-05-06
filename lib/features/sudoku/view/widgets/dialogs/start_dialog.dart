import 'package:flutter/material.dart';
import 'package:sudoku_app/features/home/widgets/primary_button.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/dialog_service.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/game_dialog.dart';

void showStartDialog(BuildContext context, SudokuViewModel vm) {
  showGameDialog(
    context: context,
    child: GameDialog(
      icon: Icons.grid_4x4,
      iconColor: Colors.orange,
      title: "Ready to Start?",
      description: "Tap start when you're ready.",
      actions: [
        Expanded(
          child: PrimaryButton(
            text: "Start Game",
            onPressed: () {
              Navigator.pop(context);
              vm.startTimer();
            },
          ),
        ),
      ],
    ),
  );
}
