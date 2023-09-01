import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/common/part/app_bar_brand_title.dart';
import 'package:framed_coin_frontend/view/common/part/blocking_text.dart';
import 'package:framed_coin_frontend/view/common/part/chain_selector_dropdown.dart';
import 'package:framed_coin_frontend/view/common/part/error_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/install_metamask_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/loading_view.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/theme_switch.dart';
import 'package:framed_coin_frontend/view/main_page/bloc/main_page_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatelessWidget with ErrorDialog {
  final Widget child;

  const MainPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainPageBloc>(
      create: (context) => getIt<MainPageBloc>()..checkConnection(),
      child: BlocListener<MainPageBloc, MainPageState>(
        listenWhen: (previous, current) =>
            current is ErrorState || current is ProviderMissingState,
        listener: (context, state) async {
          if (state is ErrorState) {
            showErrorDialog(context, state.error);
          } else if (state is ProviderMissingState) {
            final result = await InstallMetamaskDialog.show(context);
            if (result == true) {
              launchUrl(Uri.parse("https://metamask.io/"));
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const AppBarBrandTitle(),
            toolbarHeight: 72.0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: const [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [ChainSelector(), ConnectWalletButton()],
                ),
              )
            ],
          ),
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              PageBody(child: child),
              const ThemeSwitch(),
            ],
          ),
        ),
      ),
    );
  }
}

class PageBody extends StatelessWidget {
  final Widget child;

  const PageBody({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageBloc, MainPageState>(
      buildWhen: (previous, current) => current is ConnectionChangedState,
      builder: (context, state) {
        if (state is ConnectionChangedState) {
          if (state.accountAddress == null) {
            return const BlockingText(
              "Connect your waller to use the app",
            );
          } else if (state.chainInfo == ChainInfo.unsupported()) {
            return const BlockingText(
              "Switch to a supported chain to use this app",
            );
          } else {
            return child;
          }
        }
        return const LoadingView();
      },
    );
  }
}

class ChainSelector extends StatelessWidget {
  const ChainSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96.0,
      height: 48.0,
      child: BlocBuilder<MainPageBloc, MainPageState>(
        buildWhen: (previous, current) => current is! ConnectingWalletState,
        builder: (context, state) {
          if (state is ConnectionChangedState && state.accountAddress != null) {
            return Builder(builder: (context) {
              return ChainSelectorDropdown(
                allChains: state.supportedChains,
                selectedChainInfo: state.chainInfo,
                onSwitched: (chainId) {
                  BlocProvider.of<MainPageBloc>(context).switchChain(chainId);
                },
              );
            });
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class ConnectWalletButton extends StatelessWidget {
  const ConnectWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 248.0,
      height: 48.0,
      child: BlocBuilder<MainPageBloc, MainPageState>(
        builder: (context, state) {
          if (state is ConnectingWalletState) {
            return const MainButton(isLoading: true);
          } else if (state is ConnectionChangedState &&
              state.accountAddress != null) {
            return MainButton(
              text: state.accountAddress!.ellipsizeAddress(),
            );
          } else {
            return Builder(builder: (context) {
              return MainButton(
                text: "Connect Wallet",
                onClick: () {
                  BlocProvider.of<MainPageBloc>(context).requestAccount();
                },
              );
            });
          }
        },
      ),
    );
  }
}
