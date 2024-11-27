import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/constants/colors.dart';
import 'package:ocx_wallet/service/wallet/bloc.dart';
import 'package:ocx_wallet/view/home/balance.dart';
import 'package:ocx_wallet/view/home/transaction_options.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 64.0,
            right: 20.0,
            left: 20.0,
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
                child: Text(
                  "JD",
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Balance(),
              const SizedBox(
                height: 20.0,
              ),
              BlocProvider.value(
                value: BlocProvider.of<WalletBloc>(context),
                child: const TransactionOptions(),
              ),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                children: [
                  Text(
                    "Assets",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              AssetsView(),
            ],
          ),
        ),
      ),
    );
  }
}

class Asset {
  final String imageUrl;
  final double balance;
  final String name;
  final double value;

  Asset(
      {required this.balance,
      required this.imageUrl,
      required this.name,
      required this.value});
}

class AssetsView extends StatelessWidget {
  AssetsView({super.key});

  final List<Asset> assets = [
    Asset(
      balance: 0,
      imageUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1214.png",
      name: "LSK",
      value: 1.18,
    ),
    Asset(
        balance: 0,
        value: 0.99,
        imageUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/825.png",
        name: "USDT"),
    Asset(
        balance: 0,
        value: 0.99,
        imageUrl:
            "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
        name: "USDC"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (Asset asset in assets)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: AssetTile(asset: asset),
          ),
      ],
    );
  }
}

class AssetTile extends StatelessWidget {
  const AssetTile({super.key, required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(asset.imageUrl),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Column(
              children: [
                Text(
                  asset.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primary,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  "\$${asset.value.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
        ),
        Text(
          "\$${asset.balance.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 22.0,
          ),
        )
      ],
    );
  }
}
