import 'package:equatable/equatable.dart';
import 'package:ocx_wallet/constants/type.dart';

class PayviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnAmountChanged extends PayviewEvent {
  final String amount;

  OnAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class OnSwitchViewEvent extends PayviewEvent {
  final Payview view;

  OnSwitchViewEvent(this.view);

  @override
  List<Object?> get props => [view];
}

class OnAddressChanged extends PayviewEvent {
  final String address;

  OnAddressChanged(this.address);

  @override
  List<Object?> get props => [address];
}
