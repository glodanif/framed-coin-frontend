import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_view_model.dart';

class ContractAddressConverter {
  final SupportedChains _supportedChains;

  ContractAddressConverter(this._supportedChains);

  ContractAddressViewModel convert(int chainId, String contractAddress) {
    final chainInfo = _supportedChains.getChainById(chainId);
    return ContractAddressViewModel(
      chainId: chainId.toString(),
      chainName: chainInfo.name,
      contractAddress: contractAddress,
      explorerLink:
          Uri.parse("${chainInfo.explorerUrl}/address/$contractAddress"),
      chainIcon: chainInfo.chainIcon,
      isTestnet: chainInfo.isTestnet,
    );
  }

  List<ContractAddressViewModel> convertList(Map<String, String> addresses) {
    return addresses
        .map((key, value) => MapEntry(int.parse(key), value))
        .entries
        .where((element) =>
            (!_supportedChains.getChainById(element.key).isLocalhost()) &&
            _supportedChains.getChainById(element.key) !=
                ChainInfo.unsupported())
        .map((entry) => convert(entry.key, entry.value))
        .toList();
  }
}
