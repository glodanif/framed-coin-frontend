import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/common/part/blocking_text.dart';
import 'package:framed_coin_frontend/view/common/part/error_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/loading_view.dart';
import 'package:framed_coin_frontend/view/common/part/narrow_container.dart';
import 'package:framed_coin_frontend/view/common/part/transaction_progress.dart';
import 'package:framed_coin_frontend/view/nft_minting_page/bloc/minting_bloc.dart';
import 'package:framed_coin_frontend/view/nft_minting_page/minting_form_view.dart';
import 'package:go_router/go_router.dart';

class MintingPage extends StatelessWidget with ErrorDialog {
  const MintingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MintingBloc>()..loadMintingSettings(),
      child: BlocConsumer<MintingBloc, MintingState>(
        listenWhen: (previous, current) =>
            current is TransactionFailedState ||
            current is MintingSettingsUnavailableState,
        listener: (context, state) async {
          if (state is TransactionFailedState) {
            await showErrorDialog(context, state.error);
            BlocProvider.of<MintingBloc>(context).loadMintingSettings();
          } else if (state is MintingSettingsUnavailableState) {
            await showErrorDialog(context, state.error);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is MintingSettingsState) {
            return NarrowContainer(
              scrollable: true,
              padding: const EdgeInsets.all(24.0),
              child: MintingFormView(
                settings: state.mintingSettings,
                chainInfo: state.chainInfo,
                onMintPressed: (value) {
                  BlocProvider.of<MintingBloc>(context).mintNft(value);
                },
              ),
            );
          } else if (state is TxState) {
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Open your new NFT",
              completedMessage:
                  "Your NFT successfully minted with unique token id #${state.tx.result}",
              onClick: () {
                context.go("/app/${state.tx.result}?update=1");
              },
            );
          } else if (state is PausedState) {
            return const BlockingText(
              "Minting is temporary disabled, please try again later...",
            );
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}
