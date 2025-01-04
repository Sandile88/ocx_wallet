import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/models/proof_data.dart';
import 'package:ocx_wallet/service/wallet/event.dart';


class SubmitProofPage extends StatefulWidget {
  const SubmitProofPage({super.key});

  @override
  _SubmitProofPageState createState() => _SubmitProofPageState();
}

class _SubmitProofPageState extends State<SubmitProofPage> {
  final TextEditingController _proofController = TextEditingController();

  void _submitProof() {
    final proof = _proofController.text.trim();
    if (proof.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please paste a valid proof.")),
      );
      return;
    }

    /// retrieving proof
    ProofData? proofData = _getProofDataFromProof(proof);

    if (proofData != null) {
      final walletBloc = BlocProvider.of<WalletBloc>(context);
      walletBloc.add(GenerateProofEvent(proofData.amount));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Proof claimed successfully!")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid proof!")),
      );
    }
  }

  ProofData? _getProofDataFromProof(String proof) {
    final proofList = <ProofData>[];

    proofList.add(ProofData(date: "Jan 01, 2025", amount: 10.0, proof: "mock_proof_1"));
    proofList.add(ProofData(date: "Jan 02, 2025", amount: 20.0, proof: "mock_proof_2"));

    print('Pasted Proof: $proof');

    for (var item in proofList) {
      print('Checking proof: ${item.proof}'); /
    }

    return proofList.firstWhere(
          (element) => element.proof == proof,
      orElse: () => ProofData(date: "Unknown", amount: 0.0, proof: "Unknown"),

    );
  }



  @override
  Widget build(BuildContext context) {
    final TextEditingController _proofController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Proof"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _proofController,
              decoration: const InputDecoration(
                labelText: "Enter Proof ",
                border: OutlineInputBorder(),
              ),
              // keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProof,
              child: const Text("Submit Proof"),
            ),
          ],
        ),
      ),
    );
  }
}
