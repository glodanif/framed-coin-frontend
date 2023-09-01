part of 'minting_bloc.dart';

@immutable
abstract class MintingState {}

class MintingInitial extends MintingState {}

class TxState extends MintingState {
  final Transaction tx;

  TxState({required this.tx});
}

class TransactionFailedState extends MintingState {
  final JsLayerError error;

  TransactionFailedState({required this.error});
}

class MintingSettingsState extends MintingState {
  final MintingSettings mintingSettings;
  final ChainInfo chainInfo;

  MintingSettingsState({
    required this.chainInfo,
    required this.mintingSettings,
  });
}

class MintingSettingsUnavailableState extends MintingState {
  final JsLayerError error;

  MintingSettingsUnavailableState({required this.error});
}

class PausedState extends MintingState {}
