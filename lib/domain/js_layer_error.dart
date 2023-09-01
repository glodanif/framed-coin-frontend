import 'package:equatable/equatable.dart';
import 'package:framed_coin_frontend/domain/error_code.dart';

class JsLayerError extends Equatable {
  final String code;
  final String name;
  final String message;
  final String raw;

  const JsLayerError({
    required this.code,
    required this.name,
    required this.message,
    required this.raw,
  });

  bool isUserRejection() {
    return code == ErrorCode.rejectedByUser;
  }

  @override
  String toString() {
    return 'JsLayerError{code: $code, name: $name, message: $message, raw: $raw}';
  }

  @override
  List<Object> get props => [code, name, message, raw];
}
