import 'package:flutter/material.dart';
import 'package:ocx_wallet/utils/icons/deposit_icons.dart';
import 'package:ocx_wallet/utils/icons/pay_icons.dart';
import 'package:ocx_wallet/utils/icons/receive_icons.dart';
import 'package:ocx_wallet/utils/icons/withdraw_icons.dart';

class TransactionOptionData {
  final String label;
  final IconData icon;
  // final Function(BuildContext context) onPressed;

  TransactionOptionData({required this.icon, required this.label});
}

List<TransactionOptionData> transactionOptions = [
  TransactionOptionData(icon: Pay.pay_filled, label: "Pay"),
  TransactionOptionData(icon: Receive.receive_outlined, label: "Receive"),
  TransactionOptionData(icon: Deposit.deposit_outlined, label: "Deposit"),
  TransactionOptionData(icon: Withdraw.withdraw_outlined, label: "Withdraw")
];

class TransactionOptions extends StatelessWidget {
  const TransactionOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var item in transactionOptions)
          TransactionOption(
            icon: item.icon,
            label: item.label,
          ),
      ],
    );
  }
}

class TransactionOption extends StatelessWidget {
  const TransactionOption({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 28,
          child: Icon(
            icon,
            color: Colors.black,
            size: 26,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        )
      ],
    );
  }
}
