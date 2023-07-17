import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'frp.dart';

extension ValueListenableX<T> on ValueListenable<T> {
  Fr<T> fr(DspReg disposers) {
    final frw = disposers.fw(value);

    void listen() {
      frw.value = value;
    }

    addListener(listen);
    disposers.add(() => removeListener(listen));

    return frw;
  }

  Widget valueBuilder(Widget Function(T value) builder) {
    return flcDsp((disposers) {
      final fv = fr(disposers);
      return flcFrr(
            () => builder(fv()),
      );
    });
  }
}