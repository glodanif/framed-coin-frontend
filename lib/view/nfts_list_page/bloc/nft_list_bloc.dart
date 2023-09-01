import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/view/common/nft_converter.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';

part 'nft_list_state.dart';

class NftListBloc extends Cubit<NftListState> {
  final JsBridge _jsBridge;
  final NftConverter _converter;
  final BlockchainConnectionManager _connection;

  late StreamSubscription<Connection> _streamSubscription;

  NftListBloc(
    this._jsBridge,
    this._converter,
    this._connection,
  ) : super(NftListInitial()) {
    _streamSubscription = _connection.getEventsStream().listen(
      (state) {
        if (_connection.isConnectedToSupportedChain()) {
          loadOwnerNfts();
        }
      },
    );
  }

  void loadOwnerNfts() async {
    try {
      final nftList = await _jsBridge.getNftsByAddress(
        _connection.userAddress ?? "0x",
      );
      final nftViewModels = _converter.convertList(nftList);
      emit(ReceivedOwnerNftsState(nfts: nftViewModels));
    } on JsLayerError catch (error) {
      emit(ErrorState(error: error));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
