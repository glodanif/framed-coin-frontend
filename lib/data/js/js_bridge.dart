import 'dart:async';
import 'dart:convert';

import 'package:framed_coin_frontend/data/js/internal/shared_js.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/contract_balances.dart';
import 'package:framed_coin_frontend/domain/contract_state.dart';
import 'package:framed_coin_frontend/domain/js_layer_event.dart';
import 'package:framed_coin_frontend/domain/minting_settings.dart';
import 'package:framed_coin_frontend/domain/nft.dart';
import 'package:framed_coin_frontend/domain/owned_nft.dart';
import 'package:framed_coin_frontend/domain/rpc_url_pair.dart';
import 'package:framed_coin_frontend/logging/logger.dart';

class JsBridge {
  final jsEventController = StreamController<JsLayerEvent>.broadcast();

  JsBridge() {
    jsEventController.stream.listen((event) {
      Logger.event("JS Event: ${event.toString()}");
    });
  }

  void checkConnection() {
    checkConnectionJs();
  }

  void setupSmartContracts(String contractsJson) {
    setupSmartContractsJs(contractsJson);
  }

  Future<void> requestAccount() {
    final completer = Completer();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnConnectionChanged) {
        completer.complete();
        subscription?.cancel();
      } else if (event is OnRequestingAccountFailed) {
        subscription?.cancel();
        completer.completeError(event.error);
      } else if (event is OnProviderMissing) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    requestAccountJs();
    return completer.future;
  }

  Future<void> changeChain(int chainId) {
    final completer = Completer();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnConnectionChanged) {
        completer.complete();
        subscription?.cancel();
      } else if (event is OnChangingChainsFailed) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    changeChainJs(chainId);
    return completer.future;
  }

  Future<ContractBalances> getContractsBalance(List<RpcUrlPair> chains) {
    final completer = Completer<ContractBalances>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnContractBalance) {
        completer.complete(event.balances);
        subscription?.cancel();
      }
    });
    final jsonMap = json.encode(chains);
    getContractsBalanceJs(jsonMap);
    return completer.future;
  }

  Future<OwnedNft> verifyNft(ChainInfo chainInfo, String tokenId) {
    final completer = Completer<OwnedNft>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnNftVerified) {
        completer.complete(event.nft);
        subscription?.cancel();
      } else if (event is OnNftVerificationFailed) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    verifyNftJs(chainInfo.id, chainInfo.rpcUrl, tokenId);
    return completer.future;
  }

  Future<List<Nft>> getNftsByAddress(String address) {
    final completer = Completer<List<Nft>>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnOwnerNftsLoaded) {
        completer.complete(event.nftList);
        subscription?.cancel();
      } else if (event is OnNftListUnavailable) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    getNftsByAddressJs(address);
    return completer.future;
  }

  Future<MintingSettings> getMintingSettings() {
    final completer = Completer<MintingSettings>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnMintingSettings) {
        completer.complete(event.settings);
        subscription?.cancel();
      } else if (event is OnMintingSettingsUnavailable) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    getMintingSettingsJs();
    return completer.future;
  }

  Future<OwnedNft> getNftDetails(String tokenId) {
    final completer = Completer<OwnedNft>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnNftDetailsLoaded) {
        completer.complete(event.nft);
        subscription?.cancel();
      } else if (event is OnNftDetailsUnavailable) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    getNftDetailsJs(tokenId);
    return completer.future;
  }

  Future<ContractState> getContractState() {
    final completer = Completer<ContractState>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnContractStateLoaded) {
        completer.complete(event.contractState);
        subscription?.cancel();
      } else if (event is OnContractStateUnavailable) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    getContractStateJs();
    return completer.future;
  }

  Future<void> downloadNft(
    String fileName,
    double x,
    double y,
    double width,
    double height,
  ) {
    final completer = Completer();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnDownloaded) {
        completer.complete();
        subscription?.cancel();
      } else if (event is OnDownloadingFailed) {
        subscription?.cancel();
        completer.completeError(event.error);
      }
    });
    downloadNftJs(fileName, x, y, width, height);
    return completer.future;
  }

  void mintNft(String attachedValue) {
    mintNftJs(attachedValue);
  }

  void cashOutNft(String tokenId) {
    cashOutNftJs(tokenId);
  }

  void burnNft(String tokenId) {
    burnNftJs(tokenId);
  }

  void pause() {
    pauseJs();
  }

  void unPause() {
    unPauseJs();
  }

  void withdrawFees() {
    withdrawFeesJs();
  }

  void setNewMintFee(String value) {
    setNewMintFeeJs(value);
  }

  void setNewMinimumValueToMint(String value) {
    setNewMinimumValueToMintJs(value);
  }
}
