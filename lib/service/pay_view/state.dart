import 'package:equatable/equatable.dart';

class PayviewState extends Equatable {
  final String amount;
  final String recipient;

  const PayviewState({required this.amount, required this.recipient});

  PayviewState copyWith({amount, recipient}) {
    return PayviewState(
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
    );
  }

  @override
  List<Object?> get props => [amount, recipient];
}
