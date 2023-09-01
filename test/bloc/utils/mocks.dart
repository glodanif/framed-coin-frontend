import 'package:framed_coin_frontend/data/blockchain_connection_manager.dart';
import 'package:framed_coin_frontend/data/js/js_bridge.dart';
import 'package:framed_coin_frontend/data/repository/contract_state_repository.dart';
import 'package:framed_coin_frontend/data/repository/mint_repository.dart';
import 'package:framed_coin_frontend/data/repository/nft_repository.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_converter.dart';
import 'package:framed_coin_frontend/view/common/nft_converter.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/convert/owner_tools_converter.dart';
import 'package:mocktail/mocktail.dart';

class MockJsBridge extends Mock implements JsBridge {}

class MockNftRepository extends Mock implements NftRepository {}

class MockMintRepository extends Mock implements MintRepository {}

class MockContractStateRepository extends Mock
    implements ContractStateRepository {}

class MockContractAddressConverter extends Mock
    implements ContractAddressConverter {}

class MockNftConverter extends Mock implements NftConverter {}

class MockOwnerToolsConverter extends Mock implements OwnerToolsConverter {}

class MockSupportedChains extends Mock implements SupportedChains {}

class MockBlockchainConnection extends Mock
    implements BlockchainConnectionManager {}
