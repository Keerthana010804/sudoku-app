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
    // ❌ Error
    if (errorCells.contains("$row-$col")) {
      return Colors.red.withOpacity(0.35);
    }

    // 🟢 Same number highlight
    if (selectedNumber != null && board[row][col] == selectedNumber) {
      return Colors.green.withOpacity(0.25);
    }

    if (selectedRow == -1 || selectedCol == -1) {
      return Colors.white.withOpacity(0.08);
    }

    // 🎯 Selected cell
    if (row == selectedRow && col == selectedCol) {
      return Colors.orange.withOpacity(0.35);
    }

    int selectedValue = board[selectedRow][selectedCol];

    // 🟢 Same value
    if (selectedValue != 0 && board[row][col] == selectedValue) {
      return Colors.green.withOpacity(0.25);
    }

    // 🔵 Row / Column / Box highlight
    if (row == selectedRow ||
        col == selectedCol ||
        ((row ~/ 3 == selectedRow ~/ 3) &&
            (col ~/ 3 == selectedCol ~/ 3))) {
      return Colors.blue.withOpacity(0.08);
    }

    return Colors.white.withOpacity(0.08);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cellSize = constraints.maxWidth;

      final mainFontSize = cellSize * 0.5;
      final noteFontSize = cellSize * 0.22;
      return InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: getCellColor(row, col),
            border: Border(
              top: BorderSide(
                color: Colors.black38,
                width: row % 3 == 0 ? 2 : 0.5,
              ),
              left: BorderSide(
                color: Colors.black38,
                width: col % 3 == 0 ? 2 : 0.5,
              ),
              right: BorderSide(
                color: Colors.black38,
                width: (col + 1) % 3 == 0 ? 2 : 0.5,
              ),
              bottom: BorderSide(
                color: Colors.black38,
                width: (row + 1) % 3 == 0 ? 2 : 0.5,
              ),
            ),
          ),

          child: value != 0
              ? Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: mainFontSize,
                fontWeight: FontWeight.bold,
                color: isFixed
                    ? Colors.black54
                    : Colors.orangeAccent,
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
                            notes.contains(n) ? n.toString() : "",
                            style: TextStyle(
                              fontSize: noteFontSize,
                              color: Colors.black38,
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
    );

  }
}