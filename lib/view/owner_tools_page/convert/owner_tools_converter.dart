import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/contract_state.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/convert/owner_tools_view_model.dart';
import 'package:intl/intl.dart';

class OwnerToolsConverter {
  final dollarFormat = NumberFormat.currency(locale: "en_US", symbol: "\$");
  final dateFormat = DateFormat.yMMMd();

  OwnerToolsViewModel convert(ContractState state, ChainInfo chainInfo) {
    return OwnerToolsViewModel(
      isPaused: state.isPaused,
      tokenIcon: chainInfo.tokenIcon,
      tokenLabel: chainInfo.tokenName,
      availableFees: state.availableFees,
      availableFeesFormatted: state.availableFees.format18Decimals(),
      exchangeRate: state.exchangeRate,
      exchangeRateFormatted: state.exchangeRate.formatDollars(),
      minimumValueToMint: state.minimumValueToMint,
      minimumValueToMintFormatted: state.minimumValueToMint.format18Decimals(),
      mintFee: state.mintFee,
      mintFeeFormatted: state.mintFee.format18Decimals(),
      tokenCounter: state.tokenCounter,
      totalNftsValue: state.totalNftsValue,
      totalNftsValueFormatted: state.totalNftsValue.format18Decimals(),
      chainInfo: chainInfo,
    );
  }

  List<OwnerToolsViewModel> convertList(
    List<ContractState> states,
    ChainInfo chainInfo,
  ) {
    return states.map((e) => convert(e, chainInfo)).toList();
  }
}
