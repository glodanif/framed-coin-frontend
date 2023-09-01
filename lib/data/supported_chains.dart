import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:framed_coin_frontend/domain/chain.dart';

class SupportedChains {
  final ethereumSepoliaId = 11155111;
  final polygonMumbaiId = 80001;
  final localhostHardhatId = 31337;

  final Map<int, ChainInfo> _supportedChains = {};

  SupportedChains(Map<String, String> smartContracts) {
    _supportedChains[ethereumSepoliaId] = _createEthereumSepolia(
      smartContracts[ethereumSepoliaId.toString()]!,
    );
    _supportedChains[polygonMumbaiId] = _createPolygonMumbai(
      smartContracts[polygonMumbaiId.toString()]!,
    );
    if (!kReleaseMode) {
      _supportedChains[localhostHardhatId] = _createLocalhostHardhat(
        smartContracts[localhostHardhatId.toString()]!,
      );
    }
  }

  List<ChainInfo> getSupportedChains() {
    return _supportedChains.values.toList();
  }

  ChainInfo getChainById(int id) {
    return _supportedChains[id] ?? ChainInfo.unsupported();
  }

  ChainInfo getDefaultChain() {
    return _supportedChains.values.first;
  }

  Map<String, String> getContracts() {
    return _supportedChains.map((key, value) =>
        MapEntry<String, String>(key.toString(), value.smartContractAddress));
  }

  ChainInfo _createEthereumSepolia(String contractAddress) {
    return ChainInfo(
      id: 11155111,
      name: 'Ethereum Sepolia',
      smartContractAddress: contractAddress,
      chainIcon: 'assets/ic_ethereum.png',
      tokenIcon: 'assets/unit_ether.png',
      tokenName: 'ETH',
      rpcUrl: dotenv.env['ETHEREUM_SEPOLIA_RPC_URL'] ??
          'https://ethereum-sepolia.blockpi.network/v1/rpc/public',
      valueSteps: const ["10", "1", "0.5"],
      explorerUrl: 'https://sepolia.etherscan.io',
      isTestnet: true,
    );
  }

  ChainInfo _createPolygonMumbai(String contractAddress) {
    return ChainInfo(
      id: 80001,
      name: 'Polygon Mumbai',
      smartContractAddress: contractAddress,
      chainIcon: 'assets/ic_polygon.png',
      tokenIcon: 'assets/unit_matic.png',
      tokenName: 'MATIC',
      rpcUrl: dotenv.env['POLYGON_MUMBAI_RPC_URL'] ??
          'https://polygon-mumbai.blockpi.network/v1/rpc/public',
      valueSteps: const ["20000", "2000", "1000"],
      explorerUrl: 'https://mumbai.polygonscan.com',
      isTestnet: true,
    );
  }

  ChainInfo _createLocalhostHardhat(String contractAddress) {
    return ChainInfo(
      id: 31337,
      name: 'Hardhat Localhost',
      smartContractAddress: contractAddress,
      chainIcon: 'assets/ic_hardhat.png',
      tokenIcon: 'assets/unit_ether.png',
      tokenName: 'ETH',
      rpcUrl: 'http://127.0.0.1:8545',
      valueSteps: const ["10", "1", "0.5"],
      explorerUrl: "http://127.0.0.1:8545",
      isTestnet: true,
    );
  }
}
