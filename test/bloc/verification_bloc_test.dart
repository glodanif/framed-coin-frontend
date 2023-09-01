import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/domain/owned_nft.dart';
import 'package:framed_coin_frontend/view/verification_page/bloc/verification_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('VerificationBloc', () {
    late MockJsBridge jsBridge;
    late MockNftConverter nftConverter;
    late MockSupportedChains supportedChains;
    late VerificationBloc verificationBloc;

    const chainId = 11111555511111;
    const nftId = "141";
    const owner = "0x123456789";
    const nonExistentNftId = "987654321";

    final explorerUrl =
        "${supportedChainDummy.explorerUrl}/token/${contractAddressesDummy[chainId.toString()]}?a=$nftId";

    const ownedNft = OwnedNft(nftDummy, owner);

    setUp(() {
      jsBridge = MockJsBridge();
      nftConverter = MockNftConverter();
      supportedChains = MockSupportedChains();
      verificationBloc =
          VerificationBloc(jsBridge, supportedChains, nftConverter);
    });

    tearDown(() {
      verificationBloc.close();
    });

    blocTest<VerificationBloc, VerificationState>(
      'loads supported chains',
      build: () => verificationBloc,
      setUp: () {
        when(() => supportedChains.getDefaultChain())
            .thenAnswer((_) => supportedChainDummy);
        when(() => supportedChains.getSupportedChains())
            .thenAnswer((_) => supportedChainsDummy);
      },
      act: (bloc) {
        bloc.loadChains();
      },
      expect: () => [
        isA<ChainsLoadedState>()
            .having((state) => state.defaultChain, "defaultChain",
                supportedChainDummy)
            .having(
                (state) => state.allChains, "allChains", supportedChainsDummy)
      ],
    );

    blocTest<VerificationBloc, VerificationState>(
      'verifies existing NFT',
      build: () => verificationBloc,
      setUp: () {
        when(() => supportedChains.getContracts())
            .thenAnswer((_) => contractAddressesDummy);
        when(() => jsBridge.verifyNft(supportedChainDummy, nftId))
            .thenAnswer((_) async => ownedNft);
        when(() => supportedChains.getChainById(chainId))
            .thenAnswer((_) => supportedChainDummy);
        when(() => nftConverter.convert(nftDummy))
            .thenAnswer((_) => convertedNftDummy);
      },
      act: (bloc) {
        bloc.verifyNft(chainId, nftId);
      },
      expect: () => [
        isA<VerificationProcessState>(),
        isA<VerifiedState>()
            .having((state) => state.nft, "nft", convertedNftDummy)
            .having((state) => state.owner, "owner", owner)
            .having((state) => state.explorerUrl, "explorerUrl", explorerUrl)
      ],
    );

    blocTest<VerificationBloc, VerificationState>(
      'handles non-existent NFT',
      build: () => verificationBloc,
      setUp: () {
        when(() => supportedChains.getChainById(chainId))
            .thenAnswer((_) => supportedChainDummy);
        when(() => supportedChains.getContracts())
            .thenAnswer((_) => contractAddressesDummy);
        when(() => jsBridge.verifyNft(supportedChainDummy, nonExistentNftId))
            .thenThrow(nftNotFoundErrorDummy);
      },
      act: (bloc) {
        bloc.verifyNft(chainId, nonExistentNftId);
      },
      expect: () => [
        isA<VerificationProcessState>(),
        isA<NonExistentNft>().having(
            (state) => state.message, "message", nftNotFoundErrorMessageDummy),
      ],
    );

    blocTest<VerificationBloc, VerificationState>(
      'handles any other error',
      build: () => verificationBloc,
      setUp: () {
        when(() => supportedChains.getChainById(chainId))
            .thenAnswer((_) => supportedChainDummy);
        when(() => supportedChains.getContracts())
            .thenAnswer((_) => contractAddressesDummy);
        when(() => jsBridge.verifyNft(supportedChainDummy, nftId))
            .thenThrow(unexpectedErrorDummy);
      },
      act: (bloc) {
        bloc.verifyNft(chainId, nftId);
      },
      expect: () => [
        isA<VerificationProcessState>(),
        isA<ErrorState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );
  });
}
