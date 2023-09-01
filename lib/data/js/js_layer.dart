@JS()
library js_bridge;

import 'dart:convert';

import 'package:framed_coin_frontend/data/error_converter.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/domain/contract_balances.dart';
import 'package:framed_coin_frontend/domain/contract_state.dart';
import 'package:framed_coin_frontend/domain/js_layer_event.dart';
import 'package:framed_coin_frontend/domain/minting_settings.dart';
import 'package:framed_coin_frontend/domain/nft.dart';
import 'package:framed_coin_frontend/domain/owned_nft.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:js/js.dart';

final _jsBridge = getIt<JsBridge>();
final _errorConverter = getIt<ErrorConverter>();

@JS('requestAccount')
external void requestAccountJs();

@JS('checkConnection')
external void checkConnectionJs();

@JS('setupSmartContracts')
external void setupSmartContractsJs(String contractsJson);

@JS('changeChain')
external void changeChainJs(int chainId);

@JS('getContractsBalance')
external void getContractsBalanceJs(String chains);

@JS('verifyNft')
external void verifyNftJs(int chainId, String rpcUrl, String tokenId);

@JS('getContractState')
external void getContractStateJs();

@JS('getNftsByAddress')
external void getNftsByAddressJs(String address);

@JS('getMintingSettings')
external void getMintingSettingsJs();

@JS('mintNft')
external void mintNftJs(String attachedValue);

@JS('getNftDetails')
external void getNftDetailsJs(tokenId);

@JS('cashOutNft')
external void cashOutNftJs(tokenId);

@JS('burnNft')
external void burnNftJs(tokenId);

@JS('pause')
external void pauseJs();

@JS('unPause')
external void unPauseJs();

@JS('withdrawFees')
external void withdrawFeesJs();

@JS('setNewMintFee')
external void setNewMintFeeJs(String value);

@JS('setNewMinimumValueToMint')
external void setNewMinimumValueToMintJs(String value);

@JS('downloadNft')
external void downloadNftJs(
  String fileName,
  double x,
  double y,
  double width,
  double height,
);

@JS('onProviderMissing')
external set _onProviderMissing(void Function(String) function);

@JS('onConnectionChanged')
external set _onConnectionChanged(void Function(String, int) function);

@JS('onRequestingAccountFailed')
external set _onRequestingAccountFailed(void Function(String) function);

@JS('onChangingChainsFailed')
external set _onChangingChainsFailed(void Function(String) function);

@JS('onAccountDisconnected')
external set _onAccountDisconnected(void Function() function);

@JS('onContractsBalanceLoaded')
external set _onContractsBalanceLoaded(void Function(String, String) function);

@JS('onNftVerified')
external set _onNftVerified(void Function(String, String) function);

@JS('onNftVerificationFailed')
external set _onNftVerificationFailed(void Function(String) function);

@JS('onMintingSettingsLoaded')
external set _onMintingSettingsLoaded(void Function(String) function);

@JS('onMintingSettingsFailedToLoad')
external set _onMintingSettingsFailedToLoad(void Function(String) function);

@JS('onNftDetailsLoaded')
external set _onNftDetailsLoaded(void Function(String, String) function);

@JS('onNftDetailsLoadingFailed')
external set _onNftDetailsLoadingFailed(void Function(String) function);

@JS('onMintTxSent')
external set _onMintTxSent(void Function(String, int) function);

@JS('onMintTxConfirmed')
external set _onMintTxConfirmed(void Function(String, String) function);

@JS('onMintTxFailed')
external set _onMintTxFailed(void Function(String) function);

@JS('onCashOutTxSent')
external set _onCashOutTxSent(void Function(String, int) function);

@JS('onCashOutTxConfirmed')
external set _onCashOutTxConfirmed(void Function(String, String) function);

@JS('onCashOutTxFailed')
external set _onCashOutTxFailed(void Function(String) function);

@JS('onBurnTxSent')
external set _onBurnTxSent(void Function(String, int) function);

@JS('onBurnTxConfirmed')
external set _onBurnTxConfirmed(void Function(String) function);

@JS('onBurnTxFailed')
external set _onBurnTxFailed(void Function(String) function);

@JS('onPauseTxSent')
external set _onPauseTxSent(void Function(String, int) function);

@JS('onPauseTxConfirmed')
external set _onPauseTxConfirmed(void Function() function);

@JS('onPauseTxFailed')
external set _onPauseTxFailed(void Function(String) function);

@JS('onUnPauseTxSent')
external set _onUnPauseTxSent(void Function(String, int) function);

@JS('onUnPauseTxConfirmed')
external set _onUnPauseTxConfirmed(void Function() function);

@JS('onUnPauseTxFailed')
external set _onUnPauseTxFailed(void Function(String) function);

@JS('onWithdrawTxSent')
external set _onWithdrawTxSent(void Function(String, int) function);

@JS('onWithdrawTxConfirmed')
external set _onWithdrawTxConfirmed(void Function(String) function);

@JS('onWithdrawTxFailed')
external set _onWithdrawTxFailed(void Function(String) function);

@JS('onNewMintFeeTxSent')
external set _onNewMintFeeTxSent(void Function(String, int) function);

@JS('onNewMintFeeTxConfirmed')
external set _onNewMintFeeTxConfirmed(void Function(String) function);

@JS('onNewMintFeeTxFailed')
external set _onNewMintFeeTxFailed(void Function(String) function);

@JS('onNewMinimumValueToMintTxSent')
external set _onNewMinimumValueToMintTxSent(
    void Function(String, int) function);

@JS('onNewMinimumValueToMintTxConfirmed')
external set _onNewMinimumValueToMintTxConfirmed(
    void Function(String) function);

@JS('onNewMinimumValueToMintTxFailed')
external set _onNewMinimumValueToMintTxFailed(void Function(String) function);

@JS('onContractStateLoaded')
external set _onContractStateLoaded(void Function(String) function);

@JS('onContractStateLoadingFailed')
external set _onContractStateLoadingFailed(void Function(String) function);

@JS('onNftListLoaded')
external set _onNftListLoaded(void Function(String) function);

@JS('onNftListLoadingFailed')
external set _onNftListLoadingFailed(void Function(String) function);

@JS('onDownloaded')
external set _onDownloaded(void Function() function);

@JS('onDownloadingFailed')
external set _onDownloadingFailed(void Function(String) function);

void initJsBridge(String smartContractsJson) {
  final eventController = _jsBridge.jsEventController;
  _onProviderMissing = allowInterop((error) {
    eventController.add(OnProviderMissing(_errorConverter.convert(error)));
  });
  _onConnectionChanged = allowInterop((address, chainId) {
    eventController.add(OnConnectionChanged(address, chainId));
  });
  _onAccountDisconnected = allowInterop(() {
    eventController.add(OnAccountDisconnected());
  });
  _onRequestingAccountFailed = allowInterop((error) {
    eventController
        .add(OnRequestingAccountFailed(_errorConverter.convert(error)));
  });
  _onChangingChainsFailed = allowInterop((error) {
    eventController.add(OnChangingChainsFailed(_errorConverter.convert(error)));
  });
  _onContractsBalanceLoaded = allowInterop((totalNftsValueUsd, totalSupply) {
    eventController.add(
        OnContractBalance(ContractBalances(totalNftsValueUsd, totalSupply)));
  });
  _onNftVerified = allowInterop((nft, ownerAddress) {
    eventController.add(
      OnNftVerified(OwnedNft(Nft.fromJson(json.decode(nft)), ownerAddress)),
    );
  });
  _onNftVerificationFailed = allowInterop((error) {
    eventController
        .add(OnNftVerificationFailed(_errorConverter.convert(error)));
  });
  _onNftDetailsLoaded = allowInterop((nft, owner) {
    eventController.add(OnNftDetailsLoaded(OwnedNft(
      Nft.fromJson(json.decode(nft)),
      owner,
    )));
  });
  _onNftDetailsLoadingFailed = allowInterop((error) {
    eventController
        .add(OnNftDetailsUnavailable(_errorConverter.convert(error)));
  });
  _onMintTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnMintTxSent(hash, confirmations));
  });
  _onMintTxConfirmed = allowInterop((tokenId, attachedValue) {
    eventController.add(OnMintTxConfirmed(tokenId));
  });
  _onMintTxFailed = allowInterop((error) {
    eventController.add(OnMintTxFailed(_errorConverter.convert(error)));
  });
  _onCashOutTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnCashOutTxSent(hash, confirmations));
  });
  _onCashOutTxConfirmed = allowInterop((tokenId, attachedValue) {
    eventController.add(OnCashOutTxConfirmed(tokenId));
  });
  _onCashOutTxFailed = allowInterop((error) {
    eventController.add(OnCashOutTxFailed(_errorConverter.convert(error)));
  });
  _onBurnTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnBurnTxSent(hash, confirmations));
  });
  _onBurnTxConfirmed = allowInterop((tokenId) {
    eventController.add(OnBurnTxConfirmed(tokenId));
  });
  _onBurnTxFailed = allowInterop((error) {
    eventController.add(OnBurnTxFailed(_errorConverter.convert(error)));
  });
  _onPauseTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnPauseTxSent(hash, confirmations));
  });
  _onPauseTxConfirmed = allowInterop(() {
    eventController.add(OnPauseTxConfirmed());
  });
  _onPauseTxFailed = allowInterop((error) {
    eventController.add(OnPauseTxFailed(_errorConverter.convert(error)));
  });
  _onUnPauseTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnUnPauseTxSent(hash, confirmations));
  });
  _onUnPauseTxConfirmed = allowInterop(() {
    eventController.add(OnUnPauseTxConfirmed());
  });
  _onUnPauseTxFailed = allowInterop((error) {
    eventController.add(OnUnPauseTxFailed(_errorConverter.convert(error)));
  });
  _onWithdrawTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnWithdrawFeesTxSent(hash, confirmations));
  });
  _onWithdrawTxConfirmed = allowInterop((amount) {
    eventController.add(OnWithdrawFeesTxConfirmed(amount));
  });
  _onWithdrawTxFailed = allowInterop((error) {
    eventController.add(OnWithdrawFeesTxFailed(_errorConverter.convert(error)));
  });
  _onNewMintFeeTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnSetNewMintFeesTxSent(hash, confirmations));
  });
  _onNewMintFeeTxConfirmed = allowInterop((newValue) {
    eventController.add(OnSetNewMintFeesTxConfirmed(newValue));
  });
  _onNewMintFeeTxFailed = allowInterop((error) {
    eventController
        .add(OnSetNewMintFeesTxFailed(_errorConverter.convert(error)));
  });
  _onNewMinimumValueToMintTxSent = allowInterop((hash, confirmations) {
    eventController.add(OnSetNewMinimumValueToMintTxSent(hash, confirmations));
  });
  _onNewMinimumValueToMintTxConfirmed = allowInterop((newValue) {
    eventController.add(OnSetNewMinimumValueToMintTxConfirmed(newValue));
  });
  _onNewMinimumValueToMintTxFailed = allowInterop((error) {
    eventController.add(
        OnSetNewMinimumValueToMintTxFailed(_errorConverter.convert(error)));
  });
  _onMintingSettingsLoaded = allowInterop((mintingSettings) {
    eventController.add(
      OnMintingSettings(MintingSettings.fromJson(json.decode(mintingSettings))),
    );
  });
  _onMintingSettingsFailedToLoad = allowInterop((error) {
    eventController
        .add(OnMintingSettingsUnavailable(_errorConverter.convert(error)));
  });
  _onContractStateLoaded = allowInterop((state) {
    eventController
        .add(OnContractStateLoaded(ContractState.fromJson(json.decode(state))));
  });
  _onContractStateLoadingFailed = allowInterop((error) {
    eventController
        .add(OnContractStateUnavailable(_errorConverter.convert(error)));
  });
  _onNftListLoaded = allowInterop((nftList) {
    final nfts = List<Nft>.from(
        json.decode(nftList).map<Nft>((dynamic i) => Nft.fromJson(i)));
    eventController.add(OnOwnerNftsLoaded(nfts));
  });
  _onNftListLoadingFailed = allowInterop((error) {
    eventController.add(OnNftListUnavailable(_errorConverter.convert(error)));
  });
  _onDownloaded = allowInterop(() {
    eventController.add(OnDownloaded());
  });
  _onDownloadingFailed = allowInterop((error) {
    eventController.add(OnDownloadingFailed(_errorConverter.convert(error)));
  });

  _jsBridge.setupSmartContracts(smartContractsJson);
  _jsBridge.checkConnection();
}
