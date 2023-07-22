import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'frp.dart';

Iterable<Widget> flcColumnCountButtons({
  required Fw<int> columnCount,
}) {
  return [
    TextButton(
      onPressed: () {
        columnCount.update((v) => v + 1);
      },
      child: const Text('More Columns'),
    ),
    flcFrr(
          () => TextButton(
        onPressed: columnCount() > 1
            ? () {
          columnCount.update((v) => v - 1);
        }
            : null,
        child: const Text('Less Columns'),
      ),
    ),
  ];
}
