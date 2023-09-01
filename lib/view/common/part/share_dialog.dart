import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/dialog_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareDialog {
  static Future<bool?> show(
    BuildContext context,
    NftViewModel nft,
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
          content: ShareDialogLayout(nft: nft),
        );
      },
    );
  }
}

class ShareDialogLayout extends StatefulWidget {
  final NftViewModel nft;

  const ShareDialogLayout({required this.nft, super.key});

  @override
  State<ShareDialogLayout> createState() => _ShareDialogLayoutState();
}

class _ShareDialogLayoutState extends State<ShareDialogLayout> {
  var isCopied = false;

  @override
  Widget build(BuildContext context) {
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    return DialogBackground(
      width: 512.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Share"),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 32.0,
                    color: onBackgroundColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: SelectableText(
                      widget.nft.shareUrl,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: isCopied
                        ? null
                        : () async {
                            await Clipboard.setData(
                              ClipboardData(text: widget.nft.shareUrl),
                            );
                            setState(() {
                              isCopied = true;
                            });
                          },
                    icon: isCopied
                        ? const Icon(
                            Icons.check,
                            size: 32.0,
                            color: Colors.greenAccent,
                          )
                        : Icon(
                            Icons.copy,
                            size: 32.0,
                            color: onBackgroundColor,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  icon: FaIcon(FontAwesomeIcons.download,
                      size: 36.0, color: onBackgroundColor),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final encodedText =
                        Uri.encodeComponent("My ${widget.nft.fileName}");
                    final encodedUrl = Uri.encodeComponent(widget.nft.shareUrl);
                    final uri = Uri.parse(
                        "https://twitter.com/intent/tweet?text=$encodedText&url=$encodedUrl&hashtags=framed_coin");
                    launchUrl(uri);
                  },
                  icon: FaIcon(FontAwesomeIcons.twitter,
                      size: 36.0, color: onBackgroundColor),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final encodedUrl = Uri.encodeComponent(widget.nft.shareUrl);
                    final hashtag = Uri.encodeComponent("#framed_coin");
                    final uri = Uri.parse(
                        "https://www.facebook.com/dialog/share?app_id=4253249168234316&href=$encodedUrl&display=popup&hashtag=$hashtag");
                    launchUrl(uri);
                  },
                  icon: FaIcon(FontAwesomeIcons.facebook,
                      size: 36.0, color: onBackgroundColor),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final encodedText = Uri.encodeComponent(
                        "My ${widget.nft.fileName} ${widget.nft.shareUrl}");
                    final uri = Uri.parse(
                        "https://api.whatsapp.com/send/?text=$encodedText&type=custom_url&app_absent=0");
                    launchUrl(uri);
                  },
                  icon: FaIcon(FontAwesomeIcons.whatsapp,
                      size: 36.0, color: onBackgroundColor),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
