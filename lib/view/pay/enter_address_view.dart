import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/colors.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/pay_view/bloc.dart';
import 'package:ocx_wallet/service/pay_view/event.dart';
import 'package:ocx_wallet/service/pay_view/state.dart';
import 'package:ocx_wallet/utils/icons/nfc_outlined_icons.dart';

class EnterAddressView extends StatelessWidget {
  EnterAddressView({super.key});

  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PayviewBloc, PayviewState>(
      listenWhen: (prev, state) {
        return prev.recipient != state.recipient;
      },
      listener: (context, state) {
        _addressController.text = state.recipient;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 64.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recipient Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<PayviewBloc>(context)
                            .add(OnSwitchViewEvent(Payview.scanQrCode));
                      },
                      icon: const Icon(
                        Icons.qr_code_scanner_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<PayviewBloc>(context)
                            .add(OnSwitchViewEvent(Payview.tap2Pay));
                      },
                      icon: const Icon(
                        Nfc_outlined.nfc_outlined,
                        size: 38,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            AddressTextField(
              controller: _addressController,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // _addressController = clipboard text
                  },
                  label: const Text(
                    "Paste",
                    style: TextStyle(color: Colors.grey),
                  ),
                  icon: const Icon(Icons.paste),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      backgroundColor: primary,
                    ),
                    onPressed: BlocProvider.of<PayviewBloc>(context)
                            .state
                            .recipient
                            .isEmpty
                        ? null
                        : () {
                            print("switch to enter amount view");
                            BlocProvider.of<PayviewBloc>(context)
                                .add(OnSwitchViewEvent(Payview.enterAmount));
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Continue",
                        style: TextStyle(color: onPrimary),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddressTextField extends StatelessWidget {
  const AddressTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        // TODO: validate address
        print(value);
        BlocProvider.of<PayviewBloc>(context).add(OnAddressChanged(value));
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter wallet address or ENS domain name",
        contentPadding: EdgeInsets.symmetric(
          vertical: 5.0,
          // horizontal: 20.0,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
