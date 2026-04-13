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
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 81,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemBuilder: (context, index) {
            int row = index ~/ 9;
            int col = index % 9;

            int value = board[row][col];
            return SudokuCell(
                row: row,
                col: col,
                value: value,
                notes: notes[row][col],
                isFixed: isFixedCell[row][col],
                isSelected: row == selectedRow && col == selectedCol,
                selectedRow: selectedRow,
                selectedCol: selectedCol,
                errorCells: errorCells,
                board: board,
                onTap: () => onCellTap(row,col),
            );
          },
        ),
      ),
    );
  }
}
