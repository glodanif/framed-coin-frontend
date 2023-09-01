import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/domain/nft.dart';
import 'package:framed_coin_frontend/domain/rpc_url_pair.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/view/common/nft_converter.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';

part 'landing_page_state.dart';

class LandingPageBloc extends Cubit<LandingPageState> {
  final JsBridge _jsBridge;
  final SupportedChains _supportedChains;
  final NftConverter _nftConverter;

  final _dummyNft = const Nft(
    id: '17',
    chainId: '11155111',
    value: '2450000000000000000',
    boughtAt: '1687284539',
    boughtFor: '4392580000000000000000',
    soldAt: '0',
    soldFor: '0',
  );

  final _dummySoldNft = const Nft(
    id: '17',
    chainId: '11155111',
    value: '2450000000000000000',
    boughtAt: '1687284539',
    boughtFor: '4392580000000000000000',
    soldAt: '1687811299',
    soldFor: '4547400000000000000000',
  );

  LandingPageBloc(
    this._jsBridge,
    this._supportedChains,
    this._nftConverter,
  ) : super(LandingPageInitial());

  Future<void> loadContractsBalance() async {
    emit(ContractsBalanceState(
      totalNftsValueUsd: "",
      totalSupply: "",
      totalChains: _supportedChains.getSupportedChains().length,
      dummyNft: _nftConverter.convert(_dummyNft),
      dummySoldNft: _nftConverter.convert(_dummySoldNft),
    ));
    final rpcUrls = <RpcUrlPair>[];
    _supportedChains.getSupportedChains().forEach((element) {
      if (!element.isLocalhost()) {
        rpcUrls.add(RpcUrlPair(element.id.toString(), element.rpcUrl));
      }
    });
    final balances = await _jsBridge.getContractsBalance(rpcUrls);
    emit(ContractsBalanceState(
      totalNftsValueUsd: balances.totalNftsValueUsd.formatDollars(),
      totalSupply: balances.totalSupply,
      totalChains: _supportedChains.getSupportedChains().length,
      dummyNft: _nftConverter.convert(_dummyNft),
      dummySoldNft: _nftConverter.convert(_dummySoldNft),
    ));
  }
}
