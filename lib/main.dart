import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/app_wrapper.dart';
import 'package:ocx_wallet/repository/wallet_repositoryimpl.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/service/wallet/event.dart';
import 'package:ocx_wallet/store/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(OcxApp());
}

class OcxApp extends StatelessWidget {
  OcxApp({super.key});

  final SecureStorage secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(WalletRepositoryimpl(secureStorage))
        ..add(
          AppStartedEvent(),
        ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const AppWrapper(),
      ),
    );
  }
}