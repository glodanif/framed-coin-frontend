import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/error_code.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/view/common/nft_converter.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';

part 'verification_state.dart';

class VerificationBloc extends Cubit<VerificationState> {
  final JsBridge _jsBridge;
  final SupportedChains _supportedChains;
  final NftConverter _nftConverter;

  VerificationBloc(
    this._jsBridge,
    this._supportedChains,
    this._nftConverter,
  ) : super(VerificationInitial());

  void loadChains() {
    emit(ChainsLoadedState(
      _supportedChains.getSupportedChains(),
      _supportedChains.getDefaultChain(),
    ));
  }

  void verifyNft(int chainId, String nftId) async {
    emit(VerificationProcessState());
    final chainInfo = _supportedChains.getChainById(chainId);
    try {
      final contract =_supportedChains.getContracts()[chainId.toString()] ?? "";
      final nft = await _jsBridge.verifyNft(chainInfo, nftId);
      final explorerUrl = "${chainInfo.explorerUrl}/token/$contract?a=$nftId";
      emit(VerifiedState(
        _nftConverter.convert(nft.nft),
        nft.owner,
        explorerUrl,
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
