import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/pay_view/event.dart';
import 'package:ocx_wallet/service/pay_view/state.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';

class PayviewBloc extends Bloc<PayviewEvent, PayviewState> {
  WalletBloc walletBloc;
  PayviewBloc(this.walletBloc)
      : super(
          const PayviewState(
            amount: "",
            recipient: "",
            view: Payview.enterAddress,
            isError: false,
            isSuccess: false,
            error: "",
            isLoading: false,
          ),
        ) {
    on<OnAmountChanged>(_amountChangedHandler);
    on<OnAddressChanged>(_recipientChangedHandler);
    on<OnSwitchViewEvent>(_switchView);
    on<OnQrCodeScannedWEvent>(_qrCodeScanned);
    on<OnDoneEvent>(_onDone);
    on<OnErrorEvent>(_onError);
    on<OnSuccessEvent>(_onSuccess);
    on<OnOnlineTransferEvent>(_onlineTransfer);
  }

  _onlineTransfer(OnOnlineTransferEvent event, Emitter emit) async {
    print("ooooooooooooooooooooooooooooo");
    print("${state.amount} ${state.recipient}");
    walletBloc.add(
        OnlineTransferEvent(amount: state.amount, recipient: state.recipient));
  }

  _onDone(OnDoneEvent event, Emitter emit) {
    emit(state.copyWith(isError: false, isSuccess: false, isLoading: false));
  }

  _onError(OnErrorEvent event, Emitter emit) {
    emit(state.copyWith(
      isLoading: false,
      isSuccess: false,
      isError: true,
      error: event.message,
    ));
  }

  _onSuccess(OnSuccessEvent event, Emitter emit) {
    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,
      isError: false,
      error: "",
    ));
  }

  _switchView(OnSwitchViewEvent event, Emitter emit) {
    print("nfkdnfknsdknfkdsnfk");
    emit(state.copyWith(view: event.view));
  }

  _qrCodeScanned(OnQrCodeScannedWEvent event, Emitter emit) {
    emit(state.copyWith(recipient: event.address, view: Payview.enterAddress));
  }

  _amountChangedHandler(OnAmountChanged event, Emitter emit) {
    emit(state.copyWith(amount: event.amount));
  }

  _recipientChangedHandler(OnAddressChanged event, Emitter emit) {
    emit(state.copyWith(recipient: event.address));
  }
}
