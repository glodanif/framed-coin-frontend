part of './main_page_bloc.dart';

@immutable
abstract class MainPageState {}

class MainPageInitial extends MainPageState {}

class ConnectingWalletState extends MainPageState {}

class ProviderMissingState extends MainPageState {
  final JsLayerError error;

  ProviderMissingState({required this.error});
}

class ErrorState extends MainPageState {
  final JsLayerError error;

  ErrorState({required this.error});
}

class ConnectionChangedState extends MainPageState {
  final String? accountAddress;
  final ChainInfo chainInfo;
  final List<ChainInfo> supportedChains;

  ConnectionChangedState({
    required this.accountAddress,
    required this.chainInfo,
    required this.supportedChains,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionChangedState &&
          runtimeType == other.runtimeType &&
          accountAddress == other.accountAddress &&
          chainInfo == other.chainInfo &&
          supportedChains == other.supportedChains;

  @override
  int get hashCode =>
      accountAddress.hashCode ^
      chainInfo.hashCode ^
      supportedChains.hashCode;
}
