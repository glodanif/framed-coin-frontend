import 'package:flutter/material.dart';

class DialogBackground extends StatelessWidget {
  final Widget child;
  final double padding;
  final double width;

  const DialogBackground({
    Key? key,
    required this.child,
    this.padding = 24.0,
    this.width = 340.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(padding),
          width: width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(56, 107, 201, 0.15),
                offset: Offset(0, 8),
                blurRadius: 12,
              ),
              BoxShadow(
                color: Color.fromRGBO(56, 107, 201, 0.15),
                offset: Offset(0, -8),
                blurRadius: 12,
              ),
            ],
            color: Theme.of(context).colorScheme.background,
          ),
          child: child,
        ),
      ],
    );
  }
}
