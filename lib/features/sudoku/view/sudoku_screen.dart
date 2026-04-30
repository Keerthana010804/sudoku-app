import 'package:flutter/material.dart';
import 'package:sudoku_app/features/sudoku/widgets/number_pad.dart';
import 'package:sudoku_app/features/sudoku/widgets/sudoku_grid.dart';
import 'package:sudoku_app/features/sudoku/widgets/tool_bar.dart';
import 'package:sudoku_app/features/sudoku/viewmodel/sudoku_viewmodel.dart';
import 'package:provider/provider.dart';

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
        _showStartDialog(context);
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
    return Scaffold(
      appBar: _SudokuAppBar(),
      body: _SudokuBody(),
    );
  }

  void _showStartDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must click button
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Ready to Start?"),
          content: const Text(
            "Take your time and get ready.\nTap start when you're ready.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                vm.startTimer();
              },
              child: const Text("Start Game"),
            ),
          ],
        );
      },
    );
  }
}

/// App Bar
class _SudokuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SudokuAppBar();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();

    return AppBar(
      title: const Text("Sudoku"),
      centerTitle: true,
      actions: [
        if (!vm.isPaused)
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: vm.pauseGame,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main Body
class _SudokuBody extends StatelessWidget {
  const _SudokuBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(vm.isGameOver) {
        vm.isGameOver = false;
        _showGameOverDialog(context);
      }
      if(vm.isGameWon) {
        vm.isGameWon = false;
        _showWinDialog(context, vm.formattedTime);
      }
    });
    return Stack(
      children:[
        Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Selector<SudokuViewModel, String>(
              selector: (_, vm) => vm.formattedTime,
              builder: (_, time, __) {
                return Selector<SudokuViewModel, int>(
                  selector: (_, vm) => vm.mistakes,
                  builder: (_, mistakes, __){
                    return _TimeView(
                      time: time,
                      mistakes: mistakes,
                      maxMistakes: context.read<SudokuViewModel>().maxMistakes,
                    );
                  },
                );
              }
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SudokuGrid(
                board: vm.board,
                notes: vm.notes,
                selectedRow: vm.selectedRow,
                selectedCol: vm.selectedCol,
                onCellTap: vm.isPaused ? (_, __) {} : (row, col) {
                  vm.selectedCell(row, col);
                },
                isFixedCell: vm.isFixedCell,
                selectedNumber: vm.selectedNumber,
                errorCells: vm.errorCells,
              ),
            ),
            const SizedBox(height: 20),
            ToolBar(
              onUndo: vm.isPaused ? () {} : vm.undo,
              onErase: vm.isPaused ? () {} : vm.erase,
              onPencil: vm.isPaused ? () {} : vm.togglePencil,
              onHint: vm.isPaused ? () {} : vm.giveHint,
              isPencilMode: vm.isPencilMode,
            ),
            const SizedBox(height: 20),
            _NumberPadSection(),
          ],
        ),
      ),
        if (vm.isPaused) _PauseOverlay(),
      ],
    );
  }

  void _showWinDialog(BuildContext context, String formattedTime) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("🎉 Congratulations!"),
        content: Text("You solved the puzzle!\nTime: $formattedTime"),
        actions: [
          TextButton(
            onPressed: () {
              final vm = context.read<SudokuViewModel>();
              vm.isGameOver = false;
              vm.isGameWon = false;

              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("😢 Game Over"),
        content: const Text("You made too many mistakes"),
        actions: [
          TextButton(
            onPressed: () {
              final vm = context.read<SudokuViewModel>();

              vm.isGameOver = false;
              vm.isGameWon = false;

              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}

class _TimeView extends StatelessWidget {
  final String time;
  final int mistakes;
  final int maxMistakes;

  const _TimeView({
    required this.time,
    required this.mistakes,
    required this.maxMistakes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Timer
        Row(
          children: [
            const Icon(Icons.timer),
            const SizedBox(width: 6),
            Text(
              time,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // Mistakes
        Row(
          children: [
            const Icon(Icons.close, color: Colors.redAccent),
            const SizedBox(width: 6),
            Text(
              "$mistakes / $maxMistakes",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NumberPadSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SudokuViewModel>();
    return IgnorePointer(
      ignoring: vm.isPaused,
      child: NumberPad(
        selectedNumber: vm.selectedNumber,
        onNumberTap: (number) {
          final isValid = vm.enterNumber(number);
          if (!isValid) {
            _showInvalidMove(context);
            vm.clearSelection();
            return;
          }
          vm.selectNumber(number);
        },
      ),
    );
  }

  void _showInvalidMove(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invalid Move!"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<SudokuViewModel>();

    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pause_circle, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Game Paused",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Time: ${vm.formattedTime}",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: vm.resumeGame,
              child: const Text("Resume"),
            ),
          ],
        ),
      ),
    );
  }
}
