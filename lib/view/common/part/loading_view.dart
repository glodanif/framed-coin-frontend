import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      size: 48.0,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }
}
