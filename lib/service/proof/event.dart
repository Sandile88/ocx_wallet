import 'package:ocx_wallet/models/proof_data.dart';

abstract class ProofEvent {}

class AddProofEvent extends ProofEvent {
  final ProofData proofData;

  AddProofEvent(this.proofData);
}

class MarkProofAsSubmittedEvent extends ProofEvent {
  final String proof;

  MarkProofAsSubmittedEvent(this.proof);
}