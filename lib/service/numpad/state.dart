import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ocx_wallet/constants/type.dart';

class NumpadState extends Equatable {
  final bool isError;
  final String currentInput;
  final NumpadMode mode;
  final int pinLength;
  final double? maxAmount;
  final String currencySymbol;

  const NumpadState({
    required this.currentInput,
    required this.isError,
    this.mode = NumpadMode.pin,
    required this.pinLength,
    this.maxAmount,
    required this.currencySymbol,
  });

  NumpadState copyWith(
      {isError, currentInput, mode, pinLength, currencySymbol}) {
    return NumpadState(
      currentInput: currentInput ?? this.currentInput,
      isError: isError ?? this.isError,
      mode: mode ?? this.mode,
      pinLength: pinLength ?? this.pinLength,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  String get formattedAmount {
    if (currentInput.isEmpty) return '0.00';
    try {
      double amount = double.parse(currentInput);
      return intl.NumberFormat.currency(
        symbol: '',
        decimalDigits: 2,
      ).format(amount);
    } catch (_) {
      return currentInput;
    }
  }

  @override
  List<Object?> get props =>
      [isError, currentInput, mode, pinLength, maxAmount, currencySymbol];
}
