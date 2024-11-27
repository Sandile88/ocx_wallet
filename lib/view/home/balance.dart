import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    WalletBloc walletBloc = BlocProvider.of<WalletBloc>(context);
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Balance",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          walletBloc.balance.toStringAsFixed(2),
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
