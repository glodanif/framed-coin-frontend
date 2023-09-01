import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/common/part/narrow_container.dart';
import 'package:framed_coin_frontend/view/common/part/theme_switch.dart';
import 'package:go_router/go_router.dart';

class SidePageWrapper extends StatelessWidget {
  final Widget child;

  const SidePageWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72.0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            child: Text(
              "Framed Coin",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              context.pop();
            },
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          NarrowContainer(
            width: 824.0,
            scrollable: true,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: child,
            ),
          ),
          const ThemeSwitch(),
        ],
      ),
    );
  }
}
