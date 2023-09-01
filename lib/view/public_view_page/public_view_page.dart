import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/common/part/blocking_text.dart';
import 'package:framed_coin_frontend/view/common/part/error_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/link.dart';
import 'package:framed_coin_frontend/view/common/part/loading_view.dart';
import 'package:framed_coin_frontend/view/common/part/nft_list_item.dart';
import 'package:framed_coin_frontend/view/common/part/side_page_wrapper.dart';
import 'package:framed_coin_frontend/view/public_view_page/bloc/public_view_bloc.dart';

class PublicViewPage extends StatelessWidget with ErrorDialog {
  final String chainId;
  final String tokenId;

  const PublicViewPage({
    required this.chainId,
    required this.tokenId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PublicViewBloc>()..loadNft(chainId, tokenId),
      child: BlocListener<PublicViewBloc, PublicViewState>(
        listenWhen: (previous, current) => current is ErrorState,
        listener: (context, state) {
          if (state is ErrorState) {
            showErrorDialog(context, state.error);
          }
        },
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SidePageWrapper(
      child: BlocBuilder<PublicViewBloc, PublicViewState>(
        builder: (context, state) {
          if (state is NftLoadedState) {
            return Column(
              children: [
                const SizedBox(
                  height: 36.0,
                ),
                Text(
                  "Framed Coin ${state.nft.idLabel} on ${state.chainName} is owned by:",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
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
                const SizedBox(height: 32.0),
                NftListItem(nft: state.nft),
              ],
            );
          } else if (state is NonExistentNft) {
            return BlockingText(state.message);
          } else if (state is UnsupportedChainState) {
            return BlockingText(
              "Framed Coin doesn't support a chain with ID:${state.chainId}",
            );
          } else if (state is LoadingNftState) {
            return const LoadingView();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
