import 'package:framed_coin_frontend/domain/contract_balances.dart';
import 'package:framed_coin_frontend/domain/contract_state.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/domain/minting_settings.dart';
import 'package:framed_coin_frontend/domain/nft.dart';
import 'package:framed_coin_frontend/domain/owned_nft.dart';

class JsLayerEvent {}

class OnTxSent extends JsLayerEvent {
  final String hash;
  final int confirmations;

  OnTxSent(this.hash, this.confirmations);

  @override
  String toString() {
    return 'OnTxSent{hash: $hash, confirmations: $confirmations}';
  }
}

class OnTxConfirmed extends JsLayerEvent {
  final String result;

  OnTxConfirmed(this.result);

  @override
  String toString() {
    return 'OnTxConfirmed{result: $result}';
  }
}

class OnTxFailed extends JsLayerEvent {
  final JsLayerError error;

  OnTxFailed(this.error);

  @override
  String toString() {
    return 'OnTxFailed{error: $error}';
  }
}

class OnError extends JsLayerEvent {
  final JsLayerError error;

  OnError(this.error);

  @override
  String toString() {
    return 'OnError{error: $error}';
  }
}

class OnConnectionChanged extends JsLayerEvent {
  final String accountAddress;
  final int chainId;

  OnConnectionChanged(this.accountAddress, this.chainId);

  @override
  String toString() {
    return 'OnConnectionChanged{accountAddress: $accountAddress, chainId: $chainId}';
  }
}

class OnAccountDisconnected extends JsLayerEvent {}

class OnProviderMissing extends JsLayerEvent {
  final JsLayerError error;

  OnProviderMissing(this.error);
}

class OnContractBalance extends JsLayerEvent {
  final ContractBalances balances;

  OnContractBalance(this.balances);

  @override
  String toString() {
    return 'OnContractBalance{balances: $balances}';
  }
}

class OnMintingSettings extends JsLayerEvent {
  final MintingSettings settings;

  OnMintingSettings(this.settings);

  @override
  String toString() {
    return 'OnMintingSettings{settings: $settings}';
  }
}

class OnMintTxSent extends OnTxSent {
  OnMintTxSent(super.hash, super.confirmations);
}

class OnMintTxConfirmed extends OnTxConfirmed {
  OnMintTxConfirmed(super.result);
}

class OnMintTxFailed extends OnTxFailed {
  OnMintTxFailed(super.error);
}

class OnCashOutTxSent extends OnTxSent {
  OnCashOutTxSent(super.hash, super.confirmations);
}

class OnCashOutTxConfirmed extends OnTxConfirmed {
  OnCashOutTxConfirmed(super.tokenId);
}

class OnCashOutTxFailed extends OnTxFailed {
  OnCashOutTxFailed(super.error);
}

class OnBurnTxSent extends OnTxSent {
  OnBurnTxSent(super.hash, super.confirmations);
}

class OnBurnTxConfirmed extends OnTxConfirmed {
  OnBurnTxConfirmed(super.tokenId);
}

class OnBurnTxFailed extends OnTxFailed {
  OnBurnTxFailed(super.error);
}

class OnPauseTxSent extends OnTxSent {
  OnPauseTxSent(super.hash, super.confirmations);
}

class OnPauseTxConfirmed extends OnTxConfirmed {
  OnPauseTxConfirmed() : super("");
}

class OnPauseTxFailed extends OnTxFailed {
  OnPauseTxFailed(super.error);
}

class OnUnPauseTxSent extends OnTxSent {
  OnUnPauseTxSent(super.hash, super.confirmations);
}

class OnUnPauseTxConfirmed extends OnTxConfirmed {
  OnUnPauseTxConfirmed() : super("");
}

class OnUnPauseTxFailed extends OnTxFailed {
  OnUnPauseTxFailed(super.error);
}

class OnWithdrawFeesTxSent extends OnTxSent {
  OnWithdrawFeesTxSent(super.hash, super.confirmations);
}

class OnWithdrawFeesTxConfirmed extends OnTxConfirmed {
  OnWithdrawFeesTxConfirmed(super.amount);
}

class OnWithdrawFeesTxFailed extends OnTxFailed {
  OnWithdrawFeesTxFailed(super.error);
}

class OnSetNewMintFeesTxSent extends OnTxSent {
  OnSetNewMintFeesTxSent(super.hash, super.confirmations);
}

class OnSetNewMintFeesTxConfirmed extends OnTxConfirmed {
  OnSetNewMintFeesTxConfirmed(super.newValue);
}

class OnSetNewMintFeesTxFailed extends OnTxFailed {
  OnSetNewMintFeesTxFailed(super.error);
}

class OnSetNewMinimumValueToMintTxSent extends OnTxSent {
  OnSetNewMinimumValueToMintTxSent(super.hash, super.confirmations);
}

class OnSetNewMinimumValueToMintTxConfirmed extends OnTxConfirmed {
  OnSetNewMinimumValueToMintTxConfirmed(super.newValue);
}

class OnSetNewMinimumValueToMintTxFailed extends OnTxFailed {
  OnSetNewMinimumValueToMintTxFailed(super.error);
}

class OnOwnerNftsLoaded extends JsLayerEvent {
  final List<Nft> nftList;

  OnOwnerNftsLoaded(this.nftList);

  @override
  String toString() {
    return 'OnOwnerNftsLoaded{nftList: $nftList}';
  }
}

class OnNftDetailsLoaded extends JsLayerEvent {
  final OwnedNft nft;

  OnNftDetailsLoaded(this.nft);

  @override
  String toString() {
    return 'OnNftDetailsLoaded{nft: $nft}';
  }
}

class OnContractStateLoaded extends JsLayerEvent {
  final ContractState contractState;

  OnContractStateLoaded(this.contractState);

  @override
  String toString() {
    return 'OnContractStateLoaded{contractState: $contractState}';
  }
}

class OnNftVerified extends JsLayerEvent {
  final OwnedNft nft;

  OnNftVerified(this.nft);

  @override
  String toString() {
    return 'OnNftVerified{nft: $nft}';
  }
}

class OnNftDetailsUnavailable extends OnError {
  OnNftDetailsUnavailable(super.error);
}

class OnContractStateUnavailable extends OnError {
  OnContractStateUnavailable(super.error);
}

class OnNftVerificationFailed extends OnError {
  OnNftVerificationFailed(super.error);
}

class OnMintingSettingsUnavailable extends OnError {
  OnMintingSettingsUnavailable(super.error);
}

class OnNftListUnavailable extends OnError {
  OnNftListUnavailable(super.error);
}

class OnRequestingAccountFailed extends OnError {
  OnRequestingAccountFailed(super.error);
}

class OnChangingChainsFailed extends OnError {
  OnChangingChainsFailed(super.error);
}

class OnDownloaded extends JsLayerEvent {}

class OnDownloadingFailed extends OnError {
  OnDownloadingFailed(super.error);
}
