import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    errorMethodCount: 20,
  ),
);

typedef SnapshotErrorHandler = Widget
    Function(BuildContext context, Object error, [StackTrace? stackTrace]);

Widget snapshotDefaultBusy(BuildContext context) => busyWidget;

Widget snapshotDefaultError(BuildContext context, Object error,
    [StackTrace? stackTrace]) {
  _logger.e(error, error, stackTrace);
  return ErrorWidget(error);
}

AsyncWidgetBuilder<T> snapshotBuilder<T>({
  required Widget Function(BuildContext context, T value) builder,
  Widget Function(BuildContext context) busy = snapshotDefaultBusy,
  SnapshotErrorHandler error = snapshotDefaultError,
}) =>
    (context, snapshot) {
      if (snapshot.hasError) {
        return error(context, snapshot.error!, snapshot.stackTrace!);
      } else if (snapshot.hasData) {
        return builder(context, snapshot.requireData);
      } else {
        return busy(context);
      }
    };

Widget futureBuilderNull<T extends Object>({
  required Future<T> future,
  required Widget Function(BuildContext context, T value) builder,
  SnapshotErrorHandler error = snapshotDefaultError,
}) =>
    futureBuilder(
      future: future,
      builder: builder,
      error: error,
      busy: (context) => nullWidget,
    );

Widget futureBuilder<T extends Object>({
  required Future<T> future,
  required Widget Function(BuildContext context, T value) builder,
  Widget Function(BuildContext context) busy = snapshotDefaultBusy,
  SnapshotErrorHandler error = snapshotDefaultError,
}) =>
    FutureBuilder<T>(
      future: future,
      builder: snapshotBuilder(
        builder: builder,
        busy: busy,
        error: error,
      ),
    );

extension MhuWidgetFutureWidgetX on Future<Widget> {
  Widget withAwaitingWidget(Widget awaitingWidget) => futureBuilder(
        future: this,
        builder: (context, value) => value,
        busy: (context) => awaitingWidget,
      );

  Widget get withBusyWidget => withAwaitingWidget(busyWidget);

  Widget get withNullWidget => withAwaitingWidget(nullWidget);
}

extension TextWidgetFutureStringX on Future<String> {
  Widget futureText([String waiting = '']) => futureBuilder(
        future: this,
        builder: (context, value) => value.txt,
        busy: (context) => waiting.txt,
      );
}
