import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:ocx_wallet/constants/colors.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Continue',
        finishButtonStyle: FinishButtonStyle(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.black,
        ),
        onFinish: () {
          BlocProvider.of<WalletBloc>(context).add(OnboardingDoneEvent());
        },
        skipTextButton: null,
        trailing: null,
        background: [
          Image.asset(
            'assets/images/onboarding2.png',
            scale: 2,
          ),
          Image.asset(
            'assets/images/onboarding1.png',
            scale: 2,
          ),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 480,
                ),
                Text(
                  'Transactions secured by the blockchain',
                  style: TextStyle(
                    fontSize: 32,
                    color: textBlue2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 480,
                ),
                Text(
                  'Offline transaction for seamless transactions no matter the situation',
                  style: TextStyle(
                    fontSize: 32,
                    color: textBlue2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
