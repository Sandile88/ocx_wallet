import 'package:equatable/equatable.dart';
import 'package:ocx_wallet/constants/type.dart';

class NumpadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnInputNumpadEvent extends NumpadEvent {
  final String digit;

  OnInputNumpadEvent(this.digit);

  @override
  List<Object?> get props => [digit];
}

class OnBackspaceEvent extends NumpadEvent {}

class OnNumpadInitializeEvent extends NumpadEvent {
  final NumpadMode mode;
  final String currencySymbol;
  final int pinLength;

  OnNumpadInitializeEvent(
      {required this.mode, this.currencySymbol = '\$', this.pinLength = 6});

  @override
  List<Object?> get props => [mode, currencySymbol, pinLength];
}

class OnClearEvent extends NumpadEvent {}

class OnErrorEvent extends NumpadEvent {}
