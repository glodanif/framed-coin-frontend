import 'dart:async';

import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/domain/js_layer_event.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';

class TransactionExecutor {
  final JsBridge _jsBridge;
  final BlockchainConnectionManager _connectionManager;

  TransactionExecutor(this._jsBridge, this._connectionManager);

  Stream<Transaction> executeTransaction<T extends OnTxSent,
      V extends OnTxConfirmed, I extends OnTxFailed>(Function executable) {
    final controller = StreamController<Transaction>();
    final tx = Transaction(_connectionManager.chainInfo);
    StreamSubscription? subscription;
    subscription = _jsBridge.jsEventController.stream.listen((event) {
      if (event is T) {
        tx.markAsSent(event.hash, event.confirmations);
        controller.add(tx);
      } else if (event is V) {
        tx.markAsConfirmed(result: event.result);
        controller.add(tx);
        subscription?.cancel();
        controller.close();
      } else if (event is I) {
        controller.addError(event.error);
        subscription?.cancel();
        controller.close();
      }
    });
    tx.markAsSentForExecution();
    controller.add(tx);
    executable.call();
    return controller.stream;
  }
}
