import 'package:flutter/material.dart';

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Balance",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          "R 500.00",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 36.0,
          ),
        ),
      ],
    );
  }
}
