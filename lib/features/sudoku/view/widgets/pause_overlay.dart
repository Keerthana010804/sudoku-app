import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/home/widgets/primary_button.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:sudoku_app/features/sudoku/widgets/dialogs/game_dialog.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SudokuViewModel>();
    return GameDialog(
      icon: Icons.pause_circle,
      iconColor: Colors.orange,
      title: "Game Paused",
      description: "Time: ${vm.formattedTime}",
      actions: [
        Expanded(
          child: PrimaryButton(text: "Resume", onPressed: vm.resumeGame),
        ),
      ],
    );
  }
}
