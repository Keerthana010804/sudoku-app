import 'package:flutter/material.dart';

class ToolBar extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onErase;
  final VoidCallback onPencil;
  final VoidCallback onHint;

  const ToolBar({
    super.key,
    required this.onUndo,
    required this.onErase,
    required this.onPencil,
    required this.onHint,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          _buildToolButton(Icons.undo, "Undo", onUndo),
          _buildToolButton(Icons.backspace, "Erase", onErase),
          _buildToolButton(Icons.edit, "Pencil", onPencil),
          _buildToolButton(Icons.lightbulb, "Hint", onHint),
        ],
      ),
    );
  }
}

Widget _buildToolButton(IconData icon, String label, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}
