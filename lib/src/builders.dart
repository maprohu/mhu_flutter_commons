import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'frp.dart';
import 'widgets.dart';
import 'future.dart';

Widget flcBusyDsp(
  Future<Widget> Function(DspReg disposers) builder,
) =>
    flcWaitingDsp(busyWidget, builder);

Widget flcWaitingDsp(
  Widget waiting,
  Future<Widget> Function(DspReg disposers) builder,
) {
  return flcAsyncDisposeWidget(
    waiting: waiting,
    builder: builder,
  );
}

Widget flcAsyncDisposeWidget({
  required Widget waiting,
  required Future<Widget> Function(DspReg disposers) builder,
}) {
  return flcDisposeWidget(
    builder: (disposers) {
      final widget = builder(disposers);
      return widget.withAwaitingWidget(waiting);
    },
  );
}

Widget flcBusy(
  Future<Widget> Function() builder,
) =>
    builder().withBusyWidget;
