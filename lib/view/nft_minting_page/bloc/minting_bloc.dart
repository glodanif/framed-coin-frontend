import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/repository/mint_repository.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/domain/minting_settings.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';

part 'minting_state.dart';

class MintingBloc extends Cubit<MintingState> {
  final MintRepository _mintRepository;
  final BlockchainConnectionManager _connection;

  late StreamSubscription<Connection> _streamSubscription;

  MintingBloc(
    this._mintRepository,
    this._connection,
  ) : super(MintingInitial()) {
    _streamSubscription = _connection.getEventsStream().listen(
      (state) {
        if (_connection.isConnectedToSupportedChain()) {
          loadMintingSettings();
        }
      },
    );
  }

  void loadMintingSettings() async {
    try {
      final settings = await _mintRepository.loadMintingSettings();
      if (settings.isPaused) {
        emit(PausedState());
      } else {
        emit(
          MintingSettingsState(
            mintingSettings: settings,
            chainInfo: _connection.chainInfo,
          ),
        );
      }
    } on JsLayerError catch (error) {
      emit(MintingSettingsUnavailableState(error: error));
    }
  }

  void mintNft(BigInt attachedValue) {
    _mintRepository.mintNft(attachedValue).listen((event) {
      emit(TxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        emit(MintingSettingsState(
          mintingSettings: _mintRepository.getMintingSettings(),
          chainInfo: _connection.chainInfo,
        ));
      } else {
        emit(TransactionFailedState(error: jsError));
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
