import 'package:flutter/material.dart';

class RowDivider extends StatelessWidget {
  const RowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 2.0,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }
}
