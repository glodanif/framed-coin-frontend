import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/error_code.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/view/common/nft_converter.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';

part 'public_view_state.dart';

class PublicViewBloc extends Cubit<PublicViewState> {
  final JsBridge _jsBridge;
  final SupportedChains _supportedChains;
  final NftConverter _nftConverter;

  PublicViewBloc(
    this._jsBridge,
    this._supportedChains,
    this._nftConverter,
  ) : super(PublicViewInitial());

  loadNft(String chainId, String nftId) async {
    emit(LoadingNftState());
    final chain = int.tryParse(chainId);
    if (chain == null) {
      emit(UnsupportedChainState(chainId));
      return;
    }
    final chainInfo = _supportedChains.getChainById(chain);
    if (chainInfo == ChainInfo.unsupported()) {
      emit(UnsupportedChainState(chainId));
      return;
    }
    try {
      final contract = _supportedChains.getContracts()[chainId] ?? "";
      final nft = await _jsBridge.verifyNft(chainInfo, nftId);
      final explorerUrl = "${chainInfo.explorerUrl}/token/$contract?a=$nftId";
      emit(NftLoadedState(
        _nftConverter.convert(nft.nft),
        chainInfo.name,
        explorerUrl,
        nft.owner,
      ));
    } on JsLayerError catch (error) {
      if (error.code == ErrorCode.fcNotFound) {
        emit(NonExistentNft(error.message));
      } else {
        emit(ErrorState(error));
      }
    }
  }
}
