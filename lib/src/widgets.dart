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
