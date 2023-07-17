import 'package:flutter/services.dart';

extension DeviceOrientationX on DeviceOrientation {
  bool get isLandscape =>
      this == DeviceOrientation.landscapeLeft ||
          this == DeviceOrientation.landscapeRight;
}
