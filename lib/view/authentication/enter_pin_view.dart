import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/numpad/bloc.dart';
import 'package:ocx_wallet/service/numpad/event.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';
import 'package:ocx_wallet/service/wallet/state.dart';
import 'package:ocx_wallet/view/common/numpad/numpad.dart';

class EnterPinView extends StatelessWidget {
  const EnterPinView({super.key, required this.pinType});
  final Pin pinType;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is InvalidPinError) {
            BlocProvider.of<NumpadBloc>(context).add(OnErrorEvent());
          }
        },
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: Numpad(
                  onSubmit: (value) {
                    BlocProvider.of<WalletBloc>(context).add(
                      (pinType == Pin.secureWallet)
                          ? SecureWalletEvent(
                              BlocProvider.of<NumpadBloc>(context)
                                  .state
                                  .currentInput,
                            )
                          : UnlockWalletEvent(
                              BlocProvider.of<NumpadBloc>(context)
                                  .state
                                  .currentInput,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
