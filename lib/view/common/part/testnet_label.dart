import 'package:flutter/material.dart';

class TestnetLabel extends StatelessWidget {
  const TestnetLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      color: Colors.lightBlue,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        child: Text(
          'Testnet',
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
    );
  }
}
