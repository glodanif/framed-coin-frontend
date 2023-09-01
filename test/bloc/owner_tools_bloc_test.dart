import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/domain/connection_state.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/bloc/owner_tools_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('OwnerToolsBloc', () {
    late MockBlockchainConnection blockchainConnection;
    late MockContractStateRepository repository;
    late MockOwnerToolsConverter converter;
    late OwnerToolsBloc ownerToolsBloc;

    late StreamController<Transaction> txEventController;

    late StreamController<Connection> connectionEventController;

    const newMintFee = "120000000000000000";
    const newMinimumValueToMint = "240000000000000000";

    setUp(() {
      blockchainConnection = MockBlockchainConnection();
      repository = MockContractStateRepository();
      converter = MockOwnerToolsConverter();

      connectionEventController = StreamController<Connection>.broadcast();
      when(() => blockchainConnection.getEventsStream())
          .thenAnswer((_) => connectionEventController.stream);

      txEventController = StreamController<Transaction>.broadcast();

      ownerToolsBloc =
          OwnerToolsBloc(repository, converter, blockchainConnection);
    });

    tearDown(() {
      connectionEventController.close();
      txEventController.close();
      ownerToolsBloc.close();
    });

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'loads contract state',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.loadContractState())
            .thenAnswer((_) async => contractStateDummy);
        when(() => converter.convert(contractStateDummy, supportedChainDummy))
            .thenAnswer((_) => ownerToolsViewConvertedDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
      },
      act: (bloc) {
        bloc.loadContractState();
      },
      expect: () => [
        isA<OwnerToolsReceivedState>().having((state) => state.viewModel,
            "viewModel", ownerToolsViewConvertedDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'blocks strangers from accessing owner tools',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.loadContractState())
            .thenThrow(unauthorizedErrorDummy);
      },
      act: (bloc) {
        bloc.loadContractState();
      },
      expect: () => [
        isA<NotAuthorizedState>()
            .having((state) => state.error, "error", unauthorizedErrorDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles errors when loading contract state',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.loadContractState())
            .thenThrow(unexpectedErrorDummy);
      },
      act: (bloc) {
        bloc.loadContractState();
      },
      expect: () => [
        isA<UnexpectedErrorState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'pauses contract successfully',
      setUp: () {
        when(() => repository.pause())
            .thenAnswer((_) => txEventController.stream);
      },
      build: () => ownerToolsBloc,
      act: (bloc) {
        bloc.pause();
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<PauseTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<PauseTxState>().having((state) => state.tx, "tx", sentTxDummy),
        isA<PauseTxState>().having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles user rejecting pausing contract',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.pause())
            .thenAnswer((_) => txEventController.stream);
        when(() => repository.getContractState())
            .thenAnswer((_) => contractStateDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => converter.convert(contractStateDummy, supportedChainDummy))
            .thenAnswer((_) => ownerToolsViewConvertedDummy);
      },
      act: (bloc) {
        bloc.pause();
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<PauseTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<OwnerToolsReceivedState>().having((state) => state.viewModel,
            "viewModel", ownerToolsViewConvertedDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles errors while pausing contract',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.pause())
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.pause();
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<PauseTxState>().having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'unpauses contract successfully',
      setUp: () {
        when(() => repository.unPause())
            .thenAnswer((_) => txEventController.stream);
      },
      build: () => ownerToolsBloc,
      act: (bloc) {
        bloc.unPause();
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<UnPauseTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<UnPauseTxState>().having((state) => state.tx, "tx", sentTxDummy),
        isA<UnPauseTxState>()
            .having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles user rejecting unpausing contract',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.unPause())
            .thenAnswer((_) => txEventController.stream);
        when(() => repository.getContractState())
            .thenAnswer((_) => contractStateDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => converter.convert(contractStateDummy, supportedChainDummy))
            .thenAnswer((_) => ownerToolsViewConvertedDummy);
      },
      act: (bloc) {
        bloc.unPause();
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<UnPauseTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<OwnerToolsReceivedState>().having((state) => state.viewModel,
            "viewModel", ownerToolsViewConvertedDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles errors while unpausing contract',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.unPause())
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.unPause();
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<UnPauseTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'withdraws fees successfully',
      setUp: () {
        when(() => repository.withdrawFees())
            .thenAnswer((_) => txEventController.stream);
      },
      build: () => ownerToolsBloc,
      act: (bloc) {
        bloc.withdrawFees();
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<WithdrawFeesTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<WithdrawFeesTxState>()
            .having((state) => state.tx, "tx", sentTxDummy),
        isA<WithdrawFeesTxState>()
            .having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles user rejecting withdrawing fees',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.withdrawFees())
            .thenAnswer((_) => txEventController.stream);
        when(() => repository.getContractState())
            .thenAnswer((_) => contractStateDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => converter.convert(contractStateDummy, supportedChainDummy))
            .thenAnswer((_) => ownerToolsViewConvertedDummy);
      },
      act: (bloc) {
        bloc.withdrawFees();
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<WithdrawFeesTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<OwnerToolsReceivedState>().having((state) => state.viewModel,
            "viewModel", ownerToolsViewConvertedDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles errors while withdrawing fees',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.withdrawFees())
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.withdrawFees();
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<WithdrawFeesTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'setting new mint fee successfully',
      setUp: () {
        when(() => repository.setNewMintFee(newMintFee))
            .thenAnswer((_) => txEventController.stream);
      },
      build: () => ownerToolsBloc,
      act: (bloc) {
        bloc.setNewMintFee(newMintFee);
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<NewMintFeeTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<NewMintFeeTxState>().having((state) => state.tx, "tx", sentTxDummy),
        isA<NewMintFeeTxState>()
            .having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles user rejecting setting new mint fee',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.setNewMintFee(newMintFee))
            .thenAnswer((_) => txEventController.stream);
        when(() => repository.getContractState())
            .thenAnswer((_) => contractStateDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => converter.convert(contractStateDummy, supportedChainDummy))
            .thenAnswer((_) => ownerToolsViewConvertedDummy);
      },
      act: (bloc) {
        bloc.setNewMintFee(newMintFee);
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<NewMintFeeTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<OwnerToolsReceivedState>().having((state) => state.viewModel,
            "viewModel", ownerToolsViewConvertedDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles errors while setting new mint fee',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.setNewMintFee(newMintFee))
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.setNewMintFee(newMintFee);
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<NewMintFeeTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'setting new minimum value to mint successfully',
      setUp: () {
        when(() => repository.setNewMinimumValueToMint(newMinimumValueToMint))
            .thenAnswer((_) => txEventController.stream);
      },
      build: () => ownerToolsBloc,
      act: (bloc) {
        bloc.setNewMinimumValueToMint(newMinimumValueToMint);
        txEventController.add(preparedTxDummy);
        txEventController.add(sentTxDummy);
        txEventController.add(confirmedTxDummy);
      },
      expect: () => [
        isA<NewMinimumValueToMintTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<NewMinimumValueToMintTxState>()
            .having((state) => state.tx, "tx", sentTxDummy),
        isA<NewMinimumValueToMintTxState>()
            .having((state) => state.tx, "tx", confirmedTxDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles user rejecting setting new minimum value to mint',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.setNewMinimumValueToMint(newMinimumValueToMint))
            .thenAnswer((_) => txEventController.stream);
        when(() => repository.getContractState())
            .thenAnswer((_) => contractStateDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => converter.convert(contractStateDummy, supportedChainDummy))
            .thenAnswer((_) => ownerToolsViewConvertedDummy);
      },
      act: (bloc) {
        bloc.setNewMinimumValueToMint(newMinimumValueToMint);
        txEventController.add(preparedTxDummy);
        txEventController.addError(rejectionErrorDummy);
      },
      expect: () => [
        isA<NewMinimumValueToMintTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<OwnerToolsReceivedState>().having((state) => state.viewModel,
            "viewModel", ownerToolsViewConvertedDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'handles errors while setting new minimum value to mint',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.setNewMinimumValueToMint(newMinimumValueToMint))
            .thenAnswer((_) => txEventController.stream);
      },
      act: (bloc) {
        bloc.setNewMinimumValueToMint(newMinimumValueToMint);
        txEventController.add(preparedTxDummy);
        txEventController.addError(unexpectedErrorDummy);
      },
      expect: () => [
        isA<NewMinimumValueToMintTxState>()
            .having((state) => state.tx, "tx", preparedTxDummy),
        isA<TransactionFailedState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'reloads contract state on connection establishment',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => repository.loadContractState())
            .thenAnswer((_) async => contractStateDummy);
        when(() => converter.convert(contractStateDummy, supportedChainDummy))
            .thenAnswer((_) => ownerToolsViewConvertedDummy);
        when(() => blockchainConnection.chainInfo)
            .thenAnswer((_) => supportedChainDummy);
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => true);
      },
      act: (bloc) {
        connectionEventController.add(validConnectionDummy);
      },
      expect: () => [
        isA<OwnerToolsReceivedState>().having((state) => state.viewModel,
            "viewModel", ownerToolsViewConvertedDummy),
      ],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'ignores disconnect from blockchain',
      build: () => ownerToolsBloc,
      setUp: () {
        when(() => blockchainConnection.isConnectedToSupportedChain())
            .thenAnswer((_) => false);
      },
      act: (bloc) {
        connectionEventController.add(disconnectedDummy);
      },
      expect: () => [],
    );

    blocTest<OwnerToolsBloc, OwnerToolsState>(
      'ignores switch to unsupported chain',
      build: () => ownerToolsBloc,
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
