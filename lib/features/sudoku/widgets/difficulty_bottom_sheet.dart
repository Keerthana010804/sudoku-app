import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/view/sudoku_screen.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

void showDifficultyBottomSheet(BuildContext context) {
  final parentContext = context;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final vm = context.read<SudokuViewModel>();
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Select Difficulty",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildOption(
              context,
              "Easy",
              Colors.green,
              Icons.sentiment_satisfied_outlined,
              () async {
                await handleDifficultySelection(
                    parentContext: parentContext,
                    sheetContext: context, vm: vm,
                    difficulty: Difficulty.easy
                );
              },
            ),
            _buildOption(
              context,
              "Medium",
              Colors.orange,
              Icons.sentiment_neutral,
              () async {
                await handleDifficultySelection(
                    parentContext: parentContext,
                    sheetContext: context, vm: vm,
                    difficulty: Difficulty.medium,
                );
              },
            ),
            _buildOption(
              context,
              "Hard",
              Colors.red,
              Icons.sentiment_very_dissatisfied,
              () async {
                await handleDifficultySelection(
                    parentContext: parentContext,
                    sheetContext: context, vm: vm,
                    difficulty: Difficulty.hard,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> handleDifficultySelection({
  required BuildContext parentContext,
  required BuildContext sheetContext,
  required SudokuViewModel vm,
  required Difficulty difficulty,
}) async {
  final hasGame = await vm.hasSavedGame();

  Navigator.pop(sheetContext);

  if (hasGame) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Start New Game?"),
        content: const Text(
          "Your current progress will be lost.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              vm.clearSavedGame();
              vm.newGame(difficulty);
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                  builder: (_) => const SudokuScreen(),
                ),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  } else {
    vm.newGame(difficulty);
    Navigator.push(
      parentContext,
      MaterialPageRoute(builder: (_) => const SudokuScreen()),
    );
  }
}

Widget _buildOption(
  BuildContext context,
  String title,
  Color color,
  IconData icon,
  VoidCallback onTap,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    ),
  );
}
