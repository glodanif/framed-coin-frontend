import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/view/main_page/bloc/main_page_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('MainPageBloc', () {
    late MockBlockchainConnection blockchainConnection;
    late MockSupportedChains supportedChains;
    late MainPageBloc mainPageBloc;

    const user = "0x123456789";

    late StreamController<Connection> connectionEventController;

    setUp(() {
      blockchainConnection = MockBlockchainConnection();
      supportedChains = MockSupportedChains();

      connectionEventController = StreamController<Connection>.broadcast();
      when(() => blockchainConnection.getEventsStream())
          .thenAnswer((_) => connectionEventController.stream);
      when(() => supportedChains.getSupportedChains())
          .thenAnswer((_) => supportedChainsDummy);

      mainPageBloc = MainPageBloc(supportedChains, blockchainConnection);
    });

    tearDown(() {
      connectionEventController.close();
      mainPageBloc.close();
    });

    blocTest<MainPageBloc, MainPageState>(
      'handles connection change events',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
      },
      act: (bloc) {
        connectionEventController.add(const Connection(
            userAddress: user, chainInfo: supportedChainDummy));
      },
      expect: () => [
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'checks and loads current connection',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.requestAccount())
            .thenAnswer((_) async => {});
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
      },
      act: (bloc) {
        bloc.checkConnection();
      },
      expect: () => [
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'requests account from Metamask and successfully gets one',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.requestAccount())
            .thenAnswer((_) async => {});
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
      },
      act: (bloc) {
        bloc.requestAccount();
        connectionEventController.add(const Connection(
            userAddress: user, chainInfo: supportedChainDummy));
      },
      expect: () => [
        isA<ConnectingWalletState>(),
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'requests account from Metamask but it\'s not installed',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.requestAccount())
            .thenThrow(missingProviderErrorDummy);
      },
      act: (bloc) {
        bloc.requestAccount();
      },
      expect: () => [
        isA<ConnectingWalletState>(),
        isA<ProviderMissingState>()
            .having((state) => state.error, "error", missingProviderErrorDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'handles user canceling account request',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.requestAccount())
            .thenThrow(rejectionErrorDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
      },
      act: (bloc) {
        bloc.requestAccount();
      },
      expect: () => [
        isA<ConnectingWalletState>(),
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'handles unexpected errors during account request',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.requestAccount())
            .thenThrow(unexpectedErrorDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
      },
      act: (bloc) {
        bloc.requestAccount();
      },
      expect: () => [
        isA<ConnectingWalletState>(),
        isA<ErrorState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'requests chain switch and it\'s successful',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.switchChain(supportedChainDummy.id))
            .thenAnswer((_) async => {});
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
      },
      act: (bloc) {
        bloc.switchChain(supportedChainDummy.id);
        connectionEventController.add(const Connection(
            userAddress: user, chainInfo: supportedChainDummy));
      },
      expect: () => [
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'handles user canceling chain switch',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.switchChain(supportedChainDummy.id))
            .thenThrow(rejectionErrorDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
      },
      act: (bloc) {
        bloc.switchChain(supportedChainDummy.id);
      },
      expect: () => [
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );

    blocTest<MainPageBloc, MainPageState>(
      'handles unexpected errors during chain switch',
      build: () => mainPageBloc,
      setUp: () {
        when(() => blockchainConnection.switchChain(supportedChainDummy.id))
            .thenThrow(unexpectedErrorDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.userAddress).thenAnswer((_) => user);
      },
      act: (bloc) {
        bloc.switchChain(supportedChainDummy.id);
      },
      expect: () => [
        isA<ErrorState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
        isA<ConnectionChangedState>()
            .having((state) => state.accountAddress, "accountAddress", user)
            .having(
                (state) => state.chainInfo, "chainInfo", supportedChainDummy)
            .having((state) => state.supportedChains, "supportedChains",
                supportedChainsDummy),
      ],
    );
  });
}
