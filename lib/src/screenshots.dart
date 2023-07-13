import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/screenshots.dart';

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
