class ContractAddressViewModel {
  final String chainId;
  final String chainName;
  final String contractAddress;
  final Uri explorerLink;
  final String chainIcon;
  final bool isTestnet;

  ContractAddressViewModel({
    required this.chainId,
    required this.chainName,
    required this.contractAddress,
    required this.explorerLink,
    required this.chainIcon,
    required this.isTestnet,
  });

  @override
  String toString() {
    return 'ContractAddressViewModel{chainId: $chainId, chainName: $chainName, contractAddress: $contractAddress, explorerLink: $explorerLink, chainIcon: $chainIcon, isTestnet: $isTestnet}';
  }
}
