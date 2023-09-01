import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/blocking_text.dart';
import 'package:framed_coin_frontend/view/common/part/loading_view.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/narrow_container.dart';
import 'package:framed_coin_frontend/view/common/part/nft_list_item.dart';
import 'package:framed_coin_frontend/view/common/part/row_divider.dart';
import 'package:framed_coin_frontend/view/nfts_list_page/bloc/nft_list_bloc.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_grid.dart';

class NftListPage extends StatefulWidget {
  const NftListPage({super.key});

  @override
  State<NftListPage> createState() => _NftListPageState();
}

class _NftListPageState extends State<NftListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NftListBloc>()..loadOwnerNfts(),
      child: BlocBuilder<NftListBloc, NftListState>(
        builder: (context, state) {
          if (state is ReceivedOwnerNftsState) {
            return _buildMyNfts(context, state.nfts);
          } else if (state is ErrorState) {
            return BlockingText(state.error.message);
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }

  Widget _buildMyNfts(BuildContext context, List<NftViewModel> ownerNfts) {
    final scaledPadding =
        ResponsiveBreakpoints.of(context).smallerOrEqualTo('TINY')
            ? 16.0
            : 36.0;
    return NarrowContainer(
      width: 1300.0,
      child: Padding(
        padding: EdgeInsets.all(scaledPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "My NFTs",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Builder(builder: (context) {
                  return MainButton(
                    text: "Mint",
                    onClick: () {
                      context.go('/app/mint');
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 8.0),
            const RowDivider(),
            const SizedBox(height: 32.0),
            ownerNfts.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        "You don't have any NFTs on this chain yet, mint one!",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                : Expanded(child: _buildGrid(ownerNfts)),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<NftViewModel> ownerNfts) {
    final scaledEdge = 400.0 *
        (ResponsiveBreakpoints.of(context).smallerOrEqualTo('TINY') ? 0.82 : 1);
    return SingleChildScrollView(
      child: ResponsiveGridView.builder(
        alignment: Alignment.center,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ownerNfts.length,
        gridDelegate: ResponsiveGridDelegate(
          crossAxisExtent: scaledEdge,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: AbsorbPointer(
                    child: NftListItem(nft: ownerNfts[index]),
                  ),
                  onTap: () {
                    context.go("/app/${ownerNfts[index].id}");
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
