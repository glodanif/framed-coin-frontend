import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/dialog_background.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/nft_details_page/miniature_nft.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class InstallMetamaskDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          elevation: 0.0,
          contentPadding: EdgeInsets.all(16.0),
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.0),
          content: InstallMetamaskDialog(),
        );
      },
    );
  }

  const InstallMetamaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const DialogBackground(
      width: 550.0,
      child: MetamaskMissingPrompt(),
    );
  }
}

class MetamaskMissingPrompt extends StatelessWidget {
  const MetamaskMissingPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Metamask missing"),
        const SizedBox(height: 36.0),
        SvgPicture.asset("assets/ic_metamask.svg", width: 72.0, height: 72.0),
        const SizedBox(height: 36.0),
        Text(
          "In order to connect to blockchain you need Metamask browser extension installed.\n\nOther providers may get available later...",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 48.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainButton(
              text: "Cancel",
              onClick: () {
                Navigator.of(context).pop(false);
              },
            ),
            const SizedBox(width: 12.0),
            MainButton(
              text: "Install",
              onClick: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
