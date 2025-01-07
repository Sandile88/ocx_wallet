import 'package:ocx_wallet/models/proof_data.dart';

abstract class ProofState {}

class ProofInitial extends ProofState {}

// class ProofUpdated extends ProofState {
//   final List<ProofData> proofs;
//
//   ProofUpdated(this.proofs);
// }

class ProofUpdated extends ProofState {
  final List<ProofData> proofs;
  final Set<String> submittedProofs; // this track proofs that have already been submitted

  ProofUpdated({
    required this.proofs,
    Set<String>? submittedProofs,
  }) : submittedProofs = submittedProofs ?? {};

  ProofUpdated copyWith({
    List<ProofData>? proofs,
    Set<String>? submittedProofs,
  }) {
    return ProofUpdated(
      proofs: proofs ?? this.proofs,
      submittedProofs: submittedProofs ?? this.submittedProofs,
    );
  }
}
