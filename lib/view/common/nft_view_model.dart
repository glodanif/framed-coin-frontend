import 'dart:ui';

import 'package:equatable/equatable.dart';

class NftViewModel extends Equatable {
  final String id;
  final String idLabel;
  final String value;
  final String boughtFor;
  final String soldFor;
  final String boughtAt;
  final String soldAt;
  final bool isCashedOut;
  final List<Color> gradientColors;
  final List<Color> greyGradientColors;
  final ColorFilter colorFilter;
  final String tokenIcon;
  final String tokenName;
  final String fileName;
  final String shareUrl;

  const NftViewModel({
    required this.id,
    required this.idLabel,
    required this.value,
    required this.boughtFor,
    required this.soldFor,
    required this.boughtAt,
    required this.soldAt,
    required this.isCashedOut,
    required this.gradientColors,
    required this.greyGradientColors,
    required this.colorFilter,
    required this.tokenIcon,
    required this.tokenName,
    required this.fileName,
    required this.shareUrl,
  });

  @override
  List<Object> get props => [
        id,
        idLabel,
        value,
        boughtFor,
        soldFor,
        boughtAt,
        soldAt,
        isCashedOut,
        gradientColors,
        greyGradientColors,
        colorFilter,
        tokenIcon,
        tokenName,
        fileName,
        shareUrl,
      ];
}
