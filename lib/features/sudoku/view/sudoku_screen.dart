import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/dialogs/start_dialog.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/sudoku_app_bar.dart';
import 'package:sudoku_app/features/sudoku/view/widgets/sudoku_body.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';


class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  late SudokuViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = context.read<SudokuViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.isResumedGame) {
        if (!vm.isPaused) {
          vm.startTimer();
        }
      } else {
        showStartDialog(context, vm);
      }
    });
  }

  @override
  void dispose() {
    vm.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SudokuAppBar(),
      body: SudokuBody(),
    );
  }
}