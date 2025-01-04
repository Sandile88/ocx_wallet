import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/models/proof_data.dart';
import 'package:ocx_wallet/service/proof/bloc.dart';
import 'package:ocx_wallet/service/proof/state.dart';
import 'package:ocx_wallet/utils/clipboard_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HistoryProofPage extends StatelessWidget {
  const HistoryProofPage({super.key});

  Widget _buildProofHistoryItem(BuildContext context, ProofData record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            QrImageView(
              data: record.proof,
              size: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.amount.toStringAsFixed(2)} uzar',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await ClipboardUtil.copyToClipboard(record.proof);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proof copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proof History"),
      ),
      body: BlocBuilder<ProofBloc, ProofState>(
        builder: (context, state) {
          if (state is ProofUpdated) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Proof History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.proofs.length,
                    itemBuilder: (context, index) {
                      return _buildProofHistoryItem(context, state.proofs[index]);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No proofs generated yet"));
        },
      ),
    );
  }
}