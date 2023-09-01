import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onClick;
  final String text;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool isEnabled;
  final double verticalPadding;

  const MainButton({
    Key? key,
    this.onClick,
    this.text = '',
    this.color,
    this.textColor,
    this.isLoading = false,
    this.isEnabled = true,
    this.verticalPadding = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isEnabled
        ? (color ?? Theme.of(context).colorScheme.secondary)
        : Colors.blueGrey;
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: textColor ?? const Color(0XFFF1F6F9));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton(
        onPressed: isEnabled
            ? () {
                onClick?.call();
              }
            : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: 28.0)),
          overlayColor: MaterialStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.surface),
        ),
        child: Wrap(
          children: [
            isLoading
                ? SpinKitWave(
                    size: 24.0, color: textColor ?? const Color(0XFFF1F6F9))
                : Text(text, textAlign: TextAlign.center, style: textStyle),
          ],
        ),
      ),
    );
  }
}
