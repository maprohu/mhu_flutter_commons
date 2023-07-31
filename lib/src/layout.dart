import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mhu_dart_commons/commons.dart';

const paddingSize = 4.0;
const padding = EdgeInsets.all(paddingSize);

extension LayoutWidgetX on Widget {
  Widget withPadding([double value = paddingSize]) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget withPaddingOf(double size) => Padding(
        padding: EdgeInsets.all(size),
        child: this,
      );

  Widget centered() => Center(
        child: this,
      );

  Widget alignBottom() => Align(
        alignment: Alignment.bottomCenter,
        child: this,
      );
}

extension LayoutIterableWidgetX on Iterable<Widget> {
  List<Widget> withPadding([double padding = paddingSize]) =>
      map((e) => e.withPadding(padding)).toList();

  List<Widget> withPaddingOf(double size) =>
      map((e) => e.withPaddingOf(size)).toList();
}

class ScreenSizeObserver with WidgetsBindingObserver {
  final void Function(Size size) callback;

  ScreenSizeObserver(this.callback);

  @override
  void didChangeMetrics() {
    callback(getScreenSize());
  }

  static Size getScreenSize() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = view.physicalSize;
    final dpr = view.devicePixelRatio;
    return size / dpr;
  }

  static Stream<Size> stream(DspReg disposers) {
    final controller = StreamController<Size>();

    controller.add(getScreenSize());

    final observer = ScreenSizeObserver(controller.add);
    WidgetsBinding.instance.addObserver(observer);

    disposers.add(() async {
      WidgetsBinding.instance.removeObserver(observer);

      await controller.close();
    });

    return controller.stream;
  }
}

class StretchWidget extends StatelessWidget {
  final Widget child;

  const StretchWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.fill,
        child: child,
      ),
    );
  }
}
