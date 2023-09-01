import 'package:equatable/equatable.dart';

class Nft extends Equatable {
  final String id;
  final String chainId;
  final String value;
  final String boughtFor;
  final String boughtAt;
  final String soldFor;
  final String soldAt;

  const Nft({
    required this.id,
    required this.chainId,
    required this.value,
    required this.boughtFor,
    required this.boughtAt,
    required this.soldFor,
    required this.soldAt,
  });

  Nft.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chainId = json['chainId'],
        value = json['value'],
        boughtFor = json['boughtFor'],
        boughtAt = json['boughtAt'],
        soldFor = json['soldFor'],
        soldAt = json['soldAt'];

  @override
  List<Object> get props => [
        id,
        chainId,
        value,
        boughtFor,
        boughtAt,
        soldFor,
        soldAt,
      ];
}
