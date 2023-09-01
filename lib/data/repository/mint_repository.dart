import 'package:framed_coin_frontend/data/cached_value.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/repository/transaction_executor.dart';
import 'package:framed_coin_frontend/domain/js_layer_event.dart';
import 'package:framed_coin_frontend/domain/minting_settings.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';

class MintRepository extends TransactionExecutor {
  final JsBridge _jsBridge;

  final _mintingSettings = CachedValue<MintingSettings>();

  MintRepository(this._jsBridge, _connectionManager)
      : super(_jsBridge, _connectionManager);

  MintingSettings getMintingSettings() => _mintingSettings.getValue();

  Future<MintingSettings> loadMintingSettings() async {
    final settings = await _jsBridge.getMintingSettings();
    _mintingSettings.cacheValue(settings);
    return settings;
  }

  Stream<Transaction> mintNft(BigInt attachedValue) {
    return executeTransaction<OnMintTxSent, OnMintTxConfirmed, OnMintTxFailed>(
      () {
        _jsBridge.mintNft(attachedValue.toString());
      },
    );
  }
}
