import 'package:flutter/material.dart';
import 'package:ocx_wallet/constants/colors.dart';

class PinDisplay extends StatelessWidget {
  final int length;
  final int filledCount;
  final bool isError;

  const PinDisplay({
    super.key,
    required this.length,
    required this.filledCount,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isError
                ? Colors.red
                : index < filledCount
                    ? primary
                    : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
