import 'package:flutter/material.dart';

class SubmitProofPage extends StatelessWidget {
  const SubmitProofPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Proof"),
      ),
      body: Center(
        child: const Text("This is the Submit Proof page."),
      ),
    );
  }
}
