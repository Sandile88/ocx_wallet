import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';
import 'package:ocx_wallet/models/proof_data.dart';
import 'package:ocx_wallet/utils/clipboard_util.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class GenerateProof extends StatefulWidget {
  const GenerateProof({Key? key}) : super(key: key);

  @override
  _GenerateProofState createState() => _GenerateProofState();
}

class _GenerateProofState extends State<GenerateProof> {
  final TextEditingController _amountController = TextEditingController();
  final List<ProofData> _proofHistory = [];

  void _showProofDialog(String proof, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generated Proof'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Scan QR Code:'),
                const SizedBox(height: 20),
                QrImageView(
                  data: proof,
                  size: 200,
                ),
                const SizedBox(height: 20),
                const Text('Or copy the proof text:'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          proof,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          await ClipboardUtil.copyToClipboard(proof);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Proof copied to clipboard')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _proofHistory.insert(
                    0,
                    ProofData(
                      date: DateFormat('MMM dd, yyyy').format(DateTime.now()),
                      amount: amount,
                      proof: proof,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Submit Proof'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProofHistoryItem(ProofData record) {
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
                    '${record.amount.toStringAsFixed(2)} tokens',
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
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proof copied to clipboard')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletBloc = BlocProvider.of<WalletBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Proof"),
      ),
      body: Column(
        children: [
          Padding(
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
                  decoration: const InputDecoration(
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

                    // In real app, you would get the actual proof from the bloc
                    final mockProof = "mock_proof_${DateTime.now().millisecondsSinceEpoch}";
                    _showProofDialog(mockProof, amount);
                  },
                  child: const Text("Generate Proof"),
                ),
              ],
            ),
          ),
          const Divider(),
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
              itemCount: _proofHistory.length,
              itemBuilder: (context, index) {
                return _buildProofHistoryItem(_proofHistory[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}