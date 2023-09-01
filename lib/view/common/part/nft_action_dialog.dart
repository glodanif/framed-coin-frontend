import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/dialog_background.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/nft_details_page/miniature_nft.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

enum NftAction {
  cashOut,
  burn;
}

class NftActionDialog extends StatelessWidget {

  static Future<bool?> show(
      BuildContext context,
      NftViewModel nft,
      NftAction action,
      ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0.0,
          contentPadding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10.0),
          content: NftActionDialog(nft: nft, action: action),
        );
      },
    );
  }

  final NftViewModel nft;
  final NftAction action;

  const NftActionDialog({
    required this.nft,
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DialogBackground(
      width: 550.0,
      child: SizedBox(
        height: 470.0,
        child: SingleChildScrollView(
          child: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)
              ? _buildBody(context)
              : _buildMobileBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(),
        const SizedBox(height: 22.0),
        _buildExplanation(context),
        const SizedBox(height: 36.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPreNft(),
            _buildArrow(),
            _buildPostNft(),
          ],
        ),
        const SizedBox(height: 48.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCancelButton(context),
            const SizedBox(width: 22.0),
            _buildProceedButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(),
        const SizedBox(height: 22.0),
        _buildExplanation(context),
        const SizedBox(height: 36.0),
        _buildPreNft(),
        _buildArrow(lookDown: true),
        _buildPostNft(),
        const SizedBox(height: 48.0),
        _buildProceedButton(context),
        const SizedBox(height: 22.0),
        _buildCancelButton(context),
      ],
    );
  }

  Widget _buildPreNft() {
    return action == NftAction.cashOut
        ? MiniatureNft(
            id: nft.id,
            isCashedOut: false,
            gradientColors: nft.gradientColors,
          )
        : MiniatureNft(
            id: nft.id,
            isCashedOut: true,
            gradientColors: nft.greyGradientColors,
          );
  }

  Widget _buildPostNft() {
    return action == NftAction.cashOut
        ? MiniatureNft(
            id: nft.id,
            isCashedOut: true,
            gradientColors: nft.greyGradientColors,
          )
        : PhysicalModel(
            elevation: 4,
            color: Colors.grey,
            child: Container(
              width: 200.0,
              height: 200.0,
              decoration: const BoxDecoration(color: Colors.white70),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "404",
                    style: GoogleFonts.righteous(
                      textStyle: const TextStyle(
                        fontSize: 30.0,
                        color: Color(0XFF111111),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Not found",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0XFF111111),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildTitle() {
    return Text(action == NftAction.cashOut ? "Cashing out" : "Burning");
  }

  Widget _buildExplanation(BuildContext context) {
    return Text(
        action == NftAction.cashOut
            ? "This action will result in transferring your ${nft.value} ${nft.tokenName} from Framed Coin NFT ${nft.idLabel} to your account, and your NFT changing its appearance. Are you sure you want to proceed?"
            : "This action will result in erasing your Framed Coin NFT ${nft.idLabel} from existence, so it will be completely unavailable. This action is irreversible. Are you sure you want to proceed?",
        style: Theme.of(context).textTheme.bodyMedium);
  }

  Widget _buildProceedButton(BuildContext context) {
    return MainButton(
      text: action == NftAction.cashOut ? "Cash out" : "Burn",
      onClick: () {
        Navigator.of(context).pop(true);
      },
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return MainButton(
      text: 'Cancel',
      onClick: () {
        Navigator.of(context).pop(false);
      },
    );
  }

  Widget _buildArrow({bool lookDown = false}) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Icon(
        lookDown ? Icons.arrow_downward_rounded : Icons.arrow_forward_rounded,
        size: 48.0,
      ),
    );
  }
}
