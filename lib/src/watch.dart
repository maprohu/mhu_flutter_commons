import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/src/widgets.dart';

import 'frp.dart';

Widget watchWidget(WatchValue<Widget> builder) {
  return flcDsp(
        (disposers) {
      final widgetFr = disposers.watching<Widget>(
            () {
          final widget = builder();
          return widget.withKey(widget);
        },
      );
      return flcStreamWidget(
        waiting: widgetFr.readValue(),
        stream: widgetFr.distinctValues(),
      );
    },
  );
}
