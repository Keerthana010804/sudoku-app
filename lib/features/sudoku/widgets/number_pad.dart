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
              padding: EdgeInsets.all(4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onNumberTap(number),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : null,
                      gradient: isSelected
                          ? null
                          : const LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        number.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.deepOrange : Colors.white,
                        ),
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
