import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/proof/bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/proof/state.dart';
import 'package:ocx_wallet/service/proof/event.dart';
import 'package:ocx_wallet/models/proof_data.dart';
import 'package:ocx_wallet/service/wallet/event.dart';

class SubmitProofPage extends StatefulWidget {
  const SubmitProofPage({super.key});

  @override
  _SubmitProofPageState createState() => _SubmitProofPageState();
}

class _SubmitProofPageState extends State<SubmitProofPage> {
  final TextEditingController _proofController = TextEditingController();

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _checkIfProofAlreadySubmitted(String proof) async {
    final proofBloc = context.read<ProofBloc>();
    if (proofBloc.state is! ProofUpdated) return false;

    final proofs = (proofBloc.state as ProofUpdated).proofs;
    final submittedProofs = (proofBloc.state as ProofUpdated).submittedProofs;

    // checking proofs aren't submitted yet)
    final proofExists = proofs.any((p) => p.proof == proof);
    if (!proofExists) return false;

    // and then checking if they have
    return submittedProofs.contains(proof);
  }

  void _submitProof() async {
    final proof = _proofController.text.trim();

    if (proof.isEmpty) {
      _showErrorSnackBar("Please paste a valid proof");
      return;
    }

    try {
      final isAlreadySubmitted = await _checkIfProofAlreadySubmitted(proof);
      if (isAlreadySubmitted) {
        _showErrorSnackBar("This proof has already been submitted");
        return;
      }

      if (proof.startsWith('PROOF_')) {
        final parts = proof.split('_');
        if (parts.length >= 2) {
          final amount = double.parse(parts[1]);

          final proofBloc = context.read<ProofBloc>();
          final proofs = (proofBloc.state as ProofUpdated).proofs;

          final proofExists = proofs.any((p) => p.proof == proof);

          if (proofExists) {
            proofBloc.add(MarkProofAsSubmittedEvent(proof));

            final walletBloc = context.read<WalletBloc>();
            walletBloc.add(ClaimProofEvent(amount));

            _showSuccessSnackBar("Successfully claimed ${amount.toStringAsFixed(2)}!");

            _proofController.clear();

            Navigator.pop(context);
          } else {
            _showErrorSnackBar("Invalid or non-existent proof");
          }
        } else {
          _showErrorSnackBar("Invalid proof format");
        }
      } else {
        _showErrorSnackBar("Invalid proof format - must start with 'PROOF_'");
      }
    } catch (e) {
      _showErrorSnackBar("Invalid proof format");
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
                hintText: "Enter your proof code",
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