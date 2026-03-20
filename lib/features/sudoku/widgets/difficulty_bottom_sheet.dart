import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/view/sudoku_screen.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

void showDifficultyBottomSheet(BuildContext context) {
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
            const SizedBox(height: 15,),
            const Text(
              "Select Difficulty",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildOption(
              context,
              "Easy",
              Colors.green,
              Icons.sentiment_satisfied,
              () {
                Navigator.pop(context);
                vm.newGame(Difficulty.easy);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SudokuScreen()),
                );
              },
            ),
            _buildOption(
              context,
              "Medium",
              Colors.orange,
              Icons.sentiment_neutral,
              () {
                Navigator.pop(context);
                vm.newGame(Difficulty.medium);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SudokuScreen()),
                );
              },
            ),
            _buildOption(
              context,
              "Hard",
              Colors.red,
              Icons.sentiment_very_dissatisfied,
              () {
                Navigator.pop(context);
                vm.newGame(Difficulty.hard);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SudokuScreen()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
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
