import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Difficulty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20,),
              _builtOption(context, "Easy", (){
                Navigator.pop(context);
                vm.newGame(Difficulty.easy);
              }),
              _builtOption(context, "Medium", (){
                Navigator.pop(context);
                vm.newGame(Difficulty.medium);
              }),
              _builtOption(context, "Hard", (){
                Navigator.pop(context);
                vm.newGame(Difficulty.hard);
              })
            ],
          ),
        );
      }
  );
}

Widget _builtOption(BuildContext context, String title, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onTap, child: Text(title)),
    ),
  );
}
