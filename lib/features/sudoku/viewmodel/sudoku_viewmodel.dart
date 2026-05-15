import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_app/features/services/sudoku_generator.dart';
import 'package:sudoku_app/features/services/sudoku_solver.dart';

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
  int hintsLeft = 5;
  final int maxHints = 5;

  bool isResumedGame = false;
  bool isPencilMode = false;
  bool isGameOver = false;
  bool isGameWon = false;
  bool _isTimerRunning = false;
  bool isPaused = false;
  bool showBoardAnimation = false;

  Timer? _timer;
  Difficulty? currentDifficulty;
  int _seconds = 0;
  int get seconds => _seconds;

  String get formattedTime{
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (_seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  String get difficultyText {
    switch (currentDifficulty) {
      case Difficulty.easy:
        return "Easy";
      case Difficulty.medium:
        return "Medium";
      case Difficulty.hard:
        return "Hard";
      default:
        return "Easy";
    }
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

  void giveHint() {
    if (selectedRow == -1 || selectedCol == -1) return;

    if(isFixedCell[selectedRow][selectedCol]) return;

    if(hintsLeft <= 0) return;

    if (board[selectedRow][selectedCol] != 0) return;

    board[selectedRow][selectedCol] = solution[selectedRow][selectedCol];
    hintsLeft--;
    saveGame();
    notifyListeners();
  }

  void togglePencil() {
    isPencilMode = !isPencilMode;
    notifyListeners();
  }

  void erase() {
    if (selectedRow == -1 || selectedCol == -1) return;
    if(isFixedCell[selectedRow][selectedCol]) return;

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
    if(isFixedCell[row][col]) return;
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

  void startTimer() {
    if (_isTimerRunning) return;

    _isTimerRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      saveGame();
      notifyListeners();
    });
  }

  void stopTimer(){
    _timer?.cancel();
    _isTimerRunning = false;
  }

  void resetTimer(){
    _timer?.cancel();
    _seconds = 0;
    _isTimerRunning = false;
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  void newGame(Difficulty difficulty){
    showBoardAnimation = false;
    hintsLeft =maxHints;
    isResumedGame = false;
    currentDifficulty = difficulty;
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
    await prefs.setString("difficulty", currentDifficulty?.name ?? "easy");
    await prefs.setBool("isPaused", isPaused);
    await prefs.setInt("hintsLeft", hintsLeft);

    List<List<List<int>>> notesList = notes
      .map((row) => row.map((cell) => cell.toList()).toList())
      .toList();

    await prefs.setString("notes", jsonEncode(notesList));
  }

  Future<bool> loadGame() async {
    final prefs = await SharedPreferences.getInstance();

    final boardData = prefs.getString("board");
    if (boardData == null) return false;
    isResumedGame = true;
    isPaused = prefs.getBool("isPaused") ?? false;
    hintsLeft = prefs.getInt("hintsLeft") ?? 5;
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

    final diffString = prefs.getString("difficulty");

    if (diffString != null) {
      currentDifficulty = Difficulty.values.firstWhere(
            (e) => e.name == diffString,
        orElse: () => Difficulty.easy,
      );
    }

    notifyListeners();
    //startTimer();
    return true;
  }

  void pauseGame() {
    if (!_isTimerRunning) return;
    stopTimer();
    isPaused = true;
    saveGame();
    notifyListeners();
  }

  void resumeGame() {
    if(isPaused) {
      startTimer();
      isPaused = false;
      notifyListeners();
    }
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

  int getRemainingCount(int number) {
    int count = 0;

    for(var row in board) {
      count += row.where((cell) => cell == number).length;
    }

    return 9 - count;
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

  void startBoardAnimation() {
    showBoardAnimation = true;
    notifyListeners();
  }

  void hideBoardAnimation() {
    showBoardAnimation = false;
    notifyListeners();
  }
}
