import 'package:flutter/cupertino.dart';

extension MhuIconWidgetX on Widget {
  Widget withIconThemeOf(BuildContext context) => IconTheme(
        data: IconTheme.of(context),
        child: this,
      );
}
