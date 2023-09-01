import 'package:equatable/equatable.dart';
import 'package:framed_coin_frontend/domain/chain.dart';

class Connection extends Equatable {
  final String? userAddress;
  final ChainInfo chainInfo;

  const Connection({
    required this.userAddress,
    required this.chainInfo,
  });

  @override
  String toString() {
    return 'BlockchainConnection{chainId: $chainInfo, userAddress: $userAddress}';
  }

  @override
  List<Object?> get props => [chainInfo, userAddress];
}
