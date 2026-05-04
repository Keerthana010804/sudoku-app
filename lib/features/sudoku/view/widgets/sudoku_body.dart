import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/splash/widgets/background_pattern.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/dialogs/game_over_dialog.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/dialogs/win_dialog.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/number_pad_section.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/pause_overlay.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/time_view.dart';
import 'package:sudoku_app/features/sudoku/widgets/sudoku_grid.dart';
import 'package:sudoku_app/features/sudoku/widgets/tool_bar.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

class SudokuBody extends StatelessWidget {
  const SudokuBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.isGameOver) {
        vm.isGameOver = false;
        showGameOverDialog(context);
      }
      if (vm.isGameWon) {
        vm.isGameWon = false;
        showWinDialog(context, vm.formattedTime);
      }
    });

    return Stack(
      children: [
        /// 🔹 Background (same as Home)
        const BackgroundPattern(),

        /// 🔹 Main Content
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.2),
                  blurRadius: 25,
                  spreadRadius: 1,
                ),
              ],
            ),

            child: Column(
              children: [
                /// 🔹 Timer Card
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TimeView(),
                ),

                const SizedBox(height: 20),

                /// 🔹 Sudoku Grid
                Flexible(
                  child: Center(
                    child: FittedBox(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        height: MediaQuery.of(context).size.width - 80,
                        child: SudokuGrid(
                          board: vm.board,
                          notes: vm.notes,
                          selectedRow: vm.selectedRow,
                          selectedCol: vm.selectedCol,
                          onCellTap: vm.isPaused
                              ? (_, __) {}
                              : (row, col) {
                            vm.selectedCell(row, col);
                          },
                          isFixedCell: vm.isFixedCell,
                          selectedNumber: vm.selectedNumber,
                          errorCells: vm.errorCells,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 Toolbar
                ToolBar(
                  onUndo: vm.isPaused ? () {} : vm.undo,
                  onErase: vm.isPaused ? () {} : vm.erase,
                  onPencil: vm.isPaused ? () {} : vm.togglePencil,
                  onHint: vm.isPaused ? () {} : vm.giveHint,
                  isPencilMode: vm.isPencilMode,
                ),

                const SizedBox(height: 20),

                /// 🔹 Number Pad
                const NumberPadSection(),
              ],
            ),
          ),
        ),

        /// 🔹 Pause Overlay
        if (vm.isPaused) const PauseOverlay(),
      ],
    );
  }
}