import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';

enum WalletConnectionState { notConnected, connected, loading }

class ConnectButton extends StatelessWidget {
  final WalletConnectionState state;
  final String? account;
  final VoidCallback onClick;

  const ConnectButton(
    this.state, {
    this.account,
    Key? key,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == WalletConnectionState.loading) {
      return const MainButton(
        isLoading: true,
      );
    } else if (state == WalletConnectionState.connected && account != null) {
      return MainButton(
        text: account!,
      );
    } else {
      return MainButton(
        text: '',
        onClick: () {
          onClick();
        },
      );
    }
  }
}
