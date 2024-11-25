import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {
  final String amount;
  final String currencySymbol;
  final String? hint;

  const AmountDisplay({
    super.key,
    required this.amount,
    required this.currencySymbol,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hint != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              hint!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currencySymbol,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
