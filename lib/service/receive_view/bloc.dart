import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/receive_view/event.dart';
import 'package:ocx_wallet/service/receive_view/state.dart';

class ReceiveViewBloc extends Bloc<ReceiveViewEvent, ReceiveviewState> {
  ReceiveViewBloc() : super(QRcodeView()) {
    on<OnSwitchReceiveView>(_switch);
  }

  _switch(OnSwitchReceiveView event, Emitter emit) {
    if (event.type == Receiveview.qrcode) {
      emit(QRcodeView());
    } else {
      emit(NfcScanView());
    }
  }
}
