import 'dart:ffi';
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

    print("hashed Password : $hashedPin");

    final h = Crypt.sha256(pin, salt: salt);

    return h.hash == hashedPin;
  }

  @override
  Future<bool> walletUnlocked() async {
    return _wallet != null;
  }

  @override
  Future<double> getBalance() async {
    var apiUrl = dotenv.get("LISK_RPC");
    var chainId = dotenv.getInt("LISK_CHAIN_ID");

    http.Client httpClient = http.Client();

    var ethClient = Web3Client(apiUrl, httpClient);

    EthereumAddress address = EthereumAddress.fromHex(_localAccount!.address);

    var _balance = await getERC20Balance(
        address.hex, "0x8a21CF9Ba08Ae709D64Cb25AfAA951183EC9FF6D");

    print("balance of erc20 token : ${_balance}");

    EtherAmount balance = await ethClient.getBalance(address);
    // print(balance.getValueInUnit(EtherUnit.ether));

    print("balance in ether ${balance.getValueInUnit(EtherUnit.ether)}");

    double randAmount = balance.getValueInUnit(EtherUnit.ether) * 62093.92;

    return randAmount;
  }

  @override
  Future<String> getAddress() async {
    return _localAccount!.address;
  }

  @override
  Future<void> transfer(
      {required String amount, required String recipient}) async {
    print("This is the amount : $amount");
    print("This is the address : $recipient");
    var apiUrl = dotenv.get("SCROLL_RPC");
    var chainId = dotenv.getInt("SCROLL_CHAIN_ID");

    http.Client httpClient = http.Client();

    var ethClient = Web3Client(apiUrl, httpClient);

    // var credentials = EthPrivateKey.fromHex("0x...");

    print(
      "This is my address : ${_wallet!.privateKey.address.hex}",
    );

    String _amount = (double.parse(amount) * pow(10, 18)).toStringAsFixed(0);

    print("This is my amount : ${_amount}");

    await ethClient.sendTransaction(
      _wallet!.privateKey,
      chainId: chainId,
      Transaction(
        to: EthereumAddress.fromHex(recipient),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 3000000,
        value: EtherAmount.fromBase10String(EtherUnit.wei, _amount),
      ),
    );
  }

  // @override
  Future<BigInt> getERC20Balance(String address, String contractAddress) async {
    // Replace with your Ethereum node URL (e.g., Infura, Alchemy)
    final client = Web3Client(
        'https://mainnet.infura.io/v3/YOUR-PROJECT-ID', http.Client());

    // ABI for ERC20 standard balance function
    final contract = DeployedContract(
        ContractAbi.fromJson(
            '[{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"type":"function"}]',
            'ERC20'),
        EthereumAddress.fromHex(contractAddress));

    // Prepare the function call
    final balanceFunction = contract.function('balanceOf');

    try {
      // Call balanceOf function
      final result = await client.call(
          contract: contract,
          function: balanceFunction,
          params: [EthereumAddress.fromHex(address)]);

      // The first result is the balance
      return result[0] as BigInt;
    } catch (e) {
      print('Error fetching balance: $e');
      return BigInt.zero;
    } finally {
      client.dispose();
    }
  }
}



 // ///Verify seed phrase
      // if (memonicPhrase != null) {
      //   etherDart.verifyMemonicPhrase(memonicPhrase);
      // }

      // final wallet = etherDart.walletFromMemonicPhrase(memonicPhrase!);

      // EthPrivateKey privKey = EthPrivateKey.fromHex(wallet!.privateKey!);

      // return
