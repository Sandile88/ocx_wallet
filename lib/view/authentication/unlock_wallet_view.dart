import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/numpad/bloc.dart';
import 'package:ocx_wallet/view/authentication/enter_pin_view.dart';

class UnlockWalletView extends StatelessWidget {
  const UnlockWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => NumpadBloc(),
        child: const EnterPinView(
          pinType: Pin.unlockWallet,
        ),
      ),
    );
  }
}
