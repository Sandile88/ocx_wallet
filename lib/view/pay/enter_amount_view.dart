import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/colors.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/numpad/bloc.dart';
import 'package:ocx_wallet/service/numpad/event.dart' hide OnErrorEvent;
import 'package:ocx_wallet/service/pay_view/bloc.dart';
import 'package:ocx_wallet/service/pay_view/event.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/state.dart';
import 'package:ocx_wallet/view/common/numpad/numpad.dart';
import 'package:slidable_button/slidable_button.dart';

class EnterAmountView extends StatelessWidget {
  const EnterAmountView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          // when raised button is pressed
          // we display showModalBottomSheet
          showModalBottomSheet<void>(
            // context and builder are
            // required properties in this widget
            context: context,
            builder: (BuildContext context) {
              // we set up a container inside which
              // we create center column and display text

              // Returning SizedBox instead of a Container
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (state is WalletFailureState)
                        Text(state.message)
                      else if (state is WalletUnlockedState)
                        Text("Successful")
                      else
                        CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            },
          );
          // if (state is WalletFailureState) {
          //   BlocProvider.of<PayviewBloc>(context)
          //       .add(OnErrorEvent(state.message));
          // }

          // if (state is TransferSuccessState) {
          //   BlocProvider.of<PayviewBloc>(context).add(OnSuccessEvent());
          // }

          // if (state is WalletFailureState) {
          //   BlocProvider.of<PayviewBloc>(context)
          //       .add(OnErrorEvent(state.message));
          // }
        },
        child: BlocProvider(
          create: (context) => NumpadBloc()
            ..add(
              OnNumpadInitializeEvent(
                mode: NumpadMode.amount,
              ),
            ),
          child: Numpad(
            onSubmit: (value) {
              print("$value submited");
              BlocProvider.of<PayviewBloc>(context).add(
                OnOnlineTransferEvent(
                  value,
                ),
              );
            },
            hint: "Enter Amount",
          ),
        ),
      ),
    );
  }
}
