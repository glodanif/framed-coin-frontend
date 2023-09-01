part of 'owner_tools_bloc.dart';

@immutable
abstract class OwnerToolsState {}

class OwnerToolsInitial extends OwnerToolsState {}

class OwnerToolsReceivedState extends OwnerToolsState {
  final OwnerToolsViewModel viewModel;

  OwnerToolsReceivedState({required this.viewModel});
}

class NotAuthorizedState extends OwnerToolsState {
  final JsLayerError error;

  NotAuthorizedState({required this.error});
}

class UnexpectedErrorState extends OwnerToolsState {
  final JsLayerError error;

  UnexpectedErrorState({required this.error});
}

class PauseTxState extends OwnerToolsState {
  final Transaction tx;

  PauseTxState({required this.tx});
}

class UnPauseTxState extends OwnerToolsState {
  final Transaction tx;

  UnPauseTxState({required this.tx});
}

class WithdrawFeesTxState extends OwnerToolsState {
  final Transaction tx;

  WithdrawFeesTxState({required this.tx});
}

class NewMintFeeTxState extends OwnerToolsState {
  final Transaction tx;

  NewMintFeeTxState({required this.tx});
}

class NewMinimumValueToMintTxState extends OwnerToolsState {
  final Transaction tx;

  NewMinimumValueToMintTxState({required this.tx});
}

class TransactionFailedState extends OwnerToolsState {
  final JsLayerError error;

  TransactionFailedState({
    required this.error,
  });
}

class ErrorState extends OwnerToolsState {
  final JsLayerError error;

  ErrorState({
    required this.error,
  });
}
