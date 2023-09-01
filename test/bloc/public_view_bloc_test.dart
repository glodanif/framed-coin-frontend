import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/owned_nft.dart';
import 'package:framed_coin_frontend/view/public_view_page/bloc/public_view_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('PublicViewBloc', () {
    late MockJsBridge jsBridge;
    late MockNftConverter nftConverter;
    late MockSupportedChains supportedChains;
    late PublicViewBloc publicViewBloc;

    const supportedChainId = 11111555511111;
    const existentNftId = "321";
    const owner = "0x123456789";

    final explorerUrl =
        "${supportedChainDummy.explorerUrl}/token/${contractAddressesDummy[supportedChainId.toString()]}?a=$existentNftId";

    const ownedNft = OwnedNft(nftDummy, owner);

    const unsupportedChainId = "-1253268211";
    const nonExistentNftId = "-987654321";

    setUp(() {
      jsBridge = MockJsBridge();
      nftConverter = MockNftConverter();
      supportedChains = MockSupportedChains();
      publicViewBloc = PublicViewBloc(jsBridge, supportedChains, nftConverter);
    });

    tearDown(() {
      publicViewBloc.close();
    });

    blocTest<PublicViewBloc, PublicViewState>(
      'loads existing NFT',
      build: () => publicViewBloc,
      setUp: () {
        when(() => supportedChains.getContracts())
            .thenAnswer((_) => contractAddressesDummy);
        when(() => jsBridge.verifyNft(supportedChainDummy, existentNftId))
            .thenAnswer((_) async => ownedNft);
        when(() => supportedChains.getChainById(supportedChainId))
            .thenAnswer((_) => supportedChainDummy);
        when(() => nftConverter.convert(nftDummy))
            .thenAnswer((_) => convertedNftDummy);
      },
      act: (bloc) {
        bloc.loadNft(supportedChainId.toString(), existentNftId);
      },
      expect: () => [
        isA<LoadingNftState>(),
        isA<NftLoadedState>()
            .having((state) => state.nft, "nft", convertedNftDummy)
            .having((state) => state.owner, "owner", owner)
            .having((state) => state.chainName, "chainName",
                supportedChainDummy.name)
            .having((state) => state.explorerUrl, "explorerUrl", explorerUrl)
      ],
    );

    blocTest<PublicViewBloc, PublicViewState>(
      'handles unsupported chain id',
      build: () => publicViewBloc,
      setUp: () {
        when(() => supportedChains.getChainById(int.parse(unsupportedChainId)))
            .thenAnswer((_) => ChainInfo.unsupported());
      },
      act: (bloc) {
        bloc.loadNft(unsupportedChainId, nonExistentNftId);
      },
      expect: () => [
        isA<LoadingNftState>(),
        isA<UnsupportedChainState>()
            .having((state) => state.chainId, "chainId", unsupportedChainId)
      ],
    );

    blocTest<PublicViewBloc, PublicViewState>(
      'handles empty chain id',
      build: () => publicViewBloc,
      act: (bloc) {
        bloc.loadNft("", existentNftId);
      },
      expect: () => [
        isA<LoadingNftState>(),
        isA<UnsupportedChainState>()
            .having((state) => state.chainId, "chainId", "")
      ],
    );

    blocTest<PublicViewBloc, PublicViewState>(
      'handles non-existent NFT',
      build: () => publicViewBloc,
      setUp: () {
        when(() => supportedChains.getChainById(supportedChainId))
            .thenAnswer((_) => supportedChainDummy);
        when(() => supportedChains.getContracts())
            .thenAnswer((_) => contractAddressesDummy);
        when(() => jsBridge.verifyNft(supportedChainDummy, nonExistentNftId))
            .thenThrow(nftNotFoundErrorDummy);
      },
      act: (bloc) {
        bloc.loadNft(supportedChainId.toString(), nonExistentNftId);
      },
      expect: () => [
        isA<LoadingNftState>(),
        isA<NonExistentNft>().having(
            (state) => state.message, "message", nftNotFoundErrorMessageDummy),
      ],
    );

    blocTest<PublicViewBloc, PublicViewState>(
      'handles any other error',
      build: () => publicViewBloc,
      setUp: () {
        when(() => supportedChains.getChainById(supportedChainId))
            .thenAnswer((_) => supportedChainDummy);
        when(() => supportedChains.getContracts())
            .thenAnswer((_) => contractAddressesDummy);
        when(() => jsBridge.verifyNft(supportedChainDummy, existentNftId))
            .thenThrow(unexpectedErrorDummy);
      },
      act: (bloc) {
        bloc.loadNft(supportedChainId.toString(), existentNftId);
      },
      expect: () => [
        isA<LoadingNftState>(),
        isA<ErrorState>()
            .having((state) => state.error, "error", unexpectedErrorDummy),
      ],
    );
  });
}
