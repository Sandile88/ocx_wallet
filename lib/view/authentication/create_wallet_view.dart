import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/colors.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';

class CreateWalletView extends StatelessWidget {
  const CreateWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 64.0, bottom: 32.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Expanded(
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                ),
              ),
            ),
            const SizedBox(
              height: 64.0,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Expanded(
                child: Image(
                  image: AssetImage("assets/images/onboarding3.png"),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            CreateWalletButton(
              onClick: () {
                BlocProvider.of<WalletBloc>(context).add(CreateWalletEvent());
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text("Terms & conditions"),
          ],
        ),
      ),
    );
  }
}

class ImportWalletButton extends StatelessWidget {
  const ImportWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: primary,
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Import Wallet",
                  style: TextStyle(
                    color: onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateWalletButton extends StatelessWidget {
  const CreateWalletButton({super.key, required this.onClick});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: primary,
              ),
              onPressed: onClick,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Create Wallet",
                  style: TextStyle(
                    color: onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
