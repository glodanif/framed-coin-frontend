import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/error_converter.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/repository/contract_state_repository.dart';
import 'package:framed_coin_frontend/data/repository/mint_repository.dart';
import 'package:framed_coin_frontend/data/repository/nft_repository.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/view/about_page/bloc/about_bloc.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_converter.dart';
import 'package:framed_coin_frontend/view/common/nft_converter.dart';
import 'package:framed_coin_frontend/view/landing_page/bloc/landing_page_bloc.dart';
import 'package:framed_coin_frontend/view/main_page/bloc/main_page_bloc.dart';
import 'package:framed_coin_frontend/view/nft_details_page/bloc/details_bloc.dart';
import 'package:framed_coin_frontend/view/nft_minting_page/bloc/minting_bloc.dart';
import 'package:framed_coin_frontend/view/nfts_list_page/bloc/nft_list_bloc.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/bloc/owner_tools_bloc.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/convert/owner_tools_converter.dart';
import 'package:framed_coin_frontend/view/public_view_page/bloc/public_view_bloc.dart';
import 'package:framed_coin_frontend/view/verification_page/bloc/verification_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

initDependencies(Map<String, String> smartContracts) {
  getIt.registerLazySingleton<JsBridge>(
    () => JsBridge(),
  );
  getIt.registerLazySingleton<BlockchainConnectionManager>(
    () => BlockchainConnectionManager(
      getIt<JsBridge>(),
      getIt<SupportedChains>(),
    ),
  );
  getIt.registerLazySingleton<SupportedChains>(
    () => SupportedChains(smartContracts),
  );
  getIt.registerLazySingleton<ErrorConverter>(
    () => ErrorConverter(),
  );
  getIt.registerLazySingleton<NftConverter>(
    () => NftConverter(
      getIt<SupportedChains>(),
    ),
  );
  getIt.registerLazySingleton<OwnerToolsConverter>(
    () => OwnerToolsConverter(),
  );
  getIt.registerLazySingleton<ContractAddressConverter>(
    () => ContractAddressConverter(
      getIt<SupportedChains>(),
    ),
  );
  getIt.registerFactoryParam<NftRepository, String, void>(
    (tokenId, _) => NftRepository(
      tokenId,
      getIt<JsBridge>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
  getIt.registerFactory<MintRepository>(
    () => MintRepository(
      getIt<JsBridge>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
  getIt.registerFactory<ContractStateRepository>(
    () => ContractStateRepository(
      getIt<JsBridge>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
  getIt.registerFactory<LandingPageBloc>(
    () => LandingPageBloc(
      getIt<JsBridge>(),
      getIt<SupportedChains>(),
      getIt<NftConverter>(),
    ),
  );
  getIt.registerFactory<AboutBloc>(
    () => AboutBloc(
      getIt<SupportedChains>(),
      getIt<ContractAddressConverter>(),
    ),
  );
  getIt.registerFactory<VerificationBloc>(
    () => VerificationBloc(
      getIt<JsBridge>(),
      getIt<SupportedChains>(),
      getIt<NftConverter>(),
    ),
  );
  getIt.registerFactory<PublicViewBloc>(
    () => PublicViewBloc(
      getIt<JsBridge>(),
      getIt<SupportedChains>(),
      getIt<NftConverter>(),
    ),
  );
  getIt.registerFactory<MainPageBloc>(
    () => MainPageBloc(
      getIt<SupportedChains>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
  getIt.registerFactory<NftListBloc>(
    () => NftListBloc(
      getIt<JsBridge>(),
      getIt<NftConverter>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
  getIt.registerFactory<MintingBloc>(
    () => MintingBloc(
      getIt<MintRepository>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
  getIt.registerFactoryParam<DetailsBloc, String, void>(
    (tokenId, _) => DetailsBloc(
      getIt<NftRepository>(param1: tokenId),
      getIt<NftConverter>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
  getIt.registerFactory<OwnerToolsBloc>(
    () => OwnerToolsBloc(
      getIt<ContractStateRepository>(),
      getIt<OwnerToolsConverter>(),
      getIt<BlockchainConnectionManager>(),
    ),
  );
}
