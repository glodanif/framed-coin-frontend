import 'package:equatable/equatable.dart';

class ChainInfo extends Equatable {
  final int id;
  final String name;
  final String smartContractAddress;
  final String chainIcon;
  final String tokenIcon;
  final String tokenName;
  final String rpcUrl;
  final List<String> valueSteps;
  final String explorerUrl;
  final bool isTestnet;

  const ChainInfo({
    required this.id,
    required this.name,
    required this.smartContractAddress,
    required this.chainIcon,
    required this.tokenIcon,
    required this.tokenName,
    required this.rpcUrl,
    required this.valueSteps,
    required this.explorerUrl,
    this.isTestnet = false,
  });

  ChainInfo.unsupported()
      : id = -1,
        name = "Unsupported chain",
        chainIcon = "assets/ic_unsupported.png",
        smartContractAddress = "0x0",
        tokenIcon = "assets/ic_unsupported.png",
        tokenName = "???",
        rpcUrl = "https://dummy",
        valueSteps = ["3", "2", "1"],
        explorerUrl = "https://dummy",
        isTestnet = false;

  bool isLocalhost() {
    return id == 31337;
  }

  @override
  String toString() {
    return 'ChainInfo{id: $id, name: $name, chainIcon: $chainIcon, smartContractAddress: $smartContractAddress, tokenIcon: $tokenIcon, tokenName: $tokenName, rpcUrl: $rpcUrl, valueSteps: $valueSteps, explorerUrl: $explorerUrl, isTestnet: $isTestnet}';
  }

  @override
  List<Object> get props => [
        id,
        name,
        smartContractAddress,
        chainIcon,
        tokenIcon,
        tokenName,
        rpcUrl,
        valueSteps,
        explorerUrl,
        isTestnet,
      ];
}
