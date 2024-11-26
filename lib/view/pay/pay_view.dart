import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/pay_view/bloc.dart';
import 'package:ocx_wallet/service/pay_view/state.dart';
import 'package:ocx_wallet/view/common/loading_view.dart';
import 'package:ocx_wallet/view/pay/enter_address_view.dart';
import 'package:ocx_wallet/view/pay/enter_amount_view.dart';

class PayView extends StatelessWidget {
  const PayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PayviewBloc, PayviewState>(
        builder: (context, state) {
          if (state.view == Payview.enterAddress) {
            return EnterAddressView();
          } else if (state.view == Payview.enterAmount) {
            return const EnterAmountView();
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}
