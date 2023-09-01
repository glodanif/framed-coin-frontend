import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/common/part/blocking_text.dart';
import 'package:framed_coin_frontend/view/common/part/chain_selector_dropdown.dart';
import 'package:framed_coin_frontend/view/common/part/error_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/link.dart';
import 'package:framed_coin_frontend/view/common/part/loading_view.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/nft_list_item.dart';
import 'package:framed_coin_frontend/view/common/part/row_divider.dart';
import 'package:framed_coin_frontend/view/verification_page/bloc/verification_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class VerificationBody extends StatefulWidget {
  const VerificationBody({super.key});

  @override
  State<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody> with ErrorDialog {
  final _textController = TextEditingController();
  int _chainId = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VerificationBloc>()..loadChains(),
      child: BlocConsumer<VerificationBloc, VerificationState>(
          listenWhen: (previous, current) => current is ErrorState,
          listener: (context, state) {
            if (state is ErrorState) {
              showErrorDialog(context, state.error);
            }
          },
          buildWhen: (previous, current) => current is ChainsLoadedState,
          builder: (context, state) {
            if (state is ChainsLoadedState) {
              _chainId = state.defaultChain.id;
              return _buildForm(state.defaultChain, state.allChains);
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _buildForm(ChainInfo defaultChain, List<ChainInfo> allChains) {
    return Column(
      children: [
        _buildResponsiveInputs(defaultChain, allChains),
        const SizedBox(height: 32.0),
        const RowDivider(),
        const SizedBox(height: 32.0),
        const VerifyingResult(),
      ],
    );
  }

  Widget _buildResponsiveInputs(
    ChainInfo defaultChain,
    List<ChainInfo> allChains,
  ) {
    return ResponsiveBreakpoints.of(context).largerThan(MOBILE)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInputs(defaultChain, allChains),
              const SizedBox(width: 24.0),
              _buildVerifyButton(),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInputs(defaultChain, allChains),
              const SizedBox(height: 24.0),
              _buildVerifyButton(),
            ],
          );
  }

  Widget _buildInputs(ChainInfo defaultChain, List<ChainInfo> allChains) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 48.0,
          width: 164.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child:
                    Text("#", style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: TextField(
                  controller: _textController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "NFT id",
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
        Text("on", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 12.0),
        ChainSelectorDropdown(
          allChains: allChains,
          selectedChainInfo: defaultChain,
          mainColor: Theme.of(context).colorScheme.surface,
          secondaryColor: Theme.of(context).colorScheme.onBackground,
          onSwitched: (chainId) {
            _chainId = chainId;
          },
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: 200.0,
      height: 48.0,
      child: Builder(builder: (context) {
        return MainButton(
          text: "Verify",
          verticalPadding: 0.0,
          onClick: () {
            final text = _textController.text;
            if (text.isNotEmpty) {
              BlocProvider.of<VerificationBloc>(context)
                  .verifyNft(_chainId, text);
            }
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class VerifyingResult extends StatelessWidget {
  const VerifyingResult({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        if (state is VerifiedState) {
          return Column(
            children: [
              NftListItem(nft: state.nft),
              const SizedBox(height: 32.0),
              const Text("Owned by:"),
              const SizedBox(height: 12.0),
              SelectableText(
                state.owner,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12.0),
              Link(
                text: "Transaction on explorer",
                uri: Uri.parse(state.explorerUrl),
              ),
            ],
          );
        } else if (state is NonExistentNft) {
          return BlockingText(state.message);
        } else if (state is VerificationProcessState) {
          return const LoadingView();
        } else {
          return Container();
        }
      },
    );
  }
}
