import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/type.dart';
import 'package:ocx_wallet/service/receive_view/bloc.dart';
import 'package:ocx_wallet/service/receive_view/event.dart';
import 'package:ocx_wallet/service/receive_view/state.dart';
import 'package:ocx_wallet/utils/icons/nfc_outlined_icons.dart';
import 'package:ocx_wallet/view/common/nfc_animation.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ReceiveView extends StatelessWidget {
  const ReceiveView({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Receive",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<ReceiveViewBloc>(context)
                            .add(OnSwitchReceiveView(Receiveview.qrcode));
                      },
                      icon: const Icon(
                        Icons.qr_code_scanner_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<ReceiveViewBloc>(context)
                            .add(OnSwitchReceiveView(Receiveview.nfcscan));
                      },
                      icon: const Icon(
                        Nfc_outlined.nfc_outlined,
                        size: 38,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 64,
            ),
            BlocBuilder<ReceiveViewBloc, ReceiveviewState>(
                builder: (context, state) {
              if (state is QRcodeView) {
                return Column(
                  children: [
                    QrCodeContainer(address: address),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      address,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              }

              return const NFCPulseAnimation();
            })
          ],
        ),
      ),
    );
  }
}

class QrCodeContainer extends StatefulWidget {
  const QrCodeContainer({super.key, required this.address});

  final String address;

  @override
  State<QrCodeContainer> createState() => _QrCodeContainerState();
}

class _QrCodeContainerState extends State<QrCodeContainer> {
  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();

    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData(widget.address);

    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.width / 1.5,
      width: size.width / 1.5,
      child: PrettyQrView(
        qrImage: qrImage,
        decoration: const PrettyQrDecoration(),
      ),
    );
  }
}
