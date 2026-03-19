import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/view/sudoku_screen.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';

void showDifficultyBottomSheet(BuildContext context) {
  final vm = context.read<SudokuViewModel>();

  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context){
        return Padding(
            padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Difficulty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20,),
              _buildOption(context, "Easy", (){
                Navigator.pop(context);
                vm.newGame(Difficulty.easy);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SudokuScreen()));
              }),
              _buildOption(context, "Medium", (){
                Navigator.pop(context);
                vm.newGame(Difficulty.medium);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SudokuScreen()));
              }),
              _buildOption(context, "Hard", (){
                Navigator.pop(context);
                vm.newGame(Difficulty.hard);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SudokuScreen()));
              })
            ],
          ),
        );
      }
  );
}

Widget _buildOption(BuildContext context, String title, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onTap, child: Text(title)),
    ),
  );
}
