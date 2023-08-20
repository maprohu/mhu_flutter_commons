import 'package:flutter/material.dart';

typedef AnimateBuilder = Widget Function(double t);

Widget flcAnimate({
  required AnimateBuilder builder,
  Curve curve = _Animate.defaultCurve,
  Duration duration = _Animate.defaultDuration,
}) {
  return _Animate(
    builder: builder,
    curve: curve,
    duration: duration,
  );
}

class _Animate extends StatefulWidget {
  final Curve curve;
  final Duration duration;

  const _Animate({
    required this.builder,
    required this.curve,
    required this.duration,
  });

  static const defaultCurve = Curves.easeOut;
  static const defaultDuration = Duration(
    milliseconds: 200,
  );

  final Widget Function(double animation) builder;

  @override
  State<_Animate> createState() => _AnimateState();
}

class _AnimateState extends State<_Animate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: widget.duration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return widget.builder(_animation.value);
      },
    );
  }
}
