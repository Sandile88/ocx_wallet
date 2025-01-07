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
  final List<ProofData> _pendingProofs = [];
  bool _isQrVisible = false;

  void _showSuccessNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Proof submitted successfully!'),
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


  void _showProofDialog(ProofData proofData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Proof Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('QR Code:'),
                    const SizedBox(height: 20),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       _isQrVisible = !_isQrVisible;
                    //     });
                    //   },
                      Container(
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
                              data: proofData.proof,
                              size: 300,
                            ),
                            // if (!_isQrVisible)
                            //   Container(
                            //     width: 300,
                            //     height: 300,
                            //     decoration: BoxDecoration(
                            //       color: Colors.grey.withOpacity(1.0),
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //     child: const Center(
                            //       child: Text(
                            //         'Tap to Reveal',
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                    // ),
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
                              proofData.proof,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () async {
                              await ClipboardUtil.copyToClipboard(proofData.proof);
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
                    context.read<ProofBloc>().add(AddProofEvent(proofData));
                    context.read<WalletBloc>().add(GenerateProofEvent(proofData.amount));

                    // remove from pending proofs
                    setState(() {
                      _pendingProofs.removeWhere((proof) => proof.proof == proofData.proof);
                    });

                    Navigator.of(context).pop();
                    _showSuccessNotification();
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPendingProofItem(ProofData record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () => _showProofDialog(record),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.qr_code, size: 30),
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
              const Icon(Icons.chevron_right),
            ],
          ),
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
                    if (amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid amount')),
                      );
                      return;
                    }

                    final proof = 'PROOF_${amount.toStringAsFixed(2)}_${DateTime.now().millisecondsSinceEpoch}';
                    final proofData = ProofData(
                      date: DateFormat('MMM dd, yyyy').format(DateTime.now()),
                      amount: amount,
                      proof: proof,
                    );

                    setState(() {
                      _pendingProofs.insert(0, proofData);
                    });

                    _amountController.clear();
                  },
                  child: const Text("Generate Proof"),
                ),
              ],
            ),
          ),
          const Divider(),
          if (_pendingProofs.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Pending Proofs",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _pendingProofs.length,
                itemBuilder: (context, index) {
                  return _buildPendingProofItem(_pendingProofs[index]);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}