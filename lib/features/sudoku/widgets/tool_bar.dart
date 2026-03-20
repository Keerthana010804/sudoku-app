import 'package:flutter/material.dart';

class ToolBar extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onErase;
  final VoidCallback onPencil;
  final VoidCallback onHint;
  final bool isPencilMode;

  const ToolBar({
    super.key,
    required this.onUndo,
    required this.onErase,
    required this.onPencil,
    required this.onHint,
    required this.isPencilMode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          _buildToolButton(Icons.undo, "Undo", onUndo),
          _buildToolButton(Icons.backspace, "Erase", onErase),
          _buildToolButton(Icons.edit, "Pencil", onPencil, isActive: isPencilMode),
          _buildToolButton(Icons.lightbulb, "Hint", onHint),
        ],
      ),
    );
  }
}

Widget _buildToolButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
      bool isActive = false,
}) {
  return Expanded(
    child: Padding(padding: EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isActive ? Colors.blue : Colors.black87,
                ),
                const SizedBox(height: 4,),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.blue : Colors.black87,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
