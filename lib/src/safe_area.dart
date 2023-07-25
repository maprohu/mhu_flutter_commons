import 'package:flutter/material.dart';

class SafeScroll extends StatelessWidget {
  const SafeScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: child,
      ),
    );
  }
}

class SafeScrollColumn extends StatelessWidget {
  const SafeScrollColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeScroll(
      child: Column(
        children: children,
      ),
    );
  }
}
