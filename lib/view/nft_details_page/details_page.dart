import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/common/part/blocking_message.dart';
import 'package:framed_coin_frontend/view/common/part/error_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/loading_view.dart';
import 'package:framed_coin_frontend/view/common/part/narrow_container.dart';
import 'package:framed_coin_frontend/view/common/part/nft_action_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/transaction_progress.dart';
import 'package:framed_coin_frontend/view/nft_details_page/bloc/details_bloc.dart';
import 'package:framed_coin_frontend/view/nft_details_page/details_content.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatelessWidget with ErrorDialog {
  final String tokenId;
  bool updateOnPop;

  DetailsPage({
    required this.tokenId,
    this.updateOnPop = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DetailsBloc>(param1: tokenId)..loadNftDetails(),
      child: BlocConsumer<DetailsBloc, DetailsState>(
        listenWhen: (previous, current) =>
            current is TransactionFailedState || current is ErrorState,
        listener: (context, state) async {
          if (state is TransactionFailedState) {
            await showErrorDialog(context, state.error);
          } else if (state is ErrorState) {
            await showErrorDialog(context, state.error);
          }
          BlocProvider.of<DetailsBloc>(context).loadNftDetails();
        },
        builder: (context, state) {
          if (state is NftLoadedState) {
            return NarrowContainer(
              width: 400.0,
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: DetailsContent(
                nft: state.nft,
                onBackPressed: () {
                  if (updateOnPop) {
                    context.go(
                      "/app?t=${DateTime.now().microsecondsSinceEpoch}",
                    );
                  } else {
                    context.pop();
                  }
                },
                onDownloadPressed: (fileName, boundaries) {
                  BlocProvider.of<DetailsBloc>(context).downloadNft(
                    state.nft.fileName,
                    boundaries.left,
                    boundaries.top,
                    boundaries.width,
                    boundaries.height,
                  );
                },
                onCashOutPressed: () async {
                  final result = await NftActionDialog.show(
                      context, state.nft, NftAction.cashOut);
                  if (result == true) {
                    BlocProvider.of<DetailsBloc>(context).cashOutNft();
                  }
                },
                onBurnPressed: () async {
                  final result = await NftActionDialog.show(
                      context, state.nft, NftAction.burn);
                  if (result == true) {
                    BlocProvider.of<DetailsBloc>(context).burnNft();
                  }
                },
              ),
            );
          } else if (state is CashOutTxState) {
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Open your NFT",
              completedMessage: "Your NFT was successfully cashed out",
              onClick: () {
                updateOnPop = true;
                BlocProvider.of<DetailsBloc>(context).loadNftDetails();
              },
            );
          } else if (state is BurnTxState) {
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Go to your NFTs",
              completedMessage: "Your NFT was successfully burnt",
              onClick: () {
                context.go(
                  "/app?t=${DateTime.now().microsecondsSinceEpoch}",
                );
              },
            );
          } else if (state is NftNotFoundState) {
            return BlockingMessage(
              state.error.message,
              buttonLabel: "Go to your NFTs",
              onPressed: () {
                context.pop();
              },
            );
          } else if (state is NftUnavailableState) {
            return BlockingMessage(
              "Unexpected error\n${state.error}",
              buttonLabel: "Go to your NFTs",
              onPressed: () {
                context.pop();
              },
            );
          } else if (state is StrangerViewState) {
            return BlockingMessage(
              "Only the NFT owner is allowed to view this page",
              buttonLabel: "Go to your NFTs",
              onPressed: () {
                context.pop();
              },
            );
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}
