import 'package:equatable/equatable.dart';

class WalletState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvalidUnlockPinState extends WalletState {}

class WalletUnlockedState extends WalletState {}

class WalletFailureState extends WalletState {
  final String message;

  WalletFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class TransferSuccessState extends WalletState {}

class SplashState extends WalletState {}

class WalletLoadingState extends WalletState {}

class NoWalletState extends WalletState {}

class WalletNotSecuredState extends WalletState {
  final bool isInvalidPin;

  WalletNotSecuredState({this.isInvalidPin = false});

  @override
  List<Object?> get props => [isInvalidPin];
}

class OnBoardingState extends WalletState {}

class WalletInitialState extends WalletState {}

class UnlockWalletState extends WalletState {}

class InvalidPinError extends WalletState {}
