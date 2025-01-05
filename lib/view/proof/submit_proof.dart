import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/proof/bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/proof/state.dart';
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
        const SnackBar(content: Text("Please paste a valid proof")),
      );
      return;
    }

    try {
      // Parse the proof using the same format as generation
      if (proof.startsWith('PROOF_')) {
        final parts = proof.split('_');
        if (parts.length >= 2) {
          final amount = double.parse(parts[1]);

          // Check if proof exists in history
          final proofBloc = context.read<ProofBloc>();
          final proofs = (proofBloc.state as ProofUpdated).proofs;

          final proofExists = proofs.any((p) => p.proof == proof);

          if (proofExists) {
            final walletBloc = context.read<WalletBloc>();
            walletBloc.add(ClaimProofEvent(amount));

            // Remove the proof from history (optional)
            // proofBloc.add(RemoveProofEvent(proof));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Successfully claimed ${amount.toStringAsFixed(2)}!")),
            );

            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid or already claimed proof")),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid proof format")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid proof")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                labelText: "Paste Proof Here",
                border: OutlineInputBorder(),
              ),
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