import 'package:flutter/material.dart';

class NarrowContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final EdgeInsets padding;
  final bool scrollable;

  const NarrowContainer({
    required this.child,
    this.width = 512.0,
    this.padding = EdgeInsets.zero,
    this.scrollable = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: scrollable
          ? _buildScrollContainer(_buildContainer())
          : _buildContainer(),
    );
  }

  Widget _buildContainer() {
    return Center(
      child: Padding(
        padding: padding,
        child: SizedBox(width: width, child: child),
      ),
    );
  }

  Widget _buildScrollContainer(Widget child) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(children: [SizedBox(width: width, child: child)]),
      ),
    );
  }
}
