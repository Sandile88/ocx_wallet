import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/colors.dart';
import 'package:ocx_wallet/service/pay_view/bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/utils/icons/deposit_icons.dart';
import 'package:ocx_wallet/utils/icons/pay_icons.dart';
import 'package:ocx_wallet/utils/icons/receive_icons.dart';
import 'package:ocx_wallet/utils/icons/withdraw_icons.dart';
import 'package:ocx_wallet/view/pay/pay_view.dart';

class TransactionOptionData {
  final String label;
  final IconData icon;
  final Function(BuildContext context, WalletBloc walletBloc) onPressed;

  TransactionOptionData(
      {required this.icon, required this.label, required this.onPressed});
}

List<TransactionOptionData> transactionOptions = [
  TransactionOptionData(
      icon: Pay.pay_filled,
      label: "Pay",
      onPressed: (BuildContext context, WalletBloc walletBloc) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PayviewBloc(walletBloc)),
                BlocProvider.value(
                  value: walletBloc,
                )
              ],
              child: const PayView(),
            ),
          ),
        );
      }),
  TransactionOptionData(
      icon: Receive.receive_outlined,
      label: "Receive",
      onPressed: (BuildContext context, WalletBloc walletBloc) {}),
  TransactionOptionData(
      icon: Deposit.deposit_outlined,
      label: "Deposit",
      onPressed: (BuildContext context, WalletBloc walletBloc) {}),
  TransactionOptionData(
      icon: Withdraw.withdraw_outlined,
      label: "Withdraw",
      onPressed: (BuildContext context, WalletBloc walletBloc) {})
];

class TransactionOptions extends StatelessWidget {
  const TransactionOptions({super.key});

  @override
  Widget build(BuildContext context) {
    WalletBloc walletBloc = BlocProvider.of<WalletBloc>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var item in transactionOptions)
          TransactionOption(
            icon: item.icon,
            label: item.label,
            onPressed: () {
              item.onPressed(context, walletBloc);
            },
          ),
      ],
    );
  }
}

class TransactionOption extends StatelessWidget {
  const TransactionOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primary,
            child: Icon(
              icon,
              color: onPrimary,
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
      ),
    );
  }
}
