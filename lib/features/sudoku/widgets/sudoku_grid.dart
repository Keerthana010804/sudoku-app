import 'package:flutter/material.dart';

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
            return InkWell(
              borderRadius: BorderRadius.circular(4),
              splashColor: Colors.blue.withValues(alpha: 0.2),
              highlightColor: Colors.transparent,
              onTap: () => onCellTap(row, col),
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
                            color: isFixedCell[row][col]
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
                                        notes[row][col].contains(n)
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
          },
        ),
      ),
    );
  }
}
