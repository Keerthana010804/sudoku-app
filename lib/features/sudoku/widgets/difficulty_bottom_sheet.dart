import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/view/sudoku_screen.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/dialogs/confirm_dialog.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

void showDifficultyBottomSheet(BuildContext context) {
  final parentContext = context;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final vm = context.read<SudokuViewModel>();

      int? selectedIndex;

      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> onSelect(int index,Difficulty difficulty) async {
            if (selectedIndex != null) return;

            setState(() => selectedIndex = index);
            await Future.delayed(const Duration(milliseconds: 400));

            await handleDifficultySelection(
              parentContext: parentContext,
              sheetContext: context,
              vm: vm,
              difficulty: difficulty,
            );
          }

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Select Difficulty",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Choose your challenge level",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 25),

                    _buildOption(
                      context,
                      "Easy",
                      "Perfect for beginners",
                      Icons.sentiment_satisfied_outlined,
                      selectedIndex == 0,
                          () => onSelect(0, Difficulty.easy),
                    ),

                    _buildOption(
                      context,
                      "Medium",
                      "Balanced challenge",
                      Icons.sentiment_neutral,
                      selectedIndex == 1,
                          () => onSelect(1, Difficulty.medium),
                    ),

                    _buildOption(
                      context,
                      "Hard",
                      "For Sudoku masters",
                      Icons.sentiment_very_dissatisfied,
                      selectedIndex == 2,
                          () => onSelect(2, Difficulty.hard),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
    showNewGameConfirmDialog(parentContext, vm, difficulty);
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
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: AbsorbPointer(
      absorbing: isSelected, // only selected blocks itself
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            // 🔥 Highlight selected card
            gradient: isSelected
                ? const LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
            )
                : null,

            color: isSelected
                ? null
                : Colors.white.withOpacity(0.05),

            border: Border.all(
              color: isSelected ? Colors.orangeAccent : Colors.white24,
            ),

            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              // Icon / Loader
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
                ),
                child: isSelected
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Icon(icon, color: Colors.orange),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white70
                            : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              if (!isSelected)
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.white38),
            ],
          ),
        ),
      ),
    ),
  );
}
