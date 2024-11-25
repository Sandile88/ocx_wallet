import 'package:flutter/material.dart';
import 'package:ocx_wallet/constants/colors.dart';

class NumpadButton extends StatelessWidget {
  final String number;
  final VoidCallback onTap;

  const NumpadButton({
    super.key,
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        color: primary.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
