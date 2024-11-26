import 'dart:math';

import 'package:crypt/crypt.dart';
import 'package:ether_dart/ether_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ocx_wallet/models/local_account.dart';
import 'package:ocx_wallet/repository/wallet_repository.dart';
import 'package:ocx_wallet/store/secure_storage.dart';
import 'package:http/http.dart' as http;

const salt = r'2b06C6UzMDM.H6dfI/f/IKxGhu';

class WalletRepositoryimpl implements WalletRepository {
  LocalAccount? _localAccount;
  Wallet? _wallet;
  final SecureStorage _secureStorage;

  WalletRepositoryimpl(this._secureStorage);

  @override
  Future<void> secureWallet({required String pin}) async {
    /// read memonic phrase from secure storage
    String? phrase = await _secureStorage.getMnemonic();

    final etherDart = EtherDart();

    /// TODO: Verify seed phrase
    // if (phrase != null) {
    //   etherDart.verifyMemonicPhrase(phrase);

    // }

    /// create new [EtherWallet] from phrase
    final etherWallet = etherDart.walletFromMemonicPhrase(phrase!);

    /// create privKey from Hex String
    EthPrivateKey privKey = EthPrivateKey.fromHex(etherWallet!.privateKey!);

    /// generate secure random
    var rng = Random.secure();

    /// create encrypted wallet from privkey, provided pin, and generated secure random
    Wallet wallet = Wallet.createNew(privKey, pin, rng);

    _wallet = wallet;

    final hash = Crypt.sha256(pin, salt: salt);

    /// persist wallet to secure storage
    await _secureStorage.persistAccount(
      wallet: wallet.toJson(),
      pin: hash.hash,
    );

    /// create localaccount instance from wallet, balance and transactions
    _localAccount = LocalAccount(
      wallet,
      balance: 0,
      transactions: List.empty(),
    );
  }

  @override
  Future<void> unlockWallet({required String pin}) async {
    /// get wallet, balance
    Map<String, String?> encryptedAccount = await _secureStorage.getAccount();

    /// decrypt wallet
    Wallet wallet = Wallet.fromJson(encryptedAccount['wallet']!, pin);

    _wallet = wallet;

    /// create local account from wallet, balance, and transactions
    _localAccount = LocalAccount(
      wallet,
      balance: double.parse(encryptedAccount['balance'] ?? "0.00"),
      transactions: List.empty(),
    );
  }

  @override
  Future<void> createWallet() async {
    try {
      ///Create EtherDart without immediate connection
      final etherDart = EtherDart();

      ///Generate memomic phrase (can be called seed phrase (Eg : cow ram pig goat ))
      final memonicPhrase = etherDart.generateMemonicPhrase();

      // persist unsecured memonic phrase
      await _secureStorage.persistMnemonic(memonicPhrase!);

      // persist unsecured mnemonic
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> hasPhrase() async {
    return await _secureStorage.hasPhrase();
  }

  @override
  Future<bool> validPin(String pin) async {
    String? hashedPin = await _secureStorage.getHashedPin();

    final h = Crypt(hashedPin!);

    return !h.match(pin);
  }

  @override
  Future<bool> walletUnlocked() async {
    return _wallet != null;
  }

  @override
  Future<void> transfer(
      {required String amount, required String recipient}) async {
    var apiUrl = dotenv.get("LISK_RPC");
    // var chainId = dotenv.getInt("LISK_CHAIN_ID");

    http.Client httpClient = http.Client();

    var ethClient = Web3Client(apiUrl, httpClient);

    // var credentials = EthPrivateKey.fromHex("0x...");

    await ethClient.sendTransaction(
      _wallet!.privateKey,
      // chainId: chainId,
      Transaction(
        to: EthereumAddress.fromHex(amount),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromBase10String(EtherUnit.ether, amount),
      ),
    );
  }
}



 // ///Verify seed phrase
      // if (memonicPhrase != null) {
      //   etherDart.verifyMemonicPhrase(memonicPhrase);
      // }

      // final wallet = etherDart.walletFromMemonicPhrase(memonicPhrase!);

      // EthPrivateKey privKey = EthPrivateKey.fromHex(wallet!.privateKey!);

      // return
