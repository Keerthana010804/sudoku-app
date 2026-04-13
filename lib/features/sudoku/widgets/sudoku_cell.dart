import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  final int row;
  final int col;
  final int value;
  final Set<int> notes;
  final bool isFixed;
  final bool isSelected;
  final int selectedRow;
  final int selectedCol;
  final int? selectedNumber;
  final Set<String> errorCells;
  final List<List<int>> board;
  final VoidCallback onTap;

  const SudokuCell({
    super.key,
    required this.row,
    required this.col,
    required this.value,
    required this.notes,
    required this.isFixed,
    required this.isSelected,
    required this.selectedRow,
    required this.selectedCol,
    this.selectedNumber,
    required this.errorCells,
    required this.board,
    required this.onTap,
  });

  Color getCellColor(int row, int col) {
    // errorCell highlight
    if (errorCells.contains("$row-$col")) {
      return Colors.red.withValues(alpha: 0.4);
    }
    // if number is selected
    if (selectedNumber != null) {
      if (board[row][col] == selectedNumber) {
        return Colors.green.withValues(alpha: 0.3);
      }
      return Colors.white;
    }
    // if no cell selected
    if (selectedRow == -1 || selectedCol == -1) {
      return Colors.white;
    }
    // selected cell
    if (row == selectedRow && col == selectedCol) {
      return Colors.blue.withValues(alpha: 0.3);
    }
    // highLight selected numbers
    int selectedValue = board[selectedRow][selectedCol];
    if (selectedValue != 0 && board[row][col] == selectedValue) {
      return Colors.green.withValues(alpha: 0.3);
    }
    // same row
    if (row == selectedRow) {
      return Colors.blue.withValues(alpha: 0.08);
    }
    // same column
    if (col == selectedCol) {
      return Colors.blue.withValues(alpha: 0.08);
    }
    // same 3x3 box
    if ((row ~/ 3 == selectedRow ~/ 3) && (col ~/ 3 == selectedCol ~/ 3)) {
      return Colors.blue.withValues(alpha: 0.08);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      splashColor: Colors.blue.withValues(alpha: 0.2),
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: getCellColor(row, col),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade800,
              width: row % 3 == 0 ? 2 : 0.5,
            ),
            left: BorderSide(
              color: Colors.grey.shade800,
              width: col % 3 == 0 ? 2 : 0.5,
            ),
            right: BorderSide(
              color: Colors.grey.shade800,
              width: (col + 1) % 3 == 0 ? 2 : 0.5,
            ),
            bottom: BorderSide(
              color: Colors.grey.shade800,
              width: (row + 1) % 3 == 0 ? 2 : 0.5,
            ),
          ),
        ),
        child: value != 0
            ? Center(
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isFixed
                  ? Colors.black
                  : Colors.blue,
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: List.generate(3, (r) {
              return Expanded(
                child: Row(
                  children: List.generate(3, (c) {
                    int n = r * 3 + c + 1;
                    return Expanded(
                      child: Center(
                        child: Text(
                          notes.contains(n)
                              ? n.toString()
                              : "",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
