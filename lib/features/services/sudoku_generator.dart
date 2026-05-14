import 'dart:math';
import 'package:sudoku_app/features/services/sudoku_solver.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

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