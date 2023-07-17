import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

final _logger = Logger();

class DisposingWidget extends StatefulWidget {
  const DisposingWidget({Key? key, required this.builder}) : super(key: key);

  final Widget Function(DspReg disposers) builder;

  @override
  State<DisposingWidget> createState() => _DisposingWidgetState();
}

class _DisposingWidgetState extends State<DisposingWidget> {
  final disposers = DspImpl();

  late final Widget child;

  @override
  void initState() {
    super.initState();
    child = widget.builder(disposers);
  }

  @override
  void dispose() {
    disposers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

Widget flcDisposeWidget({
  required Widget Function(DspReg disposers) builder,
}) {
  return DisposingWidget(builder: builder);
}

Widget flcDsp(Widget Function(DspReg disposers) builder) =>
    flcDisposeWidget(builder: builder);

Widget flcFrr(Widget Function() builder) {
  return flcDsp(
    (disposers) {
      final widgetFr = disposers.fr<Widget>(builder);
      return flcStreamWidget(
        waiting: widgetFr.read(),
        stream: widgetFr.changes(),
      );
    },
  );
}

Widget flcStreamWidget<T>({
  required Widget waiting,
  required Stream<Widget> stream,
}) {
  return StreamBuilder(
    initialData: waiting,
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        _logger.e(
          snapshot.error,
          snapshot.error,
          snapshot.stackTrace,
        );
        return ErrorWidget(snapshot.error!);
      } else {
        return snapshot.requireData;
      }
    },
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

extension FrWigetX<T> on Fr<T> {
  Widget frWidget(Widget Function(T value) fn) {
    return flcFrr(
          () => fn(call()),
    );
  }

  Widget asKey(Widget Function(T key) fn) {
    return flcFrr(
          () {
        final key = call();
        return fn(key).withKey(key);
      },
    );
  }
}
