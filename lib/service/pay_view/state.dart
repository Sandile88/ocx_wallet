import 'package:equatable/equatable.dart';
import 'package:ocx_wallet/constants/type.dart';

class PayviewState extends Equatable {
  final String amount;
  final String recipient;
  final Payview view;

  const PayviewState(
      {required this.amount, required this.recipient, required this.view});

  PayviewState copyWith({amount, recipient, view}) {
    return PayviewState(
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
      view: view ?? this.view,
    );
  }

  @override
  List<Object?> get props => [amount, recipient];
}
