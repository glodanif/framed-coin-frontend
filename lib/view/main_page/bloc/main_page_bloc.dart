import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/error_code.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';

part 'main_page_state.dart';

class MainPageBloc extends Cubit<MainPageState> {
  final SupportedChains _supportedChains;
  final BlockchainConnectionManager _connection;

  late StreamSubscription<Connection> _streamSubscription;

  MainPageBloc(
    this._supportedChains,
    this._connection,
  ) : super(MainPageInitial()) {
    _streamSubscription = _connection.getEventsStream().listen(
      (state) {
        checkConnection();
      },
    );
  }

  void checkConnection() {
    emit(ConnectionChangedState(
      accountAddress: _connection.userAddress,
      chainInfo: _connection.chainInfo,
      supportedChains: _supportedChains.getSupportedChains(),
    ));
  }

  void requestAccount() async {
    emit(ConnectingWalletState());
    try {
      await _connection.requestAccount();
    } on JsLayerError catch (error) {
      if (error.code == ErrorCode.providerMissing) {
        emit(ProviderMissingState(error: error));
      } else {
        if (!error.isUserRejection()) {
          emit(ErrorState(error: error));
        }
        checkConnection();
      }
    }
  }

  void switchChain(int chainId) async {
    try {
      await _connection.switchChain(chainId);
    } on JsLayerError catch (error) {
      if (!error.isUserRejection()) {
        emit(ErrorState(error: error));
      }
      emit(ConnectionChangedState(
        accountAddress: _connection.userAddress,
        chainInfo: _connection.chainInfo,
        supportedChains: _supportedChains.getSupportedChains(),
      ));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
