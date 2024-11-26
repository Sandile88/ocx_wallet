import 'package:flutter/material.dart';
import 'package:ocx_wallet/view/home/balance.dart';
import 'package:ocx_wallet/view/home/transaction_options.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: const Padding(
          padding: EdgeInsets.only(
            top: 64.0,
            right: 20.0,
            left: 20.0,
          ),
          child: Column(
            children: [
              Balance(),
              SizedBox(
                height: 20.0,
              ),
              TransactionOptions(),
            ],
          ),
        ),
      ),
    );
  }
}
