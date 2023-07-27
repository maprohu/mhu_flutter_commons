import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/screenshots.dart';

import 'app.dart';
import 'frp.dart';

class ScreenshotsApp extends StatelessWidget {
  final void Function(BuildContext context) screenshots;

  const ScreenshotsApp({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenshotsWidget(
        screenshots: screenshots,
      ),
    );
  }
}

class ScreenshotsWidget extends StatefulWidget {
  final void Function(BuildContext context) screenshots;

  const ScreenshotsWidget({
    super.key,
    required this.screenshots,
  });

  @override
  State<ScreenshotsWidget> createState() => _ScreenshotsWidgetState();
}

class _ScreenshotsWidgetState extends State<ScreenshotsWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.screenshots(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(ScreenshotsFlutter.remote),
      ),
    );
  }
}

Future<void> runScreenshotsApp(
  Future<void> Function(
    void Function(Widget widget) home,
    FlcUi ui,
    Future<void> Function(String name) shoot,
  ) screenshots,
) async {
  final ui = FlcUi.create();

  final home = fw<Widget>(Placeholder());

  home.value = ScreenshotsWidget(
    screenshots: (context) async {
      final control = await ScreenshotsFlutter.tryCreate();

      await screenshots(
        home.set,
        ui,
        control?.take ?? (_) async {},
      );

      control?.shutdown();
    },
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: ui.nav,
      home: flcFrr(() => home()),
    ),
  );
}
