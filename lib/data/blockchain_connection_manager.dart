import 'dart:async';
import 'dart:html';

import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/js_layer_event.dart';

class BlockchainConnectionManager {
  final JsBridge _jsBridge;
  final SupportedChains _supportedChains;

  late ChainInfo chainInfo;
  String? userAddress;

  final _eventController = StreamController<Connection>.broadcast();

  BlockchainConnectionManager(this._jsBridge, this._supportedChains) {
    chainInfo = ChainInfo.unsupported();
    _jsBridge.jsEventController.stream.listen((event) {
      if (event is OnConnectionChanged) {
        if (userAddress == event.accountAddress &&
            chainInfo.id == event.chainId) {
          return;
        }
        setUserAddress(event.accountAddress);
        setChainInfo(event.chainId);
      } else if (event is OnAccountDisconnected) {
        setUserAddress(null);
      }
    });

    window.onBeforeUnload.listen((event) {
      chainInfo = ChainInfo.unsupported();
      userAddress = null;
    });
  }

  Stream<Connection> getEventsStream() => _eventController.stream;

  void setUserAddress(String? address) {
    userAddress = address;
    _eventController.add(_createConnectionState());
  }

  void setChainInfo(int chainId) {
    chainInfo = _supportedChains.getChainById(chainId);
    _eventController.add(_createConnectionState());
  }

  Future<void> requestAccount() {
    return _jsBridge.requestAccount();
  }

  Future<void> switchChain(int chainId) {
    return _jsBridge.changeChain(chainId);
  }

  bool isUserConnected() => userAddress != null;

  bool isConnectedToSupportedChain() =>
      isUserConnected() && chainInfo != ChainInfo.unsupported();

  Connection _createConnectionState() {
    return Connection(
      chainInfo: chainInfo,
      userAddress: userAddress,
    );
  }
}
