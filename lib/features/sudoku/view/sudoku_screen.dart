import 'package:flutter/material.dart';
import 'package:sudoku_app/features/sudoku/widgets/difficulty_bottom_sheet.dart';
import 'package:sudoku_app/features/sudoku/widgets/number_pad.dart';
import 'package:sudoku_app/features/sudoku/widgets/sudoku_grid.dart';
import 'package:sudoku_app/features/sudoku/widgets/tool_bar.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:provider/provider.dart';

class SudokuScreen extends StatelessWidget {
  const SudokuScreen({super.key});

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
                const SizedBox(width: 8,),
                Text(
                  vm.formattedTime,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10,),

            ElevatedButton(onPressed: (){
              showDifficultyBottomSheet(context);
            },
                child: Text("New Game"),
            ),

            const SizedBox(height: 20,),

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
            ),

            const SizedBox(height: 20),

            NumberPad(
              onNumberTap: (number) {
                bool valid = vm.enterNumber(number);

                if (!valid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid Move!"),
                      duration: Duration(seconds: 2),
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
