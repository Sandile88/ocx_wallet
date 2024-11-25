import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/transaction/event.dart';
import 'package:ocx_wallet/service/transaction/state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<TransactionPayEvent>(_payHandler);
  }

  _payHandler(TransactionPayEvent event, Emitter emit) async {}
}
