import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Difficulty{ easy, medium, hard }

class SudokuViewModel extends ChangeNotifier {

  SudokuViewModel();

  List<List<int>> board =
    List.generate(9, (_) => List.generate(9, (_) => 0));

  List<List<int>> solution =
  List.generate(9, (_) => List.generate(9, (_) => 0));

  List<List<bool>> isFixedCell =
  List.generate(9, (_) => List.generate(9, (_) => false));

  int selectedRow = -1;
  int selectedCol = -1;
  int? selectedNumber;
  int mistakes = 0;
  final int maxMistakes = 3;

  bool isPencilMode = false;
  bool isGameOver = false;
  bool isGameWon = false;

  Timer? _timer;
  int _seconds = 0;
  int get seconds => _seconds;

  String get formattedTime{
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (_seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  Set<String> errorCells = {};

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
    selectedRow = row;
    selectedCol = col;
    if (!isFixedCell[row][col]) {
      selectedNumber = null;
    }
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
    saveGame();
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
        "mistakes": mistakes,
      });
    }
    board[selectedRow][selectedCol] = 0;
    notes[selectedRow][selectedCol].clear();
    saveGame();
    notifyListeners();
  }

  void undo() {
    if (moveHistory.isEmpty) return;

    var lastMove = moveHistory.removeLast();

    int row = lastMove["row"]!;
    int col = lastMove["col"]!;
    int value = lastMove["value"]!;
    int prevMistakes = lastMove["mistakes"] ?? mistakes;

    board[row][col] = value;
    mistakes = prevMistakes;
    saveGame();

    notifyListeners();
  }

  bool enterNumber(int number) {
    if (selectedRow == -1 || selectedCol == -1) return true;
    if (isFixedCell[selectedRow][selectedCol]) return false;
    if (isPencilMode) {
      if (notes[selectedRow][selectedCol].contains(number)) {
        notes[selectedRow][selectedCol].remove(number);
      } else {
        notes[selectedRow][selectedCol].add(number);
      }
      saveGame();
      notifyListeners();
      return true;
    }
    int previousValue = board[selectedRow][selectedCol];

    if (isValidMove(board, selectedRow, selectedCol, number)) {
      moveHistory.add({
        "row": selectedRow,
        "col": selectedCol,
        "value": previousValue,
        "mistakes": mistakes,
      });
      board[selectedRow][selectedCol] = number;
      notes[selectedRow][selectedCol].clear();
      removeNotes(selectedRow, selectedCol, number);
      saveGame();
      if (isPuzzleSolved()){
        isGameWon = true;
        stopTimer();
        clearSavedGame();
        notifyListeners();
        return true;
      }
      notifyListeners();
      return true;
    } else {
      mistakes++;
      if(mistakes >= maxMistakes) {
        isGameOver = true;
        stopTimer();
      }
      errorCells.add("$selectedRow-$selectedCol");
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 500), (){
        errorCells.remove("$selectedRow-$selectedCol");
        notifyListeners();
      });
      return false;
    }
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
    selectedNumber = null;
    mistakes = 0;
    isGameOver = false;
    isGameWon = false;
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

  int countSolutions(List<List<int>> board) {
    int count = 0;

    bool solve(List<List<int>> b) {
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if (b[row][col] == 0) {
            for (int num = 1; num <= 9; num++){
              if (isValidMove(b, row, col, num)) {
                b[row][col] = num;
                if (solve(b)) return true;
                b[row][col] = 0;
              }
            }
            return false;
          }
        }
      }
      count++;
      return false;
    }

    List<List<int>> temp =
        board.map((row) => List<int>.from(row)).toList();
    solve(temp);
    return count;
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
        int backup = board[row][col];
        board[row][col] = 0;
        int solutions = countSolutions(board);
        if(solutions != 1) {
          board[row][col] = backup;
        } else {
          removeCount--;
        }
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

  Future<void> saveGame() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("board", jsonEncode(board));
    await prefs.setString("solution", jsonEncode(solution));
    await prefs.setString("fixed", jsonEncode(isFixedCell));
    await prefs.setInt("seconds", _seconds);
    await prefs.setInt("mistakes", mistakes);

    List<List<List<int>>> notesList = notes
      .map((row) => row.map((cell) => cell.toList()).toList())
      .toList();

    await prefs.setString("notes", jsonEncode(notesList));
  }

  Future<bool> loadGame() async {
    final prefs = await SharedPreferences.getInstance();

    final boardData = prefs.getString("board");
    if (boardData == null) return false;

    board = (jsonDecode(boardData) as List)
      .map((row) => List<int>.from(row))
      .toList();

    solution = (jsonDecode(prefs.getString("solution")!) as List)
      .map((row) => List<int>.from(row))
      .toList();

    isFixedCell = (jsonDecode(prefs.getString("fixed")!) as List)
      .map((row) => List<bool>.from(row))
      .toList();

    _seconds = prefs.getInt("seconds") ?? 0;
    mistakes = prefs.getInt("mistakes") ?? 0;

    final notesString = prefs.getString("notes");

    if(notesString != null) {
      List notesData = jsonDecode(notesString);
      notes = notesData
          .map<List<Set<int>>>((row) =>
          (row as List)
              .map<Set<int>>((cell) => Set<int>.from(cell))
              .toList())
          .toList();
    }

    notifyListeners();
    startTimer();
    return true;
  }

  Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("board") != null;
  }

  Future<void> clearSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void selectNumber(int number) {
    selectedNumber = number;
    notifyListeners();
  }

  void clearSelection() {
    selectedNumber = null;
    notifyListeners();
  }

  void removeNotes(int row, int col, int number) {
    // remove from row
    for (int c = 0; c < 9; c++) {
      notes[row][c].remove(number);
    }
    // remove from column
    for (int r = 0; r < 9; r++) {
      notes[r][col].remove(number);
    }
    // remove from 3x3 box
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;

    for (int r = startRow; r < startRow + 3; r++){
      for (int c = startCol; c < startCol + 3; c++) {
        notes[r][c].remove(number);
      }
    }
  }
}
