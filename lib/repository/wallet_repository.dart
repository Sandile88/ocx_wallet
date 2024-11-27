abstract class WalletRepository {
  Future<void> createWallet();
  Future<void> unlockWallet({required String pin});
  Future<void> secureWallet({required String pin});
  Future<bool> hasPhrase();
  Future<bool> validPin(String pin);
  Future<bool> walletUnlocked();
  // Future<void> transfer({required String recipient, required String amount});

  Future<double> getBalance();

  Future<String> getAddress();

  Future<void> transfer({required String amount, required String recipient});
}
