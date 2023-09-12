import 'dart:async';
import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'has.dart';
import 'layout.dart' as $lib;

part 'layout.g.has.dart';

part 'layout.g.dart';

part 'layout/assert.dart';

const flcDefaultPaddingSize = 4.0;
const flcDefaultPadding = EdgeInsets.all(flcDefaultPaddingSize);

@Has()
typedef Dimension = double;

extension LayoutWidgetX on Widget {
  Widget withPadding([double value = flcDefaultPaddingSize]) => Padding(
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
  List<Widget> withPadding([double padding = flcDefaultPaddingSize]) =>
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

// abstract class HasSize {
//   Size get size;
// }

extension HasSizeX on HasSize {
  @Deprecated("Use sizeWidth()")
  double get width => size.width;

  @Deprecated("Use sizeHeight()")
  double get height => size.height;
}

extension CommonSizeX on Size {
  Size withHeight(double height) => Size(width, height);

  Size withWidth(double width) => Size(width, height);

  Offset minus(Size other) => Offset(
        width - other.width,
        height - other.height,
      );

  bool assertEqual(Size other) => assertSizeRoughlyEqual(this, other);

  @Deprecated("use sizeAxisDimension()")
  double axis(Axis axis) => switch (axis) {
        Axis.horizontal => width,
        Axis.vertical => height,
      };
}

bool sizeRoughlyEqual(Size a, Size b) {
  return doubleEqualWithin3Decimals(a.width, b.width) &&
      doubleEqualWithin3Decimals(a.height, b.height);
}

bool assertSizeRoughlyEqual(Size a, Size b) {
  assert(sizeRoughlyEqual(a, b), (a, b).toString());
  return true;
}

extension MhuLayouAxisX on Axis {
  Axis get flip => flipAxis(this);
}

bool sizeIsNegative({
  @extHas required Size size,
}) {
  return size.width.isNegative || size.height.isNegative;
}

Size sizeNonNegative({
  @extHas required Size size,
}) {
  if (size.sizeIsNegative()) {
    return Size(
      max(0, size.width),
      max(0, size.height),
    );
  } else {
    return size;
  }
}

double sizeAxisDimension({
  @extHas required Size size,
  @extHas required Axis axis,
}) {
  return size.axis(axis);
}

double totalHasSizeAxis({
  @Ext() required Iterable<HasSize> sizes,
  @extHas required Axis axis,
}) {
  return sizes.sumByDouble(
    (e) => e.sizeAxisDimension(
      axis: axis,
    ),
  );
}

double totalSizeAxis({
  @Ext() required Iterable<Size> sizes,
  @extHas required Axis axis,
}) {
  return sizes.sumByDouble(
    (e) => e.sizeAxisDimension(
      axis: axis,
    ),
  );
}

double? axisWidth({
  required Axis axis,
  required double dimension,
}) {
  return switch (axis) {
    Axis.horizontal => dimension,
    Axis.vertical => null,
  };
}

double? axisHeight({
  required Axis axis,
  required double dimension,
}) {
  return switch (axis) {
    Axis.vertical => dimension,
    Axis.horizontal => null,
  };
}

SizedBox sizedBoxAxis({
  @extHas required Widget child,
  @extHas required Axis axis,
  required double dimension,
}) {
  return switch (axis) {
    Axis.horizontal => SizedBox(
        width: dimension,
        child: child,
      ),
    Axis.vertical => SizedBox(
        height: dimension,
        child: child,
      ),
  };
}

Size sizeWithAxisDimension({
  @extHas required Size size,
  @extHas required Axis axis,
  required double dimension,
}) {
  return switch (axis) {
    Axis.horizontal => size.withWidth(dimension),
    Axis.vertical => size.withHeight(dimension),
  };
}

Size sizeWithHeight({
  @extHas required Size size,
  required double height,
}) {
  return Size(
    size.width,
    height,
  );
}

Size sizeWithWidth({
  @extHas required Size size,
  required double width,
}) {
  return Size(
    width,
    size.height,
  );
}

double sizeHeight({
  @extHas required Size size,
}) {
  return size.height;
}

double sizeWidth({
  @extHas required Size size,
}) {
  return size.width;
}

@Compose()
abstract class OrientedBox implements HasSize, HasAxis {}

Axis crossAxis({
  @extHas required Axis axis,
}) {
  return axis.flip;
}

Dimension orientedMainDimension({
  @ext required OrientedBox orientedBox,
}) {
  return sizeAxisDimension(
    size: orientedBox.size,
    axis: orientedBox.axis,
  );
}
Dimension orientedCrossDimension({
  @ext required OrientedBox orientedBox,
}) {
  return sizeAxisDimension(
    size: orientedBox.size,
    axis: orientedBox.crossAxis(),
  );
}

OrientedBox orientedBoxWithSize({
  @extHas required Axis axis,
  @extHas required Size size,
}) {
  return ComposedOrientedBox(
    size: size,
    axis: axis,
  );
}

OrientedBox orientedBoxWithMainDimension({
  @ext required OrientedBox orientedBox,
  required Dimension dimension,
}) {
  return ComposedOrientedBox(
    axis: orientedBox.axis,
    size: orientedBox.size.sizeWithAxisDimension(
      axis: orientedBox.axis,
      dimension: dimension,
    ),
  );
}

OrientedBox orientedBoxWithCrossDimension({
  @ext required OrientedBox orientedBox,
  required Dimension dimension,
}) {
  return ComposedOrientedBox(
    axis: orientedBox.axis,
    size: orientedBox.size.sizeWithAxisDimension(
      axis: orientedBox.crossAxis(),
      dimension: dimension,
    ),
  );
}

Dimension edgeInsetsAxisDimension({
  @extHas required EdgeInsets edgeInsets,
  @extHas required Axis axis,
}) {
  return edgeInsets.collapsedSize.sizeAxisDimension(axis: axis);
}













