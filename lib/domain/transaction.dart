import 'package:equatable/equatable.dart';
import 'package:framed_coin_frontend/domain/chain.dart';

class Transaction extends Equatable {
  final ChainInfo chainInfo;

  bool _isSentForExecution = false;
  bool _isSent = false;
  bool _isConfirmed = false;
  String _hash = "";
  String _explorerLink = "";
  int _confirmations = 0;
  String _result = "";

  bool get isSentForExecution => _isSentForExecution;

  bool get isSent => _isSent;

  bool get isConfirmed => _isConfirmed;

  String get hash => _hash;

  String get explorerLink => _explorerLink;

  int get confirmations => _confirmations;

  String get result => _result;

  Transaction(this.chainInfo);

  void markAsSentForExecution() {
    _isSentForExecution = true;
    _isSent = false;
    _isConfirmed = false;
    _hash = "";
    _explorerLink = "";
    _confirmations = 0;
    _result = "";
  }

  void markAsSent(String hash, int confirmations) {
    _isSentForExecution = false;
    _isSent = true;
    _hash = hash;
    _explorerLink = "${chainInfo.explorerUrl}/tx/$hash";
    _confirmations = confirmations;
  }

  void markAsConfirmed({String result = ""}) {
    _isConfirmed = true;
    _result = result;
  }

  bool isWaitingForUserConfirmation() {
    return _isSentForExecution && !_isSent;
  }

  bool isSending() {
    return !_isSentForExecution && !_isSent;
  }

  bool isWaitingForChainConfirmations() {
    return _isSent && !_isConfirmed;
  }

  @override
  List<Object> get props => [
        _isSentForExecution,
        _isSent,
        _isConfirmed,
        _hash,
        _confirmations,
        _result,
      ];
}
