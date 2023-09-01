part of 'public_view_bloc.dart';

@immutable
abstract class PublicViewState {}

class PublicViewInitial extends PublicViewState {}

class UnsupportedChainState extends PublicViewState {
  final String chainId;

  UnsupportedChainState(this.chainId);
}

class LoadingNftState extends PublicViewState {}

class NftLoadedState extends PublicViewState {
  final NftViewModel nft;
  final String chainName;
  final String explorerUrl;
  final String owner;

  NftLoadedState(this.nft, this.chainName, this.explorerUrl, this.owner);
}

class NonExistentNft extends PublicViewState {
  final String message;

  NonExistentNft(this.message);
}

class ErrorState extends PublicViewState {
  final JsLayerError error;

  ErrorState(this.error);
}
