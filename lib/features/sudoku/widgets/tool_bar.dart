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
    return Container(
      height: 70,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          _buildToolButton(Icons.undo, "Undo", onUndo),
          _buildToolButton(Icons.backspace, "Erase", onErase),
          _buildToolButton(Icons.edit, "Pencil", onPencil,
              isActive: isPencilMode),
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
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: isActive
                  ? const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              )
                  : null,
              color: isActive ? null : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isActive ? Colors.white : Colors.white70,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.white : Colors.white70,
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