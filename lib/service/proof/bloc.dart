import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/models/proof_data.dart';
import 'package:ocx_wallet/service/proof/event.dart';
import 'package:ocx_wallet/service/proof/state.dart';

class ProofBloc extends Bloc<ProofEvent, ProofState> {
  List<ProofData> proofs = [];

  ProofBloc() : super(ProofInitial()) {
    on<AddProofEvent>(_onAddProof);
    on<MarkProofAsSubmittedEvent>(_onMarkProofAsSubmitted);
  }

  void _onAddProof(AddProofEvent event, Emitter<ProofState> emit) {
    proofs.insert(0, event.proofData);
    emit(ProofUpdated(proofs: proofs));
  }

  void _onMarkProofAsSubmitted(MarkProofAsSubmittedEvent event, Emitter<ProofState> emit) {
    if (state is ProofUpdated) {
      final currentState = state as ProofUpdated;
      final updatedSubmittedProofs = Set<String>.from(currentState.submittedProofs)
        ..add(event.proof);

      emit(currentState.copyWith(
        submittedProofs: updatedSubmittedProofs,
      ));
    }
  }
}