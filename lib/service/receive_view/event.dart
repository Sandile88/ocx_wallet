import 'package:equatable/equatable.dart';
import 'package:ocx_wallet/constants/type.dart';

class ReceiveViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnSwitchReceiveView extends ReceiveViewEvent {
  final Receiveview type;

  OnSwitchReceiveView(this.type);

  @override
  List<Object?> get props => [type];
}
