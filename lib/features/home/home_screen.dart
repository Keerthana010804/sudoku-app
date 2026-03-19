import 'package:flutter/material.dart';
import 'package:sudoku_app/features/sudoku/widgets/difficulty_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sudoku"), centerTitle: true),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          onPressed: () {
            showDifficultyBottomSheet(context);
          },
          child: const Text("New Game"),
        ),
      ),
    );
  }
}
