import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackArrowButton extends StatelessWidget {
  final Function()? onPressed;

  const BackArrowButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (onPressed == null) {
          context.pop();
        } else {
          onPressed?.call();
        }
      },
      icon: Icon(
        Icons.arrow_back_rounded,
        size: 36.0,
        color: color,
      ),
    );
  }
}
