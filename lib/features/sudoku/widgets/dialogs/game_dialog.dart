import 'package:flutter/material.dart';

class GameDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Widget? extraContent;
  final List<Widget> actions;

  const GameDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.extraContent,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.06,
          vertical: size.height * 0.03,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1E293B),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: size.width * 0.15, color: iconColor),
                SizedBox(height: size.height * 0.02),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: size.height * 0.012),

                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.width * 0.035,
                  ),
                ),

                if (extraContent != null) ...[
                  SizedBox(height: size.height * 0.01),
                  extraContent!,
                ],

                SizedBox(height: size.height * 0.03),

                Row(children: actions),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
