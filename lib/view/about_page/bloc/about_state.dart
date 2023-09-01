part of 'about_bloc.dart';

@immutable
abstract class AboutState {}

class AboutBlocInitial extends AboutState {}

class ContractAddressesState extends AboutState {
  final List<ContractAddressViewModel> contractAddresses;

  ContractAddressesState(this.contractAddresses);
}
