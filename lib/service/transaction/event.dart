import 'package:equatable/equatable.dart';

class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionPayEvent extends TransactionEvent {
  final String amount;
  final String recipient;

  TransactionPayEvent({required this.amount, required this.recipient});

  @override
  List<Object?> get props => [amount, recipient];
}
