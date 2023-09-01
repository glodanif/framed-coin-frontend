part of 'landing_page_bloc.dart';

@immutable
abstract class LandingPageState {}

class LandingPageInitial extends LandingPageState {}

class ContractsBalanceState extends LandingPageState {
  final String totalNftsValueUsd;
  final String totalSupply;
  final int totalChains;
  final NftViewModel dummyNft;
  final NftViewModel dummySoldNft;

  ContractsBalanceState({
    required this.totalNftsValueUsd,
    required this.totalSupply,
    required this.totalChains,
    required this.dummyNft,
    required this.dummySoldNft,
  });
}
