import 'package:bloc_test/bloc_test.dart';
import 'package:framed_coin_frontend/view/about_page/bloc/about_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/dummies.dart';
import 'utils/mocks.dart';

void main() {
  group('AboutBloc', () {
    late MockSupportedChains supportedChains;
    late MockContractAddressConverter contractAddressConverter;
    late AboutBloc aboutBloc;

    setUp(() {
      supportedChains = MockSupportedChains();
      contractAddressConverter = MockContractAddressConverter();
      aboutBloc = AboutBloc(supportedChains, contractAddressConverter);
    });

    tearDown(() {
      aboutBloc.close();
    });

    blocTest<AboutBloc, AboutState>(
      'loads contract addresses',
      build: () => aboutBloc,
      setUp: () {
        when(() => supportedChains.getContracts())
            .thenAnswer((_) => contractAddressesDummy);
        when(() => contractAddressConverter.convertList(contractAddressesDummy))
            .thenAnswer((_) => contractAddressViewModelsDummy);
      },
      act: (bloc) {
        bloc.loadContracts();
      },
      expect: () => [
        isA<ContractAddressesState>().having(
          (state) => state.contractAddresses,
          "contractAddresses",
          contractAddressViewModelsDummy,
        )
      ],
    );
  });
}
