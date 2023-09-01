import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends StatelessWidget {
  final String text;
  final Uri uri;
  final TextStyle? style;

  const Link({
    required this.text,
    required this.uri,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(fontSize: 18.0),
    );
    final linkStyle =
        (style ?? defaultStyle).copyWith(color: const Color(0XFF376abd));
    return SelectableText.rich(
      TextSpan(
        text: text,
        style: linkStyle,
        mouseCursor: SystemMouseCursors.click,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrl(uri);
          },
      ),
    );
  }
}
