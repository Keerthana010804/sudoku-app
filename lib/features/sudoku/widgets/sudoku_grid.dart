import 'package:flutter/material.dart';

class SudokuGrid extends StatelessWidget {
  final List<List<int>> board;
  final List<List<Set<int>>> notes;
  final int selectedRow;
  final int selectedCol;
  final Function(int, int) onCellTap;
  final List<List<bool>> isFixedCell;

  const SudokuGrid({
    super.key,
    required this.board,
    required this.notes,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
    required this.isFixedCell,
  });

  Color getCellColor(int row, int col){
    // if no cell selected
    if (selectedRow == -1 || selectedCol == -1) {
      return Colors.white;
    }
    // selected cell
    if (row == selectedRow && col == selectedCol){
      return Colors.blue.withValues(alpha: 0.3);
    }
    // same row
    if (row == selectedRow){
      return Colors.blue.withValues(alpha: 0.1);
    }
    // same column
    if (col == selectedCol){
      return Colors.blue.withValues(alpha: 0.1);
    }
    // same 3x3 box
    if ((row ~/ 3 == selectedRow ~/ 3) &&
        (col ~/ 3 == selectedCol ~/ 3)) {
      return Colors.blue.withValues(alpha: 0.1);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            return GestureDetector(
              onTap: () => onCellTap(row,col),
              child: Container(
                  decoration: BoxDecoration(
                    color: getCellColor(row, col),
                    border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: row % 3 == 0 ? 2 : 0.5,
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: col % 3 == 0 ? 2 : 0.5,
                      ),
                      right: BorderSide(
                        color: Colors.black,
                        width: (col + 1) % 3 == 0 ? 2 : 0.5,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: (row + 1) % 3 == 0 ? 2 : 0.5,
                      ),
                    ),
                  ),
                  child: value != 0
                      ? Center(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isFixedCell[row][col] ? Colors.black : Colors.blue,
                      ),
                    ),
                  )
                      : GridView.count(
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(9, (i){
                      int n = i + 1;
                      return Center(
                        child: Text(
                          notes[row][col].contains(n) ? n.toString() : "",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black87
                          ),
                        ),
                      );
                    }
                    ),
                  )
              ),
            );
          },
        ),
      ),
    );
  }
}
