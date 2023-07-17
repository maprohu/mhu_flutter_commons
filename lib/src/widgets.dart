import 'package:flutter/material.dart';

const nullWidget = NullWidget.instance;

class NullWidget extends StatelessWidget {
  static const instance = NullWidget();

  const NullWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

const busyWidget = BusyWidget.instance;

class BusyWidget extends StatelessWidget {
  static const instance = BusyWidget();

  const BusyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

extension FlutterStringX on String {
  Text get txt => Text(this);
}

typedef ValueBuilder<T> = Widget Function(BuildContext context, T value);

class WidgetWithKey extends StatelessWidget {
  final Widget child;

  WidgetWithKey(dynamic key, this.child) : super(key: ValueKey(key));

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

extension MhuWidgetX on Widget {
  Widget withKey(dynamic key) => WidgetWithKey(key, this);

  Widget roundBorder([double radius = 8]) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );

  Widget overlay() => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: this,
        ),
      );
}
