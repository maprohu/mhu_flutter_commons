import 'package:flutter/material.dart';
import 'stream.dart' as lib;

import 'future.dart';
import 'widgets.dart';

Widget streamBuilder<T>({
  required Stream<T> stream,
  required Widget Function(BuildContext context, T value) builder,
  T? initial,
  Widget Function(BuildContext context) busy = snapshotDefaultBusy,
  Widget Function(BuildContext context, Object error) error =
      snapshotDefaultError,
}) =>
    StreamBuilder<T>(
      stream: stream,
      initialData: initial,
      builder: snapshotBuilder(
        builder: builder,
        busy: busy,
        error: error,
      ),
    );

extension MhuFlutterStreamX<T> on Stream<T> {
  Widget streamBuilder(
    ValueBuilder<T> builder, {
    T? initial,
    Widget Function(BuildContext context) busy = snapshotDefaultBusy,
    Widget Function(BuildContext context, Object error) error =
        snapshotDefaultError,
  }) =>
      lib.streamBuilder(
        stream: this,
        builder: builder,
        initial: initial,
        busy: busy,
        error: error,
      );
}
