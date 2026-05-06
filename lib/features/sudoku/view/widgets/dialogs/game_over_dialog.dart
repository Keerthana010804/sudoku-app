import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/home/widgets/primary_button.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/dialog_service.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/game_dialog.dart';

void showGameOverDialog(BuildContext context) {
  showGameDialog(
    context: context,
    child: GameDialog(
      icon: Icons.sentiment_dissatisfied,
      iconColor: Colors.redAccent,
      title: "Game Over",
      description: "You made too many mistakes",
      actions: [
        Expanded(
          child: PrimaryButton(
            text: "Try Again",
            onPressed: () {
              final vm = context.read<SudokuViewModel>();
              vm.isGameOver = false;

              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}

