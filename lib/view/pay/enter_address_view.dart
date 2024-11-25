import 'package:flutter/material.dart';

class EnterAddressView extends StatelessWidget {
  const EnterAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

class AddressTextField extends StatelessWidget {
  AddressTextField({super.key});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Sized size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
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
