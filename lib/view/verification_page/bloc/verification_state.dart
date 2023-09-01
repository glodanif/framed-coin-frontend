part of 'verification_bloc.dart';

@immutable
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class ChainsLoadedState extends VerificationState {
  final List<ChainInfo> allChains;
  final ChainInfo defaultChain;

  ChainsLoadedState(this.allChains, this.defaultChain);
}

class VerificationProcessState extends VerificationState {}

class VerifiedState extends VerificationState {
  final NftViewModel nft;
  final String owner;
  final String explorerUrl;

  VerifiedState(this.nft, this.owner, this.explorerUrl);
}

class NonExistentNft extends VerificationState {
  final String message;

  NonExistentNft(this.message);
}

class ErrorState extends VerificationState {
  final JsLayerError error;

  ErrorState(this.error);
}
