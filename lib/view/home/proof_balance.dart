import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';

class ProofBalance extends StatelessWidget {
  const ProofBalance({super.key});

  @override
  Widget build(BuildContext context) {
    WalletBloc walletBloc = BlocProvider.of<WalletBloc>(context);
    return Column(
      children: [
        const Text(
          "Proof Balance",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          walletBloc.proofBalance.toStringAsFixed(2),
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
