import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ContractState extends Equatable {
  final String mintFee;
  final String minimumValueToMint;
  final String exchangeRate;
  final bool isPaused;
  final String tokenCounter;
  final String availableFees;
  final String totalNftsValue;

  const ContractState({
    required this.mintFee,
    required this.minimumValueToMint,
    required this.exchangeRate,
    required this.isPaused,
    required this.tokenCounter,
    required this.availableFees,
    required this.totalNftsValue,
  });

  ContractState.fromJson(Map<String, dynamic> json)
      : mintFee = json['mintFee'],
        minimumValueToMint = json['minimumValueToMint'],
        exchangeRate = json['exchangeRate'],
        isPaused = json['isPaused'],
        tokenCounter = json['tokenCounter'],
        availableFees = json['availableFees'],
        totalNftsValue = json['totalNftsValue'];

  @override
  List<Object> get props => [
        mintFee,
        minimumValueToMint,
        exchangeRate,
        isPaused,
        tokenCounter,
        availableFees,
        totalNftsValue,
      ];
}
