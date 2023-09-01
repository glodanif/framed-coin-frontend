part of './details_bloc.dart';

@immutable
abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class NftLoadedState extends DetailsState {
  final NftViewModel nft;

  NftLoadedState({
    required this.nft,
  });
}

class NftUnavailableState extends DetailsState {
  final JsLayerError error;

  NftUnavailableState({
    required this.error,
  });
}

class NftNotFoundState extends DetailsState {
  final JsLayerError error;

  NftNotFoundState({
    required this.error,
  });
}

class CashOutTxState extends DetailsState {
  final Transaction tx;

  CashOutTxState({
    required this.tx,
  });
}

class BurnTxState extends DetailsState {
  final Transaction tx;

  BurnTxState({
    required this.tx,
  });
}

class TransactionFailedState extends DetailsState {
  final JsLayerError error;

  TransactionFailedState({required this.error});
}

class ErrorState extends DetailsState {
  final JsLayerError error;

  ErrorState({required this.error});
}

class StrangerViewState extends DetailsState {}
