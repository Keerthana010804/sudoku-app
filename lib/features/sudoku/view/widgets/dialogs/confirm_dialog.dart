import 'package:flutter/material.dart';
import 'package:sudoku_app/features/home/widgets/primary_button.dart';
import 'package:sudoku_app/features/sudoku/view/sudoku_screen.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/dialog_service.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/game_dialog.dart';

void showNewGameConfirmDialog(
  BuildContext context,
  SudokuViewModel vm,
  Difficulty difficulty,
) {
  showGameDialog(
    context: context,
    child: GameDialog(
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      title: "Start New Game?",
      description: "Your progress will be lost.",
      actions: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButton(
            text: "Start New",
            onPressed: () {
              Navigator.pop(context);
              vm.clearSavedGame();
              vm.newGame(difficulty);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SudokuScreen()),
              );
            },
          ),
        ),
      ],
    ),
  );
}

