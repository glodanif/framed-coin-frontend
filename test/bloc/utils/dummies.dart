import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/contract_balances.dart';
import 'package:framed_coin_frontend/domain/contract_state.dart';
import 'package:framed_coin_frontend/domain/error_code.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/domain/minting_settings.dart';
import 'package:framed_coin_frontend/domain/nft.dart';
import 'package:framed_coin_frontend/domain/rpc_url_pair.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_view_model.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/convert/owner_tools_view_model.dart';

final supportedChainsDummy = [
  const ChainInfo(
    id: 11111555511111,
    name: 'Ethereum Sepolia',
    smartContractAddress: '0x1',
    chainIcon: 'assets/ic_ethereum.png',
    tokenIcon: 'assets/unit_ether.png',
    tokenName: 'ETH',
    rpcUrl: 'https://ethereum-sepolia.blockpi.network/v1/rpc/public',
    valueSteps: ["10", "1", "0.5"],
    explorerUrl: 'https://sepolia.etherscan.io',
    isTestnet: true,
  ),
  const ChainInfo(
    id: 80001,
    name: 'Polygon Mumbai',
    smartContractAddress: '0x2',
    chainIcon: 'assets/ic_polygon.png',
    tokenIcon: 'assets/unit_matic.png',
    tokenName: 'MATIC',
    rpcUrl: 'https://polygon-mumbai.blockpi.network/v1/rpc/public',
    valueSteps: ["20000", "2000", "1000"],
    explorerUrl: 'https://mumbai.polygonscan.com',
    isTestnet: true,
  ),
  const ChainInfo(
    id: 31337,
    name: 'Hardhat Localhost',
    smartContractAddress: '0x3',
    chainIcon: 'assets/ic_hardhat.png',
    tokenIcon: 'assets/unit_ether.png',
    tokenName: 'ETH',
    rpcUrl: 'http://127.0.0.1:8545/',
    valueSteps: ["10", "1", "0.5"],
    explorerUrl: "http://127.0.0.1:8545/",
    isTestnet: true,
  ),
];

const supportedChainDummy = ChainInfo(
  id: 11111555511111,
  name: 'Ethereum Sepolia',
  smartContractAddress: '0x1',
  chainIcon: 'assets/ic_ethereum.png',
  tokenIcon: 'assets/unit_ether.png',
  tokenName: 'ETH',
  rpcUrl: 'https://ethereum-sepolia.blockpi.network/v1/rpc/public',
  valueSteps: ["10", "1", "0.5"],
  explorerUrl: 'https://sepolia.etherscan.io',
  isTestnet: true,
);

const validConnectionDummy = Connection(
  chainInfo: supportedChainDummy,
  userAddress: "0x123456789",
);

final connectionToNotSupportedChainDummy = Connection(
  chainInfo: ChainInfo.unsupported(),
  userAddress: "0x123456789",
);

final disconnectedDummy = Connection(
  chainInfo: ChainInfo.unsupported(),
  userAddress: null,
);

const contractBalancesDummy = ContractBalances("193164259000000000000", "4");

final rpcPairsDummy = [
  const RpcUrlPair("11111555511111",
      "https://ethereum-sepolia.blockpi.network/v1/rpc/public"),
  const RpcUrlPair(
      "80001", "https://polygon-mumbai.blockpi.network/v1/rpc/public"),
];

const nftDummy = Nft(
  id: "141",
  chainId: '11111555511111',
  value: '2450000000000000000',
  boughtAt: '1687284539',
  boughtFor: '4392580000000000000000',
  soldAt: '0',
  soldFor: '0',
);

const anotherNftDummy = Nft(
  id: "142",
  chainId: '11111555511111',
  value: '2450000000000000000',
  boughtAt: '1687284539',
  boughtFor: '4392580000000000000000',
  soldAt: '0',
  soldFor: '0',
);

final convertedNftDummy = NftViewModel(
  id: "141",
  idLabel: "#141",
  value: "1",
  isCashedOut: false,
  gradientColors: const <Color>[Colors.black12, Colors.white30],
  greyGradientColors: const <Color>[Colors.black12, Colors.white30],
  tokenIcon: "tokenIcon",
  tokenName: "tokenName",
  boughtFor: "boughtFor",
  soldFor: "soldFor",
  boughtAt: "boughtAt",
  soldAt: "soldAt",
  colorFilter:
      ColorFilter.mode(Colors.black.withOpacity(0), BlendMode.saturation),
  fileName: "name",
  shareUrl: "shareUrl",
);

final anotherConvertedNftDummy = NftViewModel(
  id: "142",
  idLabel: "#143",
  value: "1",
  isCashedOut: false,
  gradientColors: const <Color>[Colors.black12, Colors.white30],
  greyGradientColors: const <Color>[Colors.black12, Colors.white30],
  tokenIcon: "tokenIcon",
  tokenName: "tokenName",
  boughtFor: "boughtFor",
  soldFor: "soldFor",
  boughtAt: "boughtAt",
  soldAt: "soldAt",
  colorFilter:
      ColorFilter.mode(Colors.black.withOpacity(0), BlendMode.saturation),
  fileName: "name",
  shareUrl: "shareUrl",
);

final contractAddressViewModelsDummy = [
  ContractAddressViewModel(
    chainId: "11111555511111",
    chainName: "1",
    contractAddress: "1",
    explorerLink: Uri.parse("http://127.0.0.1"),
    chainIcon: "1",
    isTestnet: true,
  ),
  ContractAddressViewModel(
    chainId: "2",
    chainName: "2",
    contractAddress: "2",
    explorerLink: Uri.parse("http://127.0.0.1"),
    chainIcon: "2",
    isTestnet: true,
  ),
];

final contractAddressesDummy = {
  "11111555511111": "0x11111111111111111",
  "2": "0x22222222222222222",
};

const missingProviderErrorDummy = JsLayerError(
  code: ErrorCode.providerMissing,
  name: "name21",
  message: "message21",
  raw: "raw21",
);

const rejectionErrorDummy = JsLayerError(
  code: ErrorCode.rejectedByUser,
  name: "name23",
  message: "message23",
  raw: "raw23",
);

const unexpectedErrorDummy = JsLayerError(
  code: "code367",
  name: "name367",
  message: "message367",
  raw: "raw367",
);

const nftNotFoundErrorMessageDummy = "404 Not Found";

const nftNotFoundErrorDummy = JsLayerError(
  code: ErrorCode.fcNotFound,
  name: "name98",
  message: nftNotFoundErrorMessageDummy,
  raw: "raw98",
);

const unauthorizedErrorDummy = JsLayerError(
  code: ErrorCode.fcUnauthorized,
  name: "name57",
  message: "message57",
  raw: "raw57",
);

const mintingSettingsDummy = MintingSettings(
  mintFee: '12',
  minimumValueToMint: '120',
  exchangeRate: '10',
  userBalance: '100',
  isPaused: false,
);

const pausedMintingSettingsDummy = MintingSettings(
  mintFee: '12',
  minimumValueToMint: '120',
  exchangeRate: '10',
  userBalance: '100',
  isPaused: true,
);

final _preparedTx = Transaction(supportedChainDummy);

Transaction get preparedTxDummy {
  _preparedTx.markAsSentForExecution();
  return _preparedTx;
}

final _sentTx = Transaction(supportedChainDummy);

Transaction get sentTxDummy {
  _sentTx.markAsSentForExecution();
  _sentTx.markAsSent("hash", 7);
  return _sentTx;
}

final _confirmedTx = Transaction(supportedChainDummy);

Transaction get confirmedTxDummy {
  _confirmedTx.markAsSentForExecution();
  _confirmedTx.markAsSent("hash", 7);
  _confirmedTx.markAsConfirmed();
  return _confirmedTx;
}

const contractStateDummy = ContractState(
  mintFee: '150000',
  minimumValueToMint: '3000000',
  exchangeRate: '1111000000000',
  isPaused: false,
  tokenCounter: '32',
  availableFees: '20000000000',
  totalNftsValue: '123000000000000',
);

final ownerToolsViewConvertedDummy = OwnerToolsViewModel(
  isPaused: false,
  tokenIcon: "tokenIcon",
  tokenLabel: "tokenName",
  availableFees: "500000000000000",
  availableFeesFormatted: "5",
  exchangeRate: "12340000000000000000",
  exchangeRateFormatted: "\$1234",
  minimumValueToMint: "15000000000000000",
  minimumValueToMintFormatted: "15",
  mintFee: "70000000000000",
  mintFeeFormatted: "7",
  tokenCounter: "32",
  totalNftsValue: "1230000000000",
  totalNftsValueFormatted: "123",
  chainInfo: supportedChainDummy,
);
