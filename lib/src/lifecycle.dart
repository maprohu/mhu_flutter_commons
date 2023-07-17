import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

Fr<AppLifecycleState?> appLifecycleStateFr(DspReg disposers) {
  final fwDsp = DspImpl();
  final result = fw(
    WidgetsBinding.instance.lifecycleState,
    disposers: fwDsp,
  );

  final streamDsp = DspImpl();
  appLifecycleStateChanges(disposers: streamDsp)
      .forEach(result.set)
      .awaitBy(streamDsp);

  disposers.add(() async {
    await streamDsp.dispose();
    await fwDsp.dispose();
  });

  return result;
}

final appLifecycleStateSingleton = appLifecycleStateFr(DspImpl());

Stream<AppLifecycleState> appLifecycleStateChanges({
  required DspReg disposers,
}) {
  final controller = StreamController<AppLifecycleState>.broadcast();
  final observer = ChangeAppLifecycleStateObserver(
    controller.add,
  );
  WidgetsBinding.instance.addObserver(observer);
  disposers.add(() async {
    WidgetsBinding.instance.removeObserver(observer);
    await controller.close();
  });
  return controller.stream;
}

Stream<void> appLifecycleResumeEvents({
  required DspReg disposers,
}) =>
    appLifecycleStateChanges(disposers: disposers)
        .where((event) => event == AppLifecycleState.resumed);

class ChangeAppLifecycleStateObserver extends WidgetsBindingObserver {
  final Function(AppLifecycleState state) callback;

  ChangeAppLifecycleStateObserver(this.callback);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => callback(state);
}
