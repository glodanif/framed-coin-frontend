import 'package:equatable/equatable.dart';

class RpcUrlPair extends Equatable {
  final String chainId;
  final String rpcUrl;

  const RpcUrlPair(this.chainId, this.rpcUrl);

  Map<String, dynamic> toJson() {
    return {"chainId": chainId, "rpcUrl": rpcUrl};
  }

  @override
  String toString() {
    return 'RpcUrlPair{chainId: $chainId, rpcUrl: $rpcUrl}';
  }

  @override
  List<Object> get props => [chainId, rpcUrl];
}
