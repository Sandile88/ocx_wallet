import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/service/pay_view/event.dart';
import 'package:ocx_wallet/service/pay_view/state.dart';

class PayviewBloc extends Bloc<PayviewEvent, PayviewState> {
  PayviewBloc() : super(const PayviewState(amount: "", recipient: "")) {
    on<OnAmountChanged>(_amountChangedHandler);
    on<OnAddressChanged>(_recipientChangedHandler);
  }

  _amountChangedHandler(OnAmountChanged event, Emitter emit) {
    emit(state.copyWith(amount: event.amount));
  }

  _recipientChangedHandler(OnAddressChanged event, Emitter emit) {
    emit(state.copyWith(recipient: event.address));
  }
}
