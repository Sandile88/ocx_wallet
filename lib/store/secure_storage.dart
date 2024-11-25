import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;

  SecureStorage._(this._storage);

  factory SecureStorage() =>
      _instance ??= SecureStorage._(const FlutterSecureStorage());

  final FlutterSecureStorage _storage;

  static const _mnemonicKey = "SEED_PHRASE";
  static const _walletKey = "WALLET";
  static const _balanceKey = "BALANCE";
  static const _pinKey = "PIN";

  Future<void> persistMnemonic(String mnemonic) async {
    await _storage.write(key: _mnemonicKey, value: mnemonic);
  }

  Future<void> persistAccount(
      {String? wallet, String? balance, String? pin}) async {
    if (wallet != null) {
      await _storage.write(key: _walletKey, value: wallet);
    }

    if (balance != null) {
      await _storage.write(key: _balanceKey, value: balance);
    }

    if (pin != null) {
      await _storage.write(key: _pinKey, value: pin);
    }
  }

  Future<String?> getMnemonic() async {
    return await _storage.read(key: _mnemonicKey);
  }

  Future<Map<String, String?>> getAccount() async {
    String? wallet = await _storage.read(key: _walletKey);
    String? balance = await _storage.read(key: _balanceKey);

    return {"wallet": wallet, "balance": balance};
  }

  Future<String?> getHashedPin() async {
    return _storage.read(key: _pinKey);
  }

  Future<bool> hasPhrase() async {
    var value = await _storage.read(key: _mnemonicKey);
    return value != null;
  }
}
