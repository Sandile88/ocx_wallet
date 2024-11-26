import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/numpad/bloc.dart';
import 'package:ocx_wallet/service/numpad/event.dart';
import 'package:ocx_wallet/view/common/numpad/numpad.dart';

class EnterAmountView extends StatelessWidget {
  const EnterAmountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NumpadBloc()
        ..add(
          OnNumpadInitializeEvent(
            mode: NumpadMode.amount,
          ),
        ),
      child: Column(
        children: [
          Numpad(
            onSubmit: (value) {},
            hint: "Enter Amount",
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
