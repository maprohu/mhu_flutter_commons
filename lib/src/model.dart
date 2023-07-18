import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';

extension ModelSizeX on Size {
  CmnDimensionsMsg get toCmnDimensionMsg => CmnDimensionsMsg(
        width: width.toInt(),
        height: height.toInt(),
      );

  Size get portrait => width > height ? flipped : this;
  Size get landscape => height > width ? flipped : this;
}

extension CmnColorThemeMsgX on CmnColorThemeMsg {
  Color get color => Color(seedColor).withOpacity(1);

  // ColorScheme get colorScheme => ColorScheme.fromSeed(
  //       seedColor: color,
  //       brightness: darkTheme ? Brightness.dark : Brightness.light,
  //     );

  ColorScheme get lightScheme => ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
      );

  ColorScheme get darkScheme => ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.dark,
      );

  // ThemeData get themeData {
  //   final scheme = colorScheme;
  //   return ThemeData(
  //     colorScheme: scheme,
  //     scaffoldBackgroundColor: scheme.background,
  //   );
  // }

  ThemeData get lightThemeData => ThemeData(
        colorScheme: lightScheme,
      );

  ThemeData get darkThemeData => ThemeData(
        colorScheme: darkScheme,
      );
}

final defaultCmnColorThemeMsg = CmnColorThemeMsg(
  seedColor: Colors.blue.value,
)..freeze();

extension CmnThemeModeEnmX on CmnThemeModeEnm {
  ThemeMode get toThemeMode => ThemeMode.values[value];
}

extension CmnOffsetX on Offset {
  CmnPointMsg get toCmnPointMsg => CmnPointMsg(
        x: dx.toInt(),
        y: dy.toInt(),
      )..freeze();
}

extension GeometryRectX on Rect {
  CmnBoundingBoxMsg get toCmnBoundingBoxMsg => CmnBoundingBoxMsg(
        origin: topLeft.toCmnPointMsg,
        size: size.toCmnDimensionMsg,
      );
}

extension DartMathPointX<T extends num> on Point<T> {
  CmnPointMsg get toCmnPointMsg => CmnPointMsg(
        x: x.toInt(),
        y: y.toInt(),
      )..freeze();
}
