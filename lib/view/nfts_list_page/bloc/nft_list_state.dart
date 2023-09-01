part of 'nft_list_bloc.dart';

@immutable
abstract class NftListState {}

class NftListInitial extends NftListState {}

class LoadingState extends NftListState {}

class NotConnectedState extends NftListState {}

class OnUnsupportedChainState extends NftListState {}

class ReceivedOwnerNftsState extends NftListState {
  final List<NftViewModel> nfts;

  ReceivedOwnerNftsState({
    required this.nfts,
  });
}

class ErrorState extends NftListState {
  final JsLayerError error;

  ErrorState({
    required this.error,
  });
}
