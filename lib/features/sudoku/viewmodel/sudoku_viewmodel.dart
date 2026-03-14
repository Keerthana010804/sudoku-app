import 'dart:async';
import 'package:flutter/material.dart';

class SudokuViewModel extends ChangeNotifier {

  SudokuViewModel() {
    startTimer();
  }

  List<List<int>> board = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  List<List<int>> solution = [
    [5,3,4,6,7,8,9,1,2],
    [6,7,2,1,9,5,3,4,8],
    [1,9,8,3,4,2,5,6,7],
    [8,5,9,7,6,1,4,2,3],
    [4,2,6,8,5,3,7,9,1],
    [7,1,3,9,2,4,8,5,6],
    [9,6,1,5,3,7,2,8,4],
    [2,8,7,4,1,9,6,3,5],
    [3,4,5,2,8,6,1,7,9],
  ];

  List<List<bool>> isFixedCell = [
    [true, true, false, false, true, false, false, false, false],
    [true, false, false, true, true, true, false, false, false],
    [false, true, true, false, false, false, false, true, false],
    [true, false, false, false, true, false, false, false, true],
    [true, false, false, true, false, true, false, false, true],
    [true, false, false, false, true, false, false, false, true],
    [false, true, false, false, false, false, true, true, false],
    [false, false, false, true, true, true, false, false, true],
    [false, false, false, false, true, false, false, true, true],
  ];

  int selectedRow = -1;
  int selectedCol = -1;

  bool isPencilMode = false;

  Timer? _timer;
  int _seconds = 0;
  int get seconds => _seconds;

  String get formattedTime{
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (_seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  bool isPuzzleSolved(){
    for (var row in board) {
      if (row.contains(0)) return false;
    }
    return true;
  }

  List<Map<String, int>> moveHistory = [];

  List<List<Set<int>>> notes = List.generate(
    9,
    (_) => List.generate(9, (_) => <int>{}),
  );

  void selectedCell(int row, int col) {
    if (isFixedCell[row][col]) return;
    selectedRow = row;
    selectedCol = col;
    notifyListeners();
  }

  bool isValidMove(int row, int col, int number) {
    // check row
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == number && i != col) {
        return false;
      }
    }
    //check col
    for (int j = 0; j < 9; j++) {
      if (board[j][col] == number && j != row) {
        return false;
      }
    }
    //check 3x3 box
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;

    for (int r = startRow; r < startRow + 3; r++) {
      for (int c = startCol; c < startCol + 3; c++) {
        if (board[r][c] == number && (r != row || c != col)) {
          return false;
        }
      }
    }
    return true;
  }

  bool solveSudoku(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isValidMove(row, col, num)) {
              board[row][col] = num;
              if (solveSudoku(board)) {
                return true;
              }
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  void giveHint() {
    if (selectedRow == -1 || selectedCol == -1) return;

    if (board[selectedRow][selectedCol] != 0) return;

    board[selectedRow][selectedCol] = solution[selectedRow][selectedCol];
  }

  void togglePencil() {
    isPencilMode = !isPencilMode;
    notifyListeners();
  }

  void erase() {
    if (selectedRow == -1 || selectedCol == -1) return;

    int previousValue = board[selectedRow][selectedCol];
    if (previousValue != 0) {
      moveHistory.add({
        "row": selectedRow,
        "col": selectedCol,
        "value": previousValue,
      });
    }
    board[selectedRow][selectedCol] = 0;
    notifyListeners();
  }

  void undo() {
    if (moveHistory.isEmpty) return;

    var lastMove = moveHistory.removeLast();

    int row = lastMove["row"]!;
    int col = lastMove["col"]!;
    int value = lastMove["value"]!;

    board[row][col] = value;

    notifyListeners();
  }

  bool enterNumber(int number) {
    if (selectedRow == -1 || selectedCol == -1) return true;

    if (isPencilMode) {
      if (notes[selectedRow][selectedCol].contains(number)) {
        notes[selectedRow][selectedCol].remove(number);
      } else {
        notes[selectedRow][selectedCol].add(number);
      }
      notifyListeners();
      return true;
    }
    int previousValue = board[selectedRow][selectedCol];

    if (isValidMove(selectedRow, selectedCol, number)) {
      moveHistory.add({
        "row": selectedRow,
        "col": selectedCol,
        "value": previousValue,
      });
      board[selectedRow][selectedCol] = number;
      notes[selectedRow][selectedCol].clear();
      if (isPuzzleSolved()){
        stopTimer();
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void startTimer(){
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      _seconds++;
      notifyListeners();
    });
  }

  void stopTimer(){
    _timer?.cancel();
  }

  void resetTimer(){
    _timer?.cancel();
    _seconds = 0;
    startTimer();
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }
}
