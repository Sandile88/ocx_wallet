import 'package:equatable/equatable.dart';

class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionFailedState extends TransactionState {
  final String message;

  TransactionFailedState(this.message);

  @override
  List<Object?> get props => [message];
}

class TransactionSuccessfulState extends TransactionState {}
