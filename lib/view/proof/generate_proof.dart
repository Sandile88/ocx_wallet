import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';
import 'package:ocx_wallet/service/proof/bloc.dart';
import 'package:ocx_wallet/service/proof/event.dart';
import 'package:ocx_wallet/models/proof_data.dart';
import 'package:ocx_wallet/utils/clipboard_util.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ocx_wallet/view/home/home_view.dart';


class GenerateProof extends StatefulWidget {
  const GenerateProof({Key? key}) : super(key: key);

  @override
  _GenerateProofState createState() => _GenerateProofState();
}

class _GenerateProofState extends State<GenerateProof> {
  final TextEditingController _amountController = TextEditingController();
  bool _isQrVisible = false;

  void _showSuccessNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Proof generated successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(seconds: 0), () {
      Navigator.pushAndRemoveUntil(
        context,
          MaterialPageRoute(builder: (context) => const HomeView()),
          (route) => false,
        );
      });
  }

  void _showProofDialog(String proof, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Generated Proof'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tap to reveal QR Code:'),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isQrVisible = !_isQrVisible;
                          });
                        },
                        child: Container(
                          width: 800,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              QrImageView(
                                data: proof,
                                size: 300,
                              ),
                              if (!_isQrVisible)
                                Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(1.0),
                                    borderRadius: BorderRadius.circular(8),
                                    backgroundBlendMode: BlendMode.srcOver,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Tap to Reveal',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
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
                      final proofData = ProofData(
                        date: DateFormat('MMM dd, yyyy').format(DateTime.now()),
                        amount: amount,
                        proof: proof,
                      );
                      context.read<ProofBloc>().add(AddProofEvent(proofData));
                      Navigator.of(context).pop();
                      _showSuccessNotification();
                    },
                    child: const Text('Done'),
                  ),
                ],
              );
            }
        );
      },
    );
  }

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
                final mockProof = "mock_proof_${DateTime.now().millisecondsSinceEpoch}";
                setState(() {
                  _isQrVisible = false;
                });
                _showProofDialog(mockProof, amount);
              },
              child: const Text("Generate Proof"),
            ),
          ],
        ),
      ),
    );
  }
}