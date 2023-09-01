import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';

class BlockingMessage extends StatelessWidget {
  final String text;
  final String buttonLabel;
  final Function onPressed;

  const BlockingMessage(
    this.text, {
    required this.buttonLabel,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48.0),
            MainButton(
              text: buttonLabel,
              onClick: () {
                onPressed.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
