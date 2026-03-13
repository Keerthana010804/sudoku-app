import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberTap;

  const NumberPad({
    super.key,
    required this.onNumberTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: List.generate(9, (index) {
          int number = index + 1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onNumberTap(number),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
