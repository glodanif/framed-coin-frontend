import 'package:framed_coin_frontend/data/cached_value.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/repository/transaction_executor.dart';
import 'package:framed_coin_frontend/domain/js_layer_event.dart';
import 'package:framed_coin_frontend/domain/owned_nft.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';

class NftRepository extends TransactionExecutor {
  final String _tokenId;
  final JsBridge _jsBridge;

  final _ownedNft = CachedValue<OwnedNft>();

  NftRepository(this._tokenId, this._jsBridge, _connectionManager)
      : super(_jsBridge, _connectionManager);

  OwnedNft getNft() => _ownedNft.getValue();

  Future<OwnedNft> loadNftDetails() async {
    final nft = await _jsBridge.getNftDetails(_tokenId);
    _ownedNft.cacheValue(nft);
    return nft;
  }

  Stream<Transaction> cashOutNft() {
    return executeTransaction<OnCashOutTxSent, OnCashOutTxConfirmed,
        OnCashOutTxFailed>(
      () {
        _jsBridge.cashOutNft(_tokenId);
      },
    );
  }

  Stream<Transaction> burnNft() {
    return executeTransaction<OnBurnTxSent, OnBurnTxConfirmed, OnBurnTxFailed>(
      () {
        _jsBridge.burnNft(_tokenId);
      },
    );
  }

  Future<void> downloadNft(fileName, x, y, width, height) async {
    return await _jsBridge.downloadNft(fileName, x, y, width, height);
  }
}
