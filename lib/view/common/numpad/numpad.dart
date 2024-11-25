import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/dimensions.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/numpad/bloc.dart';
import 'package:ocx_wallet/service/numpad/event.dart';
import 'package:ocx_wallet/service/numpad/state.dart';
import 'package:ocx_wallet/view/common/numpad/amount_display.dart';
import 'package:ocx_wallet/view/common/numpad/delete_button.dart';
import 'package:ocx_wallet/view/common/numpad/numpad_button.dart';
import 'package:ocx_wallet/view/common/numpad/pin_display.dart';

// Enum to define different numpad modes
// enum NumpadMode {
//   pin,
//   amount,
// }

// class Numpad extends StatefulWidget {
//   final NumpadMode mode;
//   final int? pinLength;
//   final double? maxAmount;
//   final String? correctPin;
//   final Function(String) onSubmit;
//   final String? currencySymbol;
//   final String? hint;
//   final bool isError;

//   const Numpad({
//     super.key,
//     required this.mode,
//     required this.onSubmit,
//     this.pinLength = 6,
//     this.maxAmount,
//     this.correctPin,
//     this.currencySymbol = '\$',
//     this.hint,
//     this.isError = false,
//   });

//   @override
//   State<Numpad> createState() => _NumpadState();
// }

class Numpad extends StatelessWidget {
  final String? correctPin;
  final Function(String) onSubmit;
  final String? hint;
  final bool isError;

  const Numpad({
    super.key,
    required this.onSubmit,
    this.correctPin,
    this.hint,
    this.isError = false,
  });

  // void _verifyPin() {
  //   if (widget.correctPin != null && currentInput != widget.correctPin) {
  //     setState(() {
  //       isError = true;
  //       Future.delayed(const Duration(milliseconds: 300), () {
  //         setState(() {
  //           currentInput = '';
  //         });
  //       });
  //     });
  //   } else {
  //     widget.onSubmit(currentInput);
  //   }
  // }

  // void _removeDigit() {
  //   BlocProvider.of<NumpadBloc>(context).add(OnBackspaceEvent());
  //   // if (currentInput.isNotEmpty) {
  //   //   setState(() {
  //   //     currentInput = currentInput.substring(0, currentInput.length - 1);
  //   //     isError = false;
  //   //   });
  //   // }
  // }

  // void _clearInput() {
  //   BlocProvider.of<NumpadBloc>(context).add(OnClearEvent());

  //   // setState(() {
  //   //   currentInput = '';
  //   //   isError = false;
  //   // });
  // }

  // String get _formattedAmount {
  //   if (currentInput.isEmpty) return '0.00';
  //   try {
  //     double amount = double.parse(currentInput);
  //     return intl.NumberFormat.currency(
  //       symbol: '',
  //       decimalDigits: 2,
  //     ).format(amount);
  //   } catch (_) {
  //     return currentInput;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 128,
        bottom: 64.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<NumpadBloc, NumpadState>(
            builder: (context, state) {
              // Display section
              if (state.mode == NumpadMode.pin) {
                return BlocListener<NumpadBloc, NumpadState>(
                  listener: (context, state) {
                    if (state.currentInput.length == 6) {
                      onSubmit(state.currentInput);
                    }
                  },
                  child: Column(
                    children: [
                      const Text(
                        "Enter Pin",
                        style: TextStyle(fontSize: fontSmall),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      PinDisplay(
                        length: state.pinLength,
                        filledCount: state.currentInput.length,
                        isError: state.isError,
                      )
                    ],
                  ),
                );
              } else {
                return AmountDisplay(
                  amount: state.formattedAmount,
                  currencySymbol: state.currencySymbol,
                  hint: hint,
                );
              }
            },
          ),

          const SizedBox(
            height: 150,
          ),
          // Numpad grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                for (var i = 0; i < 3; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3,
                      (j) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: NumpadButton(
                          number: (i * 3 + j + 1).toString(),
                          onTap: () {
                            String digit = (i * 3 + j + 1).toString();
                            BlocProvider.of<NumpadBloc>(context)
                                .add(OnInputNumpadEvent(digit));
                          },
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Show decimal point only in amount mode
                    BlocBuilder<NumpadBloc, NumpadState>(
                        builder: (context, state) {
                      if (state.mode == NumpadMode.amount) {
                        return NumpadButton(
                          number: '.',
                          onTap: () => BlocProvider.of<NumpadBloc>(context)
                              .add(OnInputNumpadEvent(".")),
                        );
                      }
                      return const SizedBox(width: 80);
                    }),
                    NumpadButton(
                      number: '0',
                      onTap: () => BlocProvider.of<NumpadBloc>(context)
                          .add(OnInputNumpadEvent("0")),
                    ),
                    DeleteButton(
                      onTap: () => BlocProvider.of<NumpadBloc>(context)
                          .add(OnBackspaceEvent()),
                      // onLongPress: _clearInput,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // // Submit button for amount mode
          // if (widget.mode == NumpadMode.amount && currentInput.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: ElevatedButton(
          //       onPressed: () => widget.onSubmit(currentInput),
          //       child: const Text('Continue'),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
