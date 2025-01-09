import 'package:flutter/material.dart';
import 'package:ocx_wallet/homescreen.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MetaMaskConnect extends StatefulWidget {
  const MetaMaskConnect({Key? key}) : super(key: key);

  @override
  State<MetaMaskConnect> createState() => _MetaMaskConnectState();
}

class _MetaMaskConnectState extends State<MetaMaskConnect> {
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'OCX',
          description: 'An app for enabling offline transanctions',
          url: 'https://walletconnect.org',
          icons: [
            ''
          ]
      )
  );

  var _session;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        setState(() {
          _session = session;
        });
        if (_session != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Nextscreenui(
                walletaddress: session.accounts[0].toString(),
              ),
            ),
          );
        }
      } catch (exp) {
        print(exp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
      'connect',
          (session) => setState(() {
        _session = session;
      }),
    );

    connector.on(
      'session_update',
          (payload) => setState(() {
        _session = payload;
        print(_session.accounts[0]);
        print(_session.chainId);
      }),
    );

    connector.on(
      'disconnect',
          (payload) => setState(() {
        _session = null;
      }),
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => loginUsingMetamask(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.account_balance_wallet),
          SizedBox(width: 8),
          Text('Connect Wallet'),
        ],
      ),
    );
  }
}