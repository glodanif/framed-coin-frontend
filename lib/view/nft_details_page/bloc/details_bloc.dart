import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/repository/nft_repository.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/error_code.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/view/common/nft_converter.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';

part 'details_state.dart';

class DetailsBloc extends Cubit<DetailsState> {
  final NftRepository _nftRepository;
  final NftConverter _nftConverter;
  final BlockchainConnectionManager _connection;

  late StreamSubscription<Connection> _streamSubscription;

  DetailsBloc(
    this._nftRepository,
    this._nftConverter,
    this._connection,
  ) : super(DetailsInitial()) {
    _streamSubscription = _connection.getEventsStream().listen(
      (state) {
        if (_connection.isConnectedToSupportedChain()) {
          loadNftDetails();
        }
      },
    );
  }

  void loadNftDetails() async {
    emit(DetailsInitial());
    try {
      final nft = await _nftRepository.loadNftDetails();
      if (nft.owner.toLowerCase() == _connection.userAddress?.toLowerCase()) {
        _convertAndDisplay();
      } else {
        emit(StrangerViewState());
      }
    } on JsLayerError catch (error) {
      if (error.code == ErrorCode.fcNotFound) {
        emit(NftNotFoundState(error: error));
      } else {
        emit(NftUnavailableState(error: error));
      }
    }
  }

  void cashOutNft() {
    _nftRepository.cashOutNft().listen((event) {
      emit(CashOutTxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        _convertAndDisplay();
      } else {
        emit(TransactionFailedState(error: jsError));
      }
    });
  }

  void burnNft() {
    _nftRepository.burnNft().listen((event) {
      emit(BurnTxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        _convertAndDisplay();
      } else {
        emit(TransactionFailedState(error: jsError));
      }
    });
  }

  void downloadNft(fileName, x, y, width, height) async {
    try {
      await _nftRepository.downloadNft(fileName, x, y, width, height);
    } on JsLayerError catch (error) {
      emit(ErrorState(error: error));
    }
  }

  void _convertAndDisplay() {
    final ownedNft = _nftRepository.getNft();
    final nftViewModel = _nftConverter.convert(ownedNft.nft);
    emit(NftLoadedState(nft: nftViewModel));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
