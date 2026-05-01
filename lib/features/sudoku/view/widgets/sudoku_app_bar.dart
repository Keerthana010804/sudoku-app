import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

class SudokuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SudokuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();

    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white70),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Sudoku",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.blueAccent, blurRadius: 6),
          ],
        ),
      ),
      actions: [
        if (!vm.isPaused)
          IconButton(
            icon: const Icon(Icons.pause, color: Colors.white70),
            onPressed: vm.pauseGame,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}