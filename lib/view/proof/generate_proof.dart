import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';

class GenerateProof extends StatefulWidget {
  const GenerateProof({Key? key}) : super(key: key);

  @override
  _GenerateProofState createState() => _GenerateProofState();
}

class _GenerateProofState extends State<GenerateProof> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletBloc = BlocProvider.of<WalletBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Proof"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Current Balance: ${walletBloc.balance.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Enter Amount to Generate Proof",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0.0;

                walletBloc.add(GenerateProofEvent(amount));

                // showing feedback and navigate back to home page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Proof generated for: $amount")),
                );
                Navigator.pop(context);
              },
              child: const Text("Generate Proof"),
            ),
          ],
        ),
      ),
    );
  }
}
