import 'package:flutter/material.dart';
import 'package:sudoku_app/features/sudoku/widgets/sudoku_cell.dart';

class SudokuGrid extends StatelessWidget {
  final List<List<int>> board;
  final List<List<Set<int>>> notes;
  final int selectedRow;
  final int selectedCol;
  final Function(int, int) onCellTap;
  final List<List<bool>> isFixedCell;
  final int? selectedNumber;
  final Set<String> errorCells;
  final bool showAnimation;

  const SudokuGrid({
    super.key,
    required this.board,
    required this.notes,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
    required this.isFixedCell,
    required this.selectedNumber,
    required this.errorCells,
    required this.showAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 81,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 9;
                  int col = index % 9;

                  return SudokuCell(
                    row: row,
                    col: col,
                    value: board[row][col],
                    notes: notes[row][col],
                    isFixed: isFixedCell[row][col],
                    isSelected: row == selectedRow && col == selectedCol,
                    selectedRow: selectedRow,
                    selectedCol: selectedCol,
                    selectedNumber: selectedNumber,
                    errorCells: errorCells,
                    board: board,
                    onTap: () => onCellTap(row, col),
                    animationDelay: (col * 9 + row) * 18,
                    showAnimation: showAnimation,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
