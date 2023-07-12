import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

final _logger = Logger();

class BusyBuilder<T extends Object> extends StatelessWidget {
  static Widget defaultBusy(BuildContext context) => const BusyWidget();

  static Widget defaultError(BuildContext context, Object error) {
    _logger.e(error, error);
    return ErrorWidget(error);
  }

  final Future<T> future;
  final Widget Function(BuildContext context, T value) builder;
  final Widget Function(BuildContext context) busyBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;

  const BusyBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.busyBuilder = defaultBusy,
    this.errorBuilder = defaultError,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorBuilder(context, snapshot.error!);
        } else if (snapshot.hasData) {
          return builder(context, snapshot.requireData);
        } else {
          return busyBuilder(context);
        }
      },
    );
  }
}
