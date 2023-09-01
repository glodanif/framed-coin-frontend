import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/logging/logger.dart';

initBlocLogging({bool enabled = true}) {
  if (enabled) {
    Bloc.observer = AppBlocObserver();
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    Logger.bloc('onCreate: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    Logger.bloc('onChange: ${bloc.runtimeType}, change: $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Logger.bloc('onError: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    Logger.bloc('onClose: ${bloc.runtimeType}');
  }
}
