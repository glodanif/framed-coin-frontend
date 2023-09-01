import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/domain/nft.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:intl/intl.dart';

class NftConverter {
  final SupportedChains _supportedChains;
  final dollarFormat = NumberFormat.currency(locale: "en_US", symbol: "\$");
  final dateFormat = DateFormat.yMMMd();

  NftConverter(this._supportedChains);

  NftViewModel convert(Nft nft) {
    final chainInfo = _supportedChains.getChainById(int.parse(nft.chainId));
    final uri = Uri.parse(window.location.href);
    Uri rootUri = Uri(scheme: uri.scheme, host: uri.host, port: uri.port);
    return NftViewModel(
      id: nft.id,
      idLabel: '#${nft.id}',
      value: nft.value.format18Decimals(),
      isCashedOut: nft.soldFor != "0",
      gradientColors: _getGradientColors(chainInfo, nft),
      greyGradientColors: _getGradientColors(chainInfo, nft, forceGray: true),
      tokenIcon: chainInfo.tokenIcon,
      tokenName: chainInfo.tokenName,
      boughtFor: dollarFormat.format(
        double.parse(nft.boughtFor.format18Decimals()),
      ),
      soldFor: dollarFormat.format(
        double.parse(nft.soldFor.format18Decimals()),
      ),
      boughtAt: dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(nft.boughtAt) * 1000),
      ),
      soldAt: dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(nft.soldAt) * 1000),
      ),
      colorFilter: nft.soldFor != "0" ? _blackWhileFilter : _noFilter,
      fileName: "Framed Coin #${nft.id} on ${chainInfo.name}",
      shareUrl:
          "$rootUri/public_view?tokenId=${nft.id}&chainId=${chainInfo.id}",
    );
  }

  List<NftViewModel> convertList(List<Nft> nfts) {
    return nfts.map((e) => convert(e)).toList();
  }

  List<Color> _getGradientColors(ChainInfo chainInfo, Nft nft,
      {bool forceGray = false}) {
    String seed = nft.id +
        nft.value.toString() +
        nft.boughtAt.toString() +
        nft.boughtFor.toString();
    int seedValue = seed.hashCode;
    final random = Random(seedValue);
    List<Color> colors = [];
    colors.add(_getPrimaryColor(chainInfo, nft, forceGray: forceGray));
    for (int i = 0; i < 3; i++) {
      int red = random.nextInt(256);
      int green = random.nextInt(256);
      int blue = random.nextInt(256);
      if (nft.soldFor != "0" || forceGray) {
        int gray = ((red + green + blue) / 3).round();
        red = gray;
        green = gray;
        blue = gray;
      }
      String color =
          '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
      colors.add(Color(int.parse(color.replaceAll('#', '0xff'))));
    }
    return colors;
  }

  Color _getPrimaryColor(ChainInfo chainInfo, Nft nft,
      {bool forceGray = false}) {
    final valueNumber = BigInt.parse(nft.value);
    if (nft.soldFor != "0" || forceGray) {
      return const Color(0xaacccccc);
    } else if (valueNumber >= chainInfo.valueSteps[0].parse18Decimals()) {
      return const Color(0xaaff8000);
    } else if (valueNumber < chainInfo.valueSteps[0].parse18Decimals() &&
        valueNumber >= chainInfo.valueSteps[1].parse18Decimals()) {
      return const Color(0xaaa335ee);
    } else if (valueNumber < chainInfo.valueSteps[1].parse18Decimals() &&
        valueNumber >= chainInfo.valueSteps[2].parse18Decimals()) {
      return const Color(0xaa0070dd);
    } else {
      return const Color(0xaa1eff00);
    }
  }

  final _blackWhileFilter = const ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ]);

  final _noFilter =
      ColorFilter.mode(Colors.black.withOpacity(0), BlendMode.saturation);
}
