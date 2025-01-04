import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_wallet/repository/wallet_repository.dart';
import 'package:ocx_wallet/service/wallet/event.dart';
import 'package:ocx_wallet/service/wallet/state.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WalletBloc extends Bloc<WalletEvent, WalletState> {
  // repository wallet
  final WalletRepository _walletRepository;

  double balance = 0.0;
  double proofBalance = 10.0;
  String address = "";

  /// bloc constructor
  WalletBloc(this._walletRepository) : super(WalletInitialState()) {
    //
    /// event handler
    on<AppStartedEvent>(_appStarted);
    on<UnlockWalletEvent>(_unlockWallet);
    on<CreateWalletEvent>(_createWallet);
    on<SecureWalletEvent>(_secureWallet);
    on<OnboardingDoneEvent>(_onboardingDone);
    on<OnlineTransferEvent>(_onlineTransfer);
    on<GenerateProofEvent>(_generateProof);
  }

    // Handle proof generation
    void _generateProof(GenerateProofEvent event, Emitter<WalletState> emit) {
      if (event.amount > 0 && event.amount <= balance) {
        balance += event.amount;
        proofBalance += event.amount;
        emit(WalletUpdated(balance, proofBalance));
      } else {
        print("Invalid amount for proof generation");
      }
    }


    _init(Emitter emit) async {
      final prefs = await SharedPreferences.getInstance();

      if (!await _walletRepository.hasPhrase()) {
        if ((prefs.getBool('is_first_run') ?? true)) {
          // TODO: clean secure storage
          emit(OnBoardingState());
          return;
        }

        emit(NoWalletState());
        return;
      }

      if (!(prefs.getBool('is_wallet_secured') ?? false)) {
        emit(WalletNotSecuredState());
        return;
      } else {
        if (!(await _walletRepository.walletUnlocked())) {
          emit(UnlockWalletState());
          return;
        }

        balance = await _walletRepository.getBalance();
        address = await _walletRepository.getAddress();

        emit(WalletUnlockedState(balance));
        return;
      }
    }

    ///app started event handler
    _appStarted(AppStartedEvent event, Emitter emit) async {
      emit(SplashState());

      await _init(emit);
    }

    _onboardingDone(OnboardingDoneEvent event, Emitter emit) async {
      emit(SplashState());

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("is_first_run", false);

      await _init(emit);
    }

    /// unlock wallet event handlet
    _unlockWallet(UnlockWalletEvent event, Emitter emit) async {
      /// emit loading state
      emit(SplashState());

      /// check validate pin
      if (await _walletRepository.validPin(event.pin)) {
        /// unlock wallet
        await _walletRepository.unlockWallet(pin: event.pin);

        balance = await _walletRepository.getBalance();
        address = await _walletRepository.getAddress();

        print("balance in rands : $balance");

        // emit wallet unlocked state
        emit(WalletUnlockedState(balance));

        return;
      }

      emit(InvalidUnlockPinState());
    }

    /// create wallet event handler
    _createWallet(CreateWalletEvent event, Emitter emit) async {
      try {
        emit(SplashState());

        await _walletRepository.createWallet();

        emit(WalletNotSecuredState());
      } catch (e) {
        print(e.toString());
      }
    }

    _secureWallet(SecureWalletEvent event, Emitter emit) async {
      print("securing wallet");
      emit(SplashState());

      await _walletRepository.secureWallet(pin: event.pin);

      final prefs = await SharedPreferences.getInstance();

      prefs.setBool('is_wallet_secured', true);

      balance = await _walletRepository.getBalance();
      address = await _walletRepository.getAddress();

      emit(WalletUnlockedState(balance));
    }

    _onlineTransfer(OnlineTransferEvent event, Emitter emit) async {
      emit(WalletLoadingState());

      try {
        await _walletRepository.transfer(
          recipient: event.recipient,
          amount: event.amount,
        );
        emit(TransferSuccessState());
      } catch (e) {
        emit(WalletFailureState(e.toString()));
      }
    }
  }
