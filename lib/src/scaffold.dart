import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'frp.dart';

part 'scaffold.freezed.dart';

typedef ScaffoldBuilder = Widget Function(ScaffoldParts parts);

const flcEmptyScaffoldParts = ScaffoldParts();

const flcLoadingScaffoldParts = ScaffoldParts(
  body: busyWidget,
);

@freezed
class ScaffoldParts with _$ScaffoldParts {
  const factory ScaffoldParts({
    Widget? title,
    List<Widget>? actions,
    Widget? drawer,
    Widget? body,
    Widget? bottomNavigatorBar,
  }) = _ScaffoldParts;
}

extension ScaffoldPartsX on ScaffoldParts {
  Widget center(List<Widget> children) => copyWith(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ).scaffold;

  Scaffold get scaffold {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: actions,
      ),
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigatorBar,
    );
  }

  ScaffoldParts overrideWith(ScaffoldParts other) => ScaffoldParts(
        title: other.title ?? title,
        actions: other.actions ?? actions,
        drawer: other.drawer ?? drawer,
        body: other.body ?? body,
      );

  ScaffoldBuilder get builder => (parts) => overrideWith(parts).scaffold;

  Widget get loading => copyWith(
        // actions: null,
        body: busyWidget,
      ).scaffold;

  Widget dspAsync(Future<Widget> Function(DspReg disposers) builder) {
    return flcDsp((disposers) {
      return builder(disposers).withAwaitingWidget(loading);
    });
  }

  Widget async(Future<Widget> Function() builder) {
    return builder().withAwaitingWidget(loading);
  }

  Widget withBody(Widget body) => copyWith(body: body).scaffold;

}

Scaffold flcScaffoldLoading(String title) => Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: busyWidget,
    );

Widget flcScaffold({
  required String title,
  required ScaffoldParts parts,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      actions: parts.actions,
    ),
    body: parts.body,
  );
}

extension AppConfigX on AppConfig {
  ScaffoldParts get scaffold => ScaffoldParts(
        title: Text(title),
      );
}
