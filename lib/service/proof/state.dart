import 'package:ocx_wallet/models/proof_data.dart';

abstract class ProofState {}

class ProofInitial extends ProofState {}

class ProofUpdated extends ProofState {
  final List<ProofData> proofs;

  ProofUpdated(this.proofs);
}