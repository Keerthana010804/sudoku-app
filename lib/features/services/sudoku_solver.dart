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