import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/view/nfts_list_page/bloc/nft_list_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('NftListBloc', () {
    late MockBlockchainConnection blockchainConnection;
    late MockNftConverter nftConverter;
    late MockJsBridge jsBridge;
    late NftListBloc nftListBloc;

    const owner = "0x123456789";
    const ownedNfts = [nftDummy, anotherNftDummy];
    final ownedConvertedNfts = [convertedNftDummy, anotherConvertedNftDummy];

    late StreamController<Connection> connectionEventController;

    setUp(() {
      blockchainConnection = MockBlockchainConnection();
      jsBridge = MockJsBridge();
      nftConverter = MockNftConverter();

      connectionEventController = StreamController<Connection>.broadcast();
      when(() => blockchainConnection.getEventsStream())
          .thenAnswer((_) => connectionEventController.stream);
      when(() => blockchainConnection.userAddress)
          .thenAnswer((_) => owner);

      nftListBloc = NftListBloc(jsBridge, nftConverter, blockchainConnection);
    });

    tearDown(() {
      connectionEventController.close();
      nftListBloc.close();
    });

    blocTest<NftListBloc, NftListState>(
      'loads NFT list for its owner',
      build: () => nftListBloc,
      setUp: () {
        when(() => jsBridge.getNftsByAddress(owner))
            .thenAnswer((_) async => ownedNfts);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => owner);
        when(() => nftConverter.convertList(ownedNfts))
            .thenAnswer((_) => ownedConvertedNfts);
      },
      act: (bloc) {
        bloc.loadOwnerNfts();
      },
      expect: () => [
        isA<ReceivedOwnerNftsState>()
            .having((state) => state.nfts, "nfts", ownedConvertedNfts),
      ],
    );

    blocTest<NftListBloc, NftListState>(
      'handles any other error',
      build: () => nftListBloc,
      setUp: () {
        when(() => jsBridge.getNftsByAddress(owner))
            .thenThrow(unexpectedErrorDummy);
      },
      act: (bloc) {
        bloc.loadOwnerNfts();
      },
      expect: () => [
        isA<ErrorState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<NftListBloc, NftListState>(
      'reloads NFT list on connection establishment',
      build: () => nftListBloc,
      setUp: () {
        when(() => jsBridge.getNftsByAddress(owner))
            .thenAnswer((_) async => ownedNfts);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => owner);
        when(() => nftConverter.convertList(ownedNfts))
            .thenAnswer((_) => ownedConvertedNfts);
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => true);
      },
      act: (bloc) {
        connectionEventController.add(validConnectionDummy);
      },
      expect: () => [
        isA<ReceivedOwnerNftsState>()
            .having((state) => state.nfts, "nfts", ownedConvertedNfts),
      ],
    );

    blocTest<NftListBloc, NftListState>(
      'ignores disconnect from blockchain',
      build: () => nftListBloc,
      setUp: () {
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => false);
      },
      act: (bloc) {
        connectionEventController.add(disconnectedDummy);
      },
      expect: () => [],
    );

    blocTest<NftListBloc, NftListState>(
      'ignores switch to unsupported chain',
      build: () => nftListBloc,
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
