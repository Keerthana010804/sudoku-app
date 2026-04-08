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
  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<SudokuViewModel>().loadGame());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _SudokuAppBar(), body: _SudokuBody());
  }
}

/// App Bar
class _SudokuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SudokuAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text("Sudoku"), centerTitle: true);
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _TimeView(
              time: vm.formattedTime,
            mistakes: vm.mistakes,
            maxMistakes: vm.maxMistakes,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SudokuGrid(
              board: vm.board,
              notes: vm.notes,
              selectedRow: vm.selectedRow,
              selectedCol: vm.selectedCol,
              onCellTap: (row, col) {
                vm.selectedCell(row, col);
              },
              isFixedCell: vm.isFixedCell,
              selectedNumber: vm.selectedNumber,
            ),
          ),
          const SizedBox(height: 20),
          ToolBar(
            onUndo: vm.undo,
            onErase: vm.erase,
            onPencil: vm.togglePencil,
            onHint: vm.giveHint,
            isPencilMode: vm.isPencilMode,
          ),
          const SizedBox(height: 20),
          _NumberPadSection(),
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
    return NumberPad(
      selectedNumber: vm.selectedNumber,
      onNumberTap: (number) {
        final isValid = vm.enterNumber(number);
        if (!isValid) {
          _showInvalidMove(context);
          vm.clearSelection();
          if (vm.mistakes >= vm.maxMistakes) {
            vm.stopTimer();
            vm.clearSavedGame();
            _showGameOverDialog(context);
          }
          return;
        }
        vm.selectNumber(number);
        if (vm.isPuzzleSolved()) {
          _showWinDialog(context, vm.formattedTime);
        }
      },
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

  void _showWinDialog(BuildContext context, String formattedTime) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("🎉 Congratulations!"),
        content: Text("You solved the puzzle!\nTime: $formattedTime"),
        actions: [
          TextButton(
            onPressed: () {
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
            TextButton(onPressed: (){
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
                child: const Text("OK"),
            )
          ],
        )
    );
  }
}
