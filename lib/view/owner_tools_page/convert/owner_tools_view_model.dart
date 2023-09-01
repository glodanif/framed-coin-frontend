import 'package:framed_coin_frontend/domain/chain.dart';

class OwnerToolsViewModel {
  final bool isPaused;
  final String exchangeRateFormatted;
  final String exchangeRate;
  final String mintFee;
  final String mintFeeFormatted;
  final String minimumValueToMintFormatted;
  final String minimumValueToMint;
  final String tokenCounter;
  final String availableFeesFormatted;
  final String availableFees;
  final String totalNftsValueFormatted;
  final String totalNftsValue;
  final String tokenIcon;
  final String tokenLabel;
  final ChainInfo chainInfo;

  OwnerToolsViewModel({
    required this.isPaused,
    required this.exchangeRate,
    required this.mintFee,
    required this.minimumValueToMint,
    required this.tokenCounter,
    required this.availableFees,
    required this.totalNftsValue,
    required this.tokenIcon,
    required this.tokenLabel,
    required this.exchangeRateFormatted,
    required this.mintFeeFormatted,
    required this.minimumValueToMintFormatted,
    required this.availableFeesFormatted,
    required this.totalNftsValueFormatted,
    required this.chainInfo,
  });
}
