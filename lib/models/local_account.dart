import 'package:web3dart/web3dart.dart';

class LocalAccount {
  final Wallet _wallet;
  final double balance;
  final List<String> transactions;

  LocalAccount(
    this._wallet, {
    required this.balance,
    required this.transactions,
  });

  String get address => _wallet.privateKey.address.hex;
}
