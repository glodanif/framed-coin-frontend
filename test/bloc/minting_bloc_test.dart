import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';
import 'package:framed_coin_frontend/view/nft_minting_page/bloc/minting_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('MintingBloc', () {
    late MockBlockchainConnection blockchainConnection;
    late MockMintRepository mintRepository;
    late MintingBloc mintingBloc;

    late StreamController<Transaction> txEventController;

    late StreamController<Connection> connectionEventController;

    final attachedValue = BigInt.two;

    setUp(() {
      blockchainConnection = MockBlockchainConnection();
      mintRepository = MockMintRepository();

      connectionEventController = StreamController<Connection>.broadcast();
      when(() => blockchainConnection.getEventsStream())
          .thenAnswer((_) => connectionEventController.stream);

      txEventController = StreamController<Transaction>.broadcast();

      mintingBloc = MintingBloc(mintRepository, blockchainConnection);
    });

    tearDown(() {
      connectionEventController.close();
      txEventController.close();
      mintingBloc.close();
    });

    blocTest<MintingBloc, MintingState>(
      'loads minting settings',
      build: () => mintingBloc,
      setUp: () {
        when(() => mintRepository.loadMintingSettings())
            .thenAnswer((_) async => mintingSettingsDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
      },
      act: (bloc) {
        bloc.loadMintingSettings();
      },
      expect: () => [
        isA<MintingSettingsState>()
            .having((state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.mintingSettings, "mintingSettings",
                mintingSettingsDummy),
      ],
    );

    blocTest<MintingBloc, MintingState>(
      'handles paused contract state',
      build: () => mintingBloc,
      setUp: () {
        when(() => mintRepository.loadMintingSettings())
            .thenAnswer((_) async => pausedMintingSettingsDummy);
      },
      act: (bloc) {
        bloc.loadMintingSettings();
      },
      expect: () => [isA<PausedState>()],
    );

    blocTest<MintingBloc, MintingState>(
      'handles errors when loading minting settings',
      build: () => mintingBloc,
      setUp: () {
        when(() => mintRepository.loadMintingSettings())
            .thenThrow(unexpectedErrorDummy);
      },
      act: (bloc) {
        bloc.loadMintingSettings();
      },
      expect: () => [
        isA<MintingSettingsUnavailableState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<MintingBloc, MintingState>(
      'mints NFT successfully',
      setUp: () {
        when(() => mintRepository.mintNft(attachedValue))
            .thenAnswer((_) => txEventController.stream);
      },
      build: () => mintingBloc,
      act: (bloc) {
        bloc.mintNft(attachedValue);
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<TxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<TxState>().having((state) => state.tx, "tx", sentTxDummy),
        isA<TxState>().having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<MintingBloc, MintingState>(
      'handles user rejecting minting NFT',
      build: () => mintingBloc,
      setUp: () {
        when(() => mintRepository.mintNft(attachedValue))
            .thenAnswer((_) => txEventController.stream);
        when(() => mintRepository.getMintingSettings())
            .thenAnswer((_) => mintingSettingsDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
      },
      act: (bloc) {
        bloc.mintNft(attachedValue);
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<TxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<MintingSettingsState>()
            .having((state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.mintingSettings, "mintingSettings",
                mintingSettingsDummy),
      ],
    );

    blocTest<MintingBloc, MintingState>(
      'handles errors while minting NFT',
      build: () => mintingBloc,
      setUp: () {
        when(() => mintRepository.mintNft(attachedValue))
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.mintNft(attachedValue);
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<TxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<MintingBloc, MintingState>(
      'reloads minting settings on connection establishment',
      build: () => mintingBloc,
      setUp: () {
        when(() => mintRepository.loadMintingSettings())
            .thenAnswer((_) async => mintingSettingsDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => true);
      },
      act: (bloc) {
        connectionEventController.add(validConnectionDummy);
      },
      expect: () => [
        isA<MintingSettingsState>()
            .having((state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.mintingSettings, "mintingSettings",
                mintingSettingsDummy),
      ],
    );

    blocTest<MintingBloc, MintingState>(
      'ignores disconnect from blockchain',
      build: () => mintingBloc,
      setUp: () {
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => false);
      },
      act: (bloc) {
        connectionEventController.add(disconnectedDummy);
      },
      expect: () => [],
    );

    blocTest<MintingBloc, MintingState>(
      'ignores switch to unsupported chain',
      build: () => mintingBloc,
      setUp: () {
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => false);
      },
      act: (bloc) {
        connectionEventController.add(connectionToNotSupportedChainDummy);
      },
      expect: () => [],
    );
  });
}
