import 'package:equatable/equatable.dart';

class WalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStartedEvent extends WalletEvent {}

class OnboardingDoneEvent extends WalletEvent {}

class CreateWalletEvent extends WalletEvent {}

class SecureWalletEvent extends WalletEvent {
  final String pin;

  SecureWalletEvent(this.pin);

  @override
  List<Object?> get props => [pin];
}

class UnlockWalletEvent extends WalletEvent {
  final String pin;

  UnlockWalletEvent(this.pin);

  @override
  List<Object?> get props => [pin];
}
