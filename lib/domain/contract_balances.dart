import 'package:equatable/equatable.dart';

class ContractBalances extends Equatable {
  final String totalNftsValueUsd;
  final String totalSupply;

  const ContractBalances(this.totalNftsValueUsd, this.totalSupply);

  @override
  List<Object?> get props => [totalNftsValueUsd, totalSupply];
}
