import 'package:equatable/equatable.dart';

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

class OnAddressChanged extends PayviewEvent {
  final String address;

  OnAddressChanged(this.address);

  @override
  List<Object?> get props => [address];
}
