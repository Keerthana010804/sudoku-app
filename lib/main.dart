import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/view/sudoku_screen.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
        create: (_) => SudokuViewModel(),
      child: SudokuApp(),
    )
  );
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku App',
      home: SudokuScreen(),
    );
  }
}
