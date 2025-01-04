import 'package:ocx_wallet/models/proof_data.dart';

abstract class ProofEvent {}

class AddProofEvent extends ProofEvent {
  final ProofData proofData;

  AddProofEvent(this.proofData);
}