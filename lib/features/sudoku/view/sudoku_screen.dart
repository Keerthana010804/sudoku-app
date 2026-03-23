import 'package:flutter/material.dart';
import 'package:sudoku_app/features/sudoku/widgets/number_pad.dart';
import 'package:sudoku_app/features/sudoku/widgets/sudoku_grid.dart';
import 'package:sudoku_app/features/sudoku/widgets/tool_bar.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:provider/provider.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  @override
  void initState(){
    super.initState();

    Future.microtask(() async {
      final vm = context.read<SudokuViewModel>();
      await vm.loadGame();
    });
  }
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Sudoku"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer),
                const SizedBox(width: 8),
                Text(
                  vm.formattedTime,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SudokuGrid(
                board: vm.board,
                notes: vm.notes,
                selectedRow: vm.selectedRow,
                selectedCol: vm.selectedCol,
                onCellTap: (row, col) {
                  vm.selectedCell(row, col);
                },
                isFixedCell: vm.isFixedCell,
              ),
            ),

            const SizedBox(height: 20),

            ToolBar(
              onUndo: vm.undo,
              onErase: vm.erase,
              onPencil: vm.togglePencil,
              onHint: vm.giveHint,
              isPencilMode: vm.isPencilMode,
            ),

            const SizedBox(height: 20),

            NumberPad(
              onNumberTap: (number) {
                bool isValid = vm.enterNumber(number);

                if (!isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid Move!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                if (vm.isPuzzleSolved()) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text("🎉 Congratulations!"),
                      content: Text(
                        "You solved the puzzle!\nTime: ${vm.formattedTime}",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext); // close dialog
                            Navigator.pop(context); // go back to HomeScreen
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
