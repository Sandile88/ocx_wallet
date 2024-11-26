import 'package:equatable/equatable.dart';
import 'package:ocx_wallet/constants/type.dart';

class PayviewState extends Equatable {
  final String amount;
  final String recipient;
  final Payview view;
  final String error;
  final bool isError;
  final bool isSuccess;
  final bool isLoading;

  const PayviewState({
    required this.amount,
    required this.recipient,
    required this.view,
    required this.error,
    required this.isError,
    required this.isSuccess,
    required this.isLoading,
  });

  PayviewState copyWith(
      {amount, recipient, view, error, isError, isSuccess, isLoading}) {
    return PayviewState(
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
      view: view ?? this.view,
      error: error ?? this.error,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props =>
      [amount, recipient, view, error, isError, isSuccess, isLoading];
}
