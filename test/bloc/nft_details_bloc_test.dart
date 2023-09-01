import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/owned_nft.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';
import 'package:framed_coin_frontend/view/nft_details_page/bloc/details_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('DetailsPageBloc', () {
    late MockBlockchainConnection blockchainConnection;
    late MockNftConverter nftConverter;
    late MockNftRepository nftRepository;
    late DetailsBloc detailsBloc;

    const owner = "0x123456789";
    const stranger = "0x987654321";
    const ownedNft = OwnedNft(nftDummy, owner);

    late StreamController<Transaction> txEventController;

    late StreamController<Connection> connectionEventController;

    setUp(() {
      blockchainConnection = MockBlockchainConnection();
      nftRepository = MockNftRepository();
      nftConverter = MockNftConverter();

      when(() => nftRepository.getNft()).thenAnswer((_) => ownedNft);

      connectionEventController = StreamController<Connection>.broadcast();
      when(() => blockchainConnection.getEventsStream())
          .thenAnswer((_) => connectionEventController.stream);

      txEventController = StreamController<Transaction>.broadcast();

      detailsBloc =
          DetailsBloc(nftRepository, nftConverter, blockchainConnection);
    });

    tearDown(() {
      connectionEventController.close();
      txEventController.close();
      detailsBloc.close();
    });

    blocTest<DetailsBloc, DetailsState>(
      'loads NFT details for its owner',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.loadNftDetails())
            .thenAnswer((_) async => ownedNft);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => owner);
        when(() => nftConverter.convert(nftDummy))
            .thenAnswer((_) => convertedNftDummy);
      },
      act: (bloc) {
        bloc.loadNftDetails();
      },
      expect: () => [
        isA<DetailsInitial>(),
        isA<NftLoadedState>()
            .having((state) => state.nft, "nft", convertedNftDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'blocks strangers trying to access random NFT',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.loadNftDetails())
            .thenAnswer((_) async => ownedNft);
        when(() => blockchainConnection.userAddress)
            .thenAnswer((_) => stranger);
      },
      act: (bloc) {
        bloc.loadNftDetails();
      },
      expect: () => [isA<DetailsInitial>(), isA<StrangerViewState>()],
    );

    blocTest<DetailsBloc, DetailsState>(
      'handles non-existent NFT',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.loadNftDetails()).thenThrow(nftNotFoundErrorDummy);
      },
      act: (bloc) {
        bloc.loadNftDetails();
      },
      expect: () => [
        isA<DetailsInitial>(),
        isA<NftNotFoundState>()
            .having((state) => state.error, "error", nftNotFoundErrorDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'handles any other error',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.loadNftDetails()).thenThrow(unexpectedErrorDummy);
      },
      act: (bloc) {
        bloc.loadNftDetails();
      },
      expect: () => [
        isA<DetailsInitial>(),
        isA<NftUnavailableState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'cashes out NFT successfully',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.cashOutNft())
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.cashOutNft();
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<CashOutTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<CashOutTxState>().having((state) => state.tx, "tx", sentTxDummy),
        isA<CashOutTxState>().having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'handles user rejecting cashing out NFT',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.cashOutNft())
            .thenAnswer((_) => txEventController.stream);
        when(() => nftConverter.convert(nftDummy))
            .thenAnswer((_) => convertedNftDummy);
      },
      act: (bloc) {
        bloc.cashOutNft();
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<CashOutTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<NftLoadedState>()
            .having((state) => state.nft, "error", convertedNftDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'handles errors while cashing out NFT',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.cashOutNft())
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.cashOutNft();
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<CashOutTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'burns down NFT successfully',
      setUp: () {
        when(() => nftRepository.burnNft())
            .thenAnswer((_) => txEventController.stream);
      },
      build: () => detailsBloc,
      act: (bloc) {
        bloc.burnNft();
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<BurnTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<BurnTxState>().having((state) => state.tx, "tx", sentTxDummy),
        isA<BurnTxState>().having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'handles user rejecting burning NFT',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.burnNft())
            .thenAnswer((_) => txEventController.stream);
        when(() => nftConverter.convert(nftDummy))
            .thenAnswer((_) => convertedNftDummy);
      },
      act: (bloc) {
        bloc.burnNft();
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<BurnTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<NftLoadedState>()
            .having((state) => state.nft, "error", convertedNftDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'handles errors while burning NFT',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.burnNft())
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.burnNft();
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<BurnTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'sends downloading data',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.downloadNft("nftId", 0.0, 100.0, 100.0, 100.0))
            .thenAnswer((_) async {});
      },
      act: (bloc) {
        bloc.downloadNft("nftId", 0.0, 100.0, 100.0, 100.0);
      },
      expect: () => [],
    );

    blocTest<DetailsBloc, DetailsState>(
      'handles downloading errors',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.downloadNft("nftId", 0.0, 100.0, 100.0, 100.0))
            .thenThrow(unexpectedErrorDummy);
      },
      act: (bloc) {
        bloc.downloadNft("nftId", 0.0, 100.0, 100.0, 100.0);
      },
      expect: () => [
        isA<ErrorState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'reloads NFT details on connection establishment',
      build: () => detailsBloc,
      setUp: () {
        when(() => nftRepository.loadNftDetails())
            .thenAnswer((_) async => ownedNft);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => owner);
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => true);
        when(() => nftConverter.convert(nftDummy))
            .thenAnswer((_) => convertedNftDummy);
      },
      act: (bloc) {
        connectionEventController.add(validConnectionDummy);
      },
      expect: () => [
        isA<DetailsInitial>(),
        isA<NftLoadedState>()
            .having((state) => state.nft, "nft", convertedNftDummy),
      ],
    );

    blocTest<DetailsBloc, DetailsState>(
      'ignores disconnect from blockchain',
      build: () => detailsBloc,
      setUp: () {
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => false);
      },
      act: (bloc) {
        connectionEventController.add(disconnectedDummy);
      },
      expect: () => [],
    );

    blocTest<DetailsBloc, DetailsState>(
      'ignores switch to unsupported chain',
      build: () => detailsBloc,
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
