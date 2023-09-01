import 'package:framed_coin_frontend/data/cached_value.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/repository/transaction_executor.dart';
import 'package:framed_coin_frontend/domain/contract_state.dart';
import 'package:framed_coin_frontend/domain/js_layer_event.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';

class ContractStateRepository extends TransactionExecutor {
  final JsBridge _jsBridge;

  final _contractState = CachedValue<ContractState>();

  ContractStateRepository(this._jsBridge, _connectionManager)
      : super(_jsBridge, _connectionManager);

  ContractState getContractState() => _contractState.getValue();

  Future<ContractState> loadContractState() async {
    final state = await _jsBridge.getContractState();
    _contractState.cacheValue(state);
    return state;
  }

  Stream<Transaction> pause() {
    return executeTransaction<OnPauseTxSent, OnPauseTxConfirmed,
        OnPauseTxFailed>(
      () {
        _jsBridge.pause();
      },
    );
  }

  Stream<Transaction> unPause() {
    return executeTransaction<OnUnPauseTxSent, OnUnPauseTxConfirmed,
        OnUnPauseTxFailed>(
      () {
        _jsBridge.unPause();
      },
    );
  }

  Stream<Transaction> withdrawFees() {
    return executeTransaction<OnWithdrawFeesTxSent, OnWithdrawFeesTxConfirmed,
        OnWithdrawFeesTxFailed>(
      () {
        _jsBridge.withdrawFees();
      },
    );
  }

  Stream<Transaction> setNewMintFee(String mintFee) {
    return executeTransaction<OnSetNewMintFeesTxSent,
        OnSetNewMintFeesTxConfirmed, OnSetNewMintFeesTxFailed>(
      () {
        _jsBridge.setNewMintFee(mintFee);
      },
    );
  }

  Stream<Transaction> setNewMinimumValueToMint(String valueToMint) {
    return executeTransaction<
        OnSetNewMinimumValueToMintTxSent,
        OnSetNewMinimumValueToMintTxConfirmed,
        OnSetNewMinimumValueToMintTxFailed>(() {
      _jsBridge.setNewMinimumValueToMint(valueToMint);
    });
  }
}
