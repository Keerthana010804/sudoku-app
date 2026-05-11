import 'package:flutter/material.dart';

class SudokuCell extends StatefulWidget {
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
  final bool showAnimation;
  final int animationDelay;

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
    required this.showAnimation,
    required this.animationDelay,
  });

  @override
  State<SudokuCell> createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell>
    with SingleTickerProviderStateMixin{
  Color getCellColor(int row, int col) {
    // ❌ Error
    if (widget.errorCells.contains("$row-$col")) {
      return Colors.red.withOpacity(0.35);
    }

    // 🟢 Same number highlight
    if (widget.selectedNumber != null && widget.board[row][col] == widget.selectedNumber) {
      return Colors.green.withOpacity(0.25);
    }

    if (widget.selectedRow == -1 || widget.selectedCol == -1) {
      return Colors.white.withOpacity(0.08);
    }

    // 🎯 Selected cell
    if (row == widget.selectedRow && col == widget.selectedCol) {
      return Colors.orange.withOpacity(0.35);
    }

    int selectedValue = widget.board[widget.selectedRow][widget.selectedCol];

    // 🟢 Same value
    if (selectedValue != 0 && widget.board[row][col] == selectedValue) {
      return Colors.green.withOpacity(0.25);
    }

    // 🔵 Row / Column / Box highlight
    if (row == widget.selectedRow ||
        col == widget.selectedCol ||
        ((row ~/ 3 == widget.selectedRow ~/ 3) &&
            (col ~/ 3 == widget.selectedCol ~/ 3))) {
      return Colors.blue.withOpacity(0.08);
    }

    return Colors.white.withOpacity(0.08);
  }

  bool visible = false;

  @override
  void initState() {
    super.initState();

    // Fixed cells start hidden
    if (widget.isFixed && widget.value != 0) {
      visible = false;
    } else {
      // Player cells remain visible
      visible = true;
    }
  }

  @override
  void didUpdateWidget(covariant SudokuCell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showAnimation &&
        !oldWidget.showAnimation &&
        widget.isFixed &&
        widget.value != 0) {

      setState(() {
        visible = false;
      });

      Future.delayed(
        Duration(milliseconds: widget.animationDelay),
            () {
          if (mounted) {
            setState(() {
              visible = true;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cellSize = constraints.maxWidth;

      final mainFontSize = cellSize * 0.5;
      final noteFontSize = cellSize * 0.22;
      return InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: getCellColor(widget.row, widget.col),
            border: Border(
              top: BorderSide(
                color: Colors.black38,
                width: widget.row % 3 == 0 ? 2 : 0.5,
              ),
              left: BorderSide(
                color: Colors.black38,
                width: widget.col % 3 == 0 ? 2 : 0.5,
              ),
              right: BorderSide(
                color: Colors.black38,
                width: (widget.col + 1) % 3 == 0 ? 2 : 0.5,
              ),
              bottom: BorderSide(
                color: Colors.black38,
                width: (widget.row + 1) % 3 == 0 ? 2 : 0.5,
              ),
            ),
          ),

          child: widget.value != 0
              ? widget.isFixed
              ? AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: visible ? 1 : 0,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 180),
              scale: visible ? 1 : 0.3,
              child: Center(
                child: Text(
                  widget.value.toString(),
                  style: TextStyle(
                    fontSize: mainFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          )
              : Center(
            child: Text(
              widget.value.toString(),
              style: TextStyle(
                fontSize: mainFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
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
                            widget.notes.contains(n) ? n.toString() : "",
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