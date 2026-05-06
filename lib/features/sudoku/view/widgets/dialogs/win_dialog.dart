import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/home/widgets/primary_button.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/dialog_service.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/game_dialog.dart';

void showWinDialog(BuildContext context, String time) {
  showGameDialog(
    context: context,
    child: GameDialog(
      icon: Icons.emoji_events,
      iconColor: Colors.orange,
      title: "Congratulations!",
      description: "You solved the puzzle!",
      extraContent: Text(
        "Time: $time",
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        Expanded(
          child: PrimaryButton(
            text: "Back to Home",
            onPressed: () {
              final vm = context.read<SudokuViewModel>();
              vm.isGameWon = false;

              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}