import 'dart:convert';

import 'package:framed_coin_frontend/domain/error_code.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/logging/logger.dart';

class ErrorConverter {

  ErrorConverter();

  JsLayerError convert(String errorBody) {
    Logger.error('JS Error: ${errorBody.toString()}');
    final errorJson = json.decode(errorBody.toString()) as Map<String, dynamic>;

    if (errorJson.containsKey('revert') && errorJson['revert'] != null) {
      final revertReason = errorJson['revert']['name'];
      return JsLayerError(
        code: revertReason,
        name: _nameFromCode(revertReason),
        message: _getReadableMessage(revertReason, ''),
        raw: errorBody.toString(),
      );
    }

    if (errorJson.containsKey('info')) {
      final info = errorJson['info'] as Map<String, dynamic>;
      if (info.containsKey('error')) {
        final error = info['error'] as Map<String, dynamic>;
        if (error.containsKey('data')) {
          final data = error['data'] as Map<String, dynamic>;
          if (data.containsKey('code') && data.containsKey('message')) {
            final code = _hijackCode(data['code'].toString(), data['message']);
            return JsLayerError(
              code: code,
              name: _nameFromCode(code),
              message: _getReadableMessage(code, data['message']),
              raw: errorBody.toString(),
            );
          }
        } else if (error.containsKey('code') && error.containsKey('message')) {
          return JsLayerError(
            code: error['code'].toString(),
            name: _nameFromCode(error['code'].toString()),
            message: _getReadableMessage(
              error['code'].toString(),
              error['message'],
            ),
            raw: errorBody.toString(),
          );
        }
      }
    }

    if (errorJson.containsKey('code') &&
        errorJson.containsKey('message') &&
        errorJson.containsKey('stack')) {
      return JsLayerError(
        code: errorJson['code'].toString(),
        name: _nameFromCode(errorJson['code'].toString()),
        message: _getReadableMessage(
          errorJson['code'].toString(),
          errorJson['message'],
        ),
        raw: errorBody.toString(),
      );
    }

    if (errorJson.containsKey('code') && errorJson.containsKey('message')) {
      return JsLayerError(
        code: errorJson['code'],
        name: _nameFromCode(errorJson['code']),
        message: _getReadableMessage(
          errorJson['code'].toString(),
          errorJson['message'],
        ),
        raw: errorBody.toString(),
      );
    }

    return JsLayerError(
      code: '0',
      name: 'Unexpected error',
      message: 'Unexpected error',
      raw: errorBody.toString(),
    );
  }

  String _nameFromCode(String code) {
    switch (code) {
      case ErrorCode.providerMissing:
        return "Matamask extension is missing";
      case ErrorCode.insufficientFunds:
        return "Insufficient funds";
      case ErrorCode.rejectedByUser:
        return "Rejected by user";
      case ErrorCode.fcUnauthorized:
        return "Unauthorized";
      case ErrorCode.fcNotFound:
        return "Not Found";
      case ErrorCode.fcWithdrawFailed:
        return "Withdraw failed";
      case ErrorCode.fcUnauthorizedNftAccess:
        return "Unauthorized Nft Access";
    }
    return "Unexpected error (code: $code)";
  }

  String _getReadableMessage(String code, String message) {
    switch (code) {
      case ErrorCode.providerMissing:
        return "In order to connect to blockchain you need Metamask browser extension installed.\n\nOther providers may get available later...";
      case ErrorCode.insufficientFunds:
        return "Looks like you don't have enough funds on your account for this transaction\n\n$message";
      case ErrorCode.rejectedByUser:
        return "You've rejected the action";
      case ErrorCode.fcUnauthorized:
        return "You are not authorized to access this functionality, please make sure you are using correct account";
      case ErrorCode.fcNotFound:
        return "NFT with this id does not exist. It probably hasn't been minted yet or it has been burnt by its owner";
      case ErrorCode.fcWithdrawFailed:
        return "Unexpected error while transferring funds";
      case ErrorCode.fcUnauthorizedNftAccess:
        return "You are not authorized to manage this NFT, please make sure you are using correct account";
    }
    return "Unexpected error (code: $code, message: $message)";
  }

  String _hijackCode(String code, String message) {
    if (message.contains("FramedCoin__Unauthorized")) {
      return ErrorCode.fcUnauthorized;
    } else if (message.contains("FramedCoin__NotFound")) {
      return ErrorCode.fcNotFound;
    } else if (message.contains("FramedCoin__UnauthorizedNftAccess")) {
      return ErrorCode.fcUnauthorizedNftAccess;
    } else if (message.contains("FramedCoin__WithdrawFailed")) {
      return ErrorCode.fcWithdrawFailed;
    } else {
      return code;
    }
  }
}
