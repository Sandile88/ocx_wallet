import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';

class TotalBalance extends StatelessWidget {
  const TotalBalance({super.key});

  @override
  Widget build(BuildContext context) {
    WalletBloc walletBloc = BlocProvider.of<WalletBloc>(context);
    double totalBalance = walletBloc.balance + walletBloc.proofBalance;

    return Column(
      children: [
        const Text(
          "Total Balance",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          totalBalance.toStringAsFixed(2),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 36.0,
          ),
        ),
      ],
    );
  }
}
