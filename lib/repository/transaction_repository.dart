// import 'package:ether_dart/ether_dart.dart';
// import 'package:http/http.dart' as http;
// import 'package:ocx_wallet/repository/wallet_repository.dart';

// abstract class TransactionRepository {
//   Future<void> pay();
// }

// class TransactionRepositoryImpl {
//   late final Web3Client ethClient;
//   final WalletRepository _walletRepository;
//   TransactionRepositoryImpl(this._walletRepository) {
//     var client = http.Client();
//     ethClient = Web3Client("", client);
//   }

//   Future<void> pay({required String amount}) async {
//     // get rpc

//     // var credentials = EthPrivateKey.fromHex("0x...");

//     var credentials = _walletRepository.

//     await ethClient.sendTransaction(
//       credentials,
//       Transaction(
//         to: EthereumAddress.fromHex('0xC91...3706'),
//         gasPrice: EtherAmount.inWei(BigInt.one),
//         maxGas: 100000,
//         value: EtherAmount.fromBase10String(EtherUnit.ether, amount),
//       ),
//     );

//     // get nonce

//     // create a transaction

//     // send a transaction
//   }
// }
