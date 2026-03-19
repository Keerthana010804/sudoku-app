import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

enum Difficulty{ easy, medium, hard }

class SudokuViewModel extends ChangeNotifier {

  SudokuViewModel() {
    startTimer();
  }

  List<List<int>> board =
    List.generate(9, (_) => List.generate(9, (_) => 0));

  List<List<int>> solution =
  List.generate(9, (_) => List.generate(9, (_) => 0));

  List<List<bool>> isFixedCell =
  List.generate(9, (_) => List.generate(9, (_) => false));

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

  bool isValidMove(List<List<int>> board, int row, int col, int number) {
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
            if (isValidMove(board, row, col, num)) {
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
    notifyListeners();
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

    if (isValidMove(board, selectedRow, selectedCol, number)) {
      moveHistory.add({
        "row": selectedRow,
        "col": selectedCol,
        "value": previousValue,
      });
      board[selectedRow][selectedCol] = number;
      notes[selectedRow][selectedCol].clear();
      if (isPuzzleSolved()){
        stopTimer();
        notifyListeners();
        return true;
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

  void newGame(Difficulty difficulty){
    List<List<int>> newBoard =
        List.generate(9, (_) => List.generate(9, (_) => 0));
    fillBoard(newBoard);
    solution = newBoard.map((row) => List<int>.from(row)).toList();
    removeNumbers(newBoard, difficulty);
    board = newBoard.map((row) => List<int>.from(row)).toList();
    generateFixedCells();
    moveHistory.clear();
    notes = List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
    );
    selectedRow = -1;
    selectedCol = -1;
    resetTimer();
    notifyListeners();
  }

  bool fillBoard(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++){
        if (board[row][col] == 0) {
          List<int> numbers = List.generate(9, (i) => i + 1);
          numbers.shuffle();
          for (int num in numbers) {
            if (isValidMove(board, row, col, num)) {
              board[row][col] = num;
              if (fillBoard(board)) return true;
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  void removeNumbers(List<List<int>> board, Difficulty difficulty) {
    int removeCount;

    switch (difficulty) {
      case Difficulty.easy:
        removeCount = 30;
        break;
      case Difficulty.medium:
        removeCount = 40;
        break;
      case Difficulty.hard:
        removeCount = 50;
        break;
    }

    while (removeCount > 0){
      int row = Random().nextInt(9);
      int col = Random().nextInt(9);

      if (board[row][col] != 0) {
        board[row][col] = 0;
        removeCount--;
      }
    }
  }

  void generateFixedCells(){
    isFixedCell = List.generate(
        9,
        (row) => List.generate(
            9,
            (col) => board[row][col] != 0,
        )
    );
  }
}
