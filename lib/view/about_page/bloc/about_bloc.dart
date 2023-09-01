import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/data/supported_chains.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_converter.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_view_model.dart';

part 'about_state.dart';

class AboutBloc extends Cubit<AboutState> {
  final SupportedChains _supportedChains;
  final ContractAddressConverter _addressConverter;

  AboutBloc(
    this._supportedChains,
    this._addressConverter,
  ) : super(AboutBlocInitial());

  loadContracts() {
    final contracts = _supportedChains.getContracts();
    emit(ContractAddressesState(_addressConverter.convertList(contracts)));
  }
}
