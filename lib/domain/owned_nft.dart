import 'package:equatable/equatable.dart';
import 'package:framed_coin_frontend/domain/nft.dart';

class OwnedNft extends Equatable {
  final Nft nft;
  final String owner;

  const OwnedNft(this.nft, this.owner);

  @override
  List<Object> get props => [nft, owner];
}
