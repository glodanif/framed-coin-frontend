import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/view/landing_page/bloc/landing_page_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/dummies.dart';
import 'utils/fakes.dart';
import 'utils/mocks.dart';

void main() {
  group('LandingPageBloc', () {
    late MockJsBridge jsBridge;
    late MockNftConverter nftConverter;
    late MockSupportedChains supportedChains;

    late LandingPageBloc landingBloc;

    setUp(() {
      jsBridge = MockJsBridge();
      nftConverter = MockNftConverter();
      supportedChains = MockSupportedChains();
      landingBloc = LandingPageBloc(jsBridge, supportedChains, nftConverter);
    });

    setUpAll(() {
      registerFallbackValue(FakeNft());
    });

    tearDown(() {
      landingBloc.close();
    });

    blocTest<LandingPageBloc, LandingPageState>(
      'loads total contracts balance',
      build: () => landingBloc,
      setUp: () {
        when(() => supportedChains.getSupportedChains())
            .thenAnswer((_) => supportedChainsDummy);
        when(() => nftConverter.convert(any()))
            .thenAnswer((_) => convertedNftDummy);
        when(() => jsBridge.getContractsBalance(rpcPairsDummy))
            .thenAnswer((_) async => contractBalancesDummy);
      },
      act: (bloc) {
        bloc.loadContractsBalance();
      },
      expect: () => [
        isA<ContractsBalanceState>()
            .having((state) => state.totalSupply, "totalSupply", "")
            .having((state) => state.totalNftsValueUsd, "totalNftsValueUsd", "")
            .having((state) => state.totalChains, "totalChains",
                supportedChainsDummy.length)
            .having((state) => state.dummyNft, "dummyNft", convertedNftDummy)
            .having((state) => state.dummySoldNft, "dummySoldNft",
                convertedNftDummy),
        isA<ContractsBalanceState>()
            .having((state) => state.totalSupply, "totalSupply",
                contractBalancesDummy.totalSupply)
            .having((state) => state.totalNftsValueUsd, "totalNftsValueUsd",
                contractBalancesDummy.totalNftsValueUsd.formatDollars())
            .having((state) => state.totalChains, "totalChains",
                supportedChainsDummy.length)
            .having((state) => state.dummyNft, "dummyNft", convertedNftDummy)
            .having((state) => state.dummySoldNft, "dummySoldNft",
                convertedNftDummy),
      ],
    );
  });
}
