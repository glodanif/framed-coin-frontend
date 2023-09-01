import 'package:flutter/material.dart';

class ColumnDivider extends StatelessWidget {
  const ColumnDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: VerticalDivider(
        thickness: 2.0,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
