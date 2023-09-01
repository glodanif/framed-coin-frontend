import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/back_arrow_button.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/nft_list_item.dart';
import 'package:framed_coin_frontend/view/common/part/share_dialog.dart';

class DetailsContent extends StatelessWidget {
  final NftViewModel nft;
  final Function onBackPressed;
  final Function(String, Rect) onDownloadPressed;
  final Function onCashOutPressed;
  final Function onBurnPressed;

  const DetailsContent({
    required this.nft,
    required this.onBackPressed,
    required this.onDownloadPressed,
    required this.onCashOutPressed,
    required this.onBurnPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    return Builder(builder: (context) {
      return Column(
        children: [
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackArrowButton(
                onPressed: () {
                  onBackPressed.call();
                },
              ),
              Expanded(child: Container()),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final isDownLoadRequested =
                      await ShareDialog.show(context, nft);
                  if (isDownLoadRequested == true) {
                    //FIXME: dirty workaround for html2canvas
                    await Future.delayed(const Duration(seconds: 1));
                    final boundaries =
                        await (globalKey.currentWidget as NftListItem)
                            .getBoundaries();
                    onDownloadPressed(nft.fileName, boundaries);
                  }
                },
                icon: Icon(
                  Icons.share,
                  size: 36.0,
                  color: onBackgroundColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          RepaintBoundary(
            child: NftListItem(key: globalKey, nft: nft),
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MainButton(
                    text: "Cash Out",
                    isEnabled: !nft.isCashedOut,
                    onClick: () {
                      onCashOutPressed.call();
                    }),
              ),
              Expanded(
                child: MainButton(
                    text: "Burn",
                    isEnabled: nft.isCashedOut,
                    onClick: () {
                      onBurnPressed.call();
                    }),
              ),
            ],
          ),
        ],
      );
    });
  }
}
