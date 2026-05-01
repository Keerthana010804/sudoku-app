import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberTap;
  final int? selectedNumber;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.selectedNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: List.generate(9, (index) {
          int number = index + 1;
          bool isSelected = selectedNumber == number;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onNumberTap(number),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),

                    /// 🔹 Selected = Gradient Button (PrimaryButton style)
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    )
                        : null,

                    /// 🔹 Unselected = Glass style
                    color: isSelected
                        ? null
                        : Colors.white.withOpacity(0.05),

                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.white24,
                    ),

                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                        : [],
                  ),

                  child: Center(
                    child: Text(
                      number.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}