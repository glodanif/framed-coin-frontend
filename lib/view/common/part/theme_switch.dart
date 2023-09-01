import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/main.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final currentTheme = ThemeProvider.themeOf(context).id;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              currentTheme == lightTheme ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          onPressed: () {
            ThemeProvider.controllerOf(context).nextTheme();
          },
        ),
      );
    });
  }
}
