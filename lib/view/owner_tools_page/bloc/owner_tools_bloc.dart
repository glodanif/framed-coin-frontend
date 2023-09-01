import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/repository/contract_state_repository.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/error_code.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/convert/owner_tools_converter.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/convert/owner_tools_view_model.dart';

part 'owner_tools_state.dart';

class OwnerToolsBloc extends Cubit<OwnerToolsState> {
  final ContractStateRepository _repository;
  final OwnerToolsConverter _ownerToolsConverter;
  final BlockchainConnectionManager _connection;

  late StreamSubscription<Connection> _streamSubscription;

  OwnerToolsBloc(
    this._repository,
    this._ownerToolsConverter,
    this._connection,
  ) : super(OwnerToolsInitial()) {
    _streamSubscription = _connection.getEventsStream().listen(
      (state) {
        if (_connection.isConnectedToSupportedChain()) {
          loadContractState();
        }
      },
    );
  }

  void loadContractState() async {
    try {
      final contractState = await _repository.loadContractState();
      emit(
        OwnerToolsReceivedState(
          viewModel: _ownerToolsConverter.convert(
            contractState,
            _connection.chainInfo,
          ),
        ),
      );
    } on JsLayerError catch (error) {
      if (error.code == ErrorCode.fcUnauthorized) {
        emit(NotAuthorizedState(error: error));
      } else {
        emit(UnexpectedErrorState(error: error));
      }
    }
  }

  void pause() {
    _repository.pause().listen((event) {
      emit(PauseTxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        emit(
          OwnerToolsReceivedState(
            viewModel: _ownerToolsConverter.convert(
              _repository.getContractState(),
              _connection.chainInfo,
            ),
          ),
        );
      } else {
        emit(TransactionFailedState(error: jsError));
      }
    });
  }

  void unPause() {
    _repository.unPause().listen((event) {
      emit(UnPauseTxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        emit(
          OwnerToolsReceivedState(
            viewModel: _ownerToolsConverter.convert(
              _repository.getContractState(),
              _connection.chainInfo,
            ),
          ),
        );
      } else {
        emit(TransactionFailedState(error: jsError));
      }
    });
  }

  void withdrawFees() {
    _repository.withdrawFees().listen((event) {
      emit(WithdrawFeesTxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        emit(
          OwnerToolsReceivedState(
            viewModel: _ownerToolsConverter.convert(
              _repository.getContractState(),
              _connection.chainInfo,
            ),
          ),
        );
      } else {
        emit(TransactionFailedState(error: jsError));
      }
    });
  }

  void setNewMintFee(String mintFee) {
    _repository.setNewMintFee(mintFee).listen((event) {
      emit(NewMintFeeTxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        emit(
          OwnerToolsReceivedState(
            viewModel: _ownerToolsConverter.convert(
              _repository.getContractState(),
              _connection.chainInfo,
            ),
          ),
        );
      } else {
        emit(TransactionFailedState(error: jsError));
      }
    });
  }

  void setNewMinimumValueToMint(String valueToMint) {
    _repository.setNewMinimumValueToMint(valueToMint).listen((event) {
      emit(NewMinimumValueToMintTxState(tx: event));
    }).onError((error) {
      final jsError = error as JsLayerError;
      if (jsError.isUserRejection()) {
        emit(
          OwnerToolsReceivedState(
            viewModel: _ownerToolsConverter.convert(
              _repository.getContractState(),
              _connection.chainInfo,
            ),
          ),
        );
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
