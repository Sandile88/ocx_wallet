import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/state.dart';
import 'package:ocx_wallet/service/proof/state.dart';
import 'package:ocx_wallet/service/proof/bloc.dart';
import 'package:ocx_wallet/view/authentication/backup_wallet_view.dart';
import 'package:ocx_wallet/view/authentication/create_wallet_view.dart';
import 'package:ocx_wallet/view/authentication/unlock_wallet_view.dart';
import 'package:ocx_wallet/view/home/home_view.dart';
import 'package:ocx_wallet/view/onboarding/onboarding_view.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
       return BlocBuilder<WalletBloc, WalletState>(
        buildWhen: (prev, current) {
        return !((current is WalletLoadingState) ||
        (current is WalletFailureState) ||
        (current is TransferSuccessState));
        // !prev == current
    },
      builder: (context, state) {
        if (state is NoWalletState) {
          return const CreateWalletView();
        } else if (state is OnBoardingState) {
          return const OnboardingView();
        } else if (state is UnlockWalletState) {
          return const UnlockWalletView();
        } else if (state is WalletNotSecuredState || state is InvalidPinError) {
          return BlocProvider<WalletBloc>.value(
            value: BlocProvider.of<WalletBloc>(context),
            child: const BackupWalletView(),
          );
          // return const BackupWalletView();
        } else if (state is WalletUnlockedState) {
          return const HomeView();
        } else {
          print(state.toString());
          return const SplashView();
        }
      },
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100.0,
          width: 100.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
        ),
      ),
    );
  }
}
