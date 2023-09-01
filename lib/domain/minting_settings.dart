import 'package:equatable/equatable.dart';

class MintingSettings extends Equatable {
  final String mintFee;
  final String minimumValueToMint;
  final String exchangeRate;
  final String userBalance;
  final bool isPaused;

  const MintingSettings({
    required this.mintFee,
    required this.minimumValueToMint,
    required this.exchangeRate,
    required this.userBalance,
    required this.isPaused,
  });

  MintingSettings.fromJson(Map<String, dynamic> json)
      : mintFee = json['mintFee'],
        minimumValueToMint = json['minimumValueToMint'],
        exchangeRate = json['exchangeRate'],
        userBalance = json['userBalance'],
        isPaused = json['isPaused'];

  @override
  String toString() {
    return 'MintingSettings{mintFee: $mintFee, minimumValueToMint: $minimumValueToMint, exchangeRate: $exchangeRate, userBalance: $userBalance, isPaused: $isPaused}';
  }

  @override
  List<Object> get props =>
      [mintFee, minimumValueToMint, exchangeRate, userBalance, isPaused];
}
