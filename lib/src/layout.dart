import 'package:flutter/cupertino.dart';

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
  List<Widget> withPadding([double padding = paddingSize]) => map((e) => e.withPadding(padding)).toList();

  List<Widget> withPaddingOf(double size) =>
      map((e) => e.withPaddingOf(size)).toList();
}
