import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/pay_view/bloc.dart';
import 'package:ocx_wallet/service/pay_view/event.dart';

class EnterAddressView extends StatelessWidget {
  EnterAddressView({super.key});

  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Recipient Address",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
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
            TextButton(
              onPressed:
                  BlocProvider.of<PayviewBloc>(context).state.recipient.isEmpty
                      ? null
                      : () {
                          BlocProvider.of<PayviewBloc>(context)
                              .add(OnSwitchViewEvent(Payview.enterAmount));
                        },
              child: const Text("Continue"),
            )
          ],
        )
      ],
    );
  }
}

class AddressTextField extends StatelessWidget {
  AddressTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          // TODO: validate address
          BlocProvider.of<PayviewBloc>(context).add(OnAddressChanged(value));
        },
        decoration: const InputDecoration(
          hintText: "Enter wallet address or ENS domain name",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
