import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarBrandTitle extends StatelessWidget {
  const AppBarBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Text(
          "Framed Coin",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onTap: () {
          final route = GoRouterState.of(context).location;
          if (route != "/app" && !route.startsWith("/app?")) {
            context.go("/app?t=${DateTime.now().microsecondsSinceEpoch}");
          }
        },
      ),
    );
  }
}
