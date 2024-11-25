import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/colors.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/numpad/bloc.dart';
import 'package:ocx_wallet/service/numpad/event.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/view/authentication/enter_pin_view.dart';

class BackupWalletView extends StatelessWidget {
  const BackupWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    var walletBloc = BlocProvider.of<WalletBloc>(context);

    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(
        //   Icons.arrow_back,
        // ),
        title: const Text("Backup"),
        centerTitle: true,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<WalletBloc>.value(
                        value: walletBloc,
                      ),
                      BlocProvider<NumpadBloc>(
                        create: (context) => NumpadBloc()
                          ..add(
                            OnNumpadInitializeEvent(
                              mode: NumpadMode.pin,
                            ),
                          ),
                      ),
                    ],
                    child: const EnterPinView(),
                  ),
                ),
              );
            },
            child: Text(
              "SKIP",
              style: TextStyle(color: onPrimary),
            ),
          ),
          const SizedBox(
            width: 16.0,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/images/onboarding2.png"),
                  ),
                  const Text(
                    "Back up secret phrase",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28.0,
                    ),
                  ),
                  Text(
                    "Will back up your phrase in your social account of your choice",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: secondary,
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Backup",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
