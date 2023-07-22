import 'package:flutter/material.dart';

class TickerWidget extends StatefulWidget {
  const TickerWidget({Key? key, required this.builder}) : super(key: key);

  final Widget Function(TickerProvider ticker) builder;

  @override
  State<TickerWidget> createState() => _TickerWidgetState();
}

class _TickerWidgetState extends State<TickerWidget>
    with TickerProviderStateMixin<TickerWidget> {
  late final _child = widget.builder(this);

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

Widget flcTicker(Widget Function(TickerProvider tickers) build) {
  return TickerWidget(builder: build);
}
