import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/numpad/event.dart';
import 'package:ocx_wallet/service/numpad/state.dart';

class NumpadBloc extends Bloc<NumpadEvent, NumpadState> {
  NumpadBloc()
      : super(const NumpadState(
            currentInput: "",
            isError: false,
            pinLength: 6,
            currencySymbol: '\$')) {
    on<OnNumpadInitializeEvent>(_init);
    on<OnInputNumpadEvent>(_input);
    on<OnBackspaceEvent>(_removeDigit);
    on<OnClearEvent>(_clearInput);
  }

  _init(OnNumpadInitializeEvent event, Emitter emit) {
    emit(
      state.copyWith(
        mode: event.mode,
        currencySymbol: event.currencySymbol,
        pinLength: event.pinLength,
      ),
    );
  }

  _input(OnInputNumpadEvent event, Emitter emit) {
    if (state.mode == NumpadMode.pin) {
      if (state.currentInput.length < state.pinLength) {
        emit(state.copyWith(currentInput: state.currentInput + event.digit));

        // if (currentInput.length == widget.pinLength) {
        //   _verifyPin();
        // }
      }
    } else {
      // Amount mode
      if (event.digit == '.' && state.currentInput.contains('.')) return;
      if (event.digit == '.' && state.currentInput.isEmpty) {
        emit(state.copyWith(currentInput: '0.'));
        return;
      }

      // Handle decimal places
      if (state.currentInput.contains('.')) {
        if (state.currentInput.split('.')[1].length >= 2) return;
      }

      String newAmount = state.currentInput + event.digit;
      if (state.maxAmount != null) {
        try {
          double amount = double.parse(newAmount);
          if (amount > state.maxAmount!) return;
        } catch (_) {
          return;
        }
      }

      print("this is the new amount ${state.currentInput}");

      emit(state.copyWith(currentInput: newAmount));
    }
  }

  void _removeDigit(OnBackspaceEvent event, Emitter emit) {
    if (state.currentInput.isNotEmpty) {
      emit(state.copyWith(
        currentInput:
            state.currentInput.substring(0, state.currentInput.length - 1),
        isError: false,
      ));
    }
  }

  void _clearInput(OnClearEvent event, Emitter emit) {
    emit(state.copyWith(currentInput: '', isError: false));
  }
}
