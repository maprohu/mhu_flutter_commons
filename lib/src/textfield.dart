import 'package:flutter/cupertino.dart';

extension TextEditingControllerX on TextEditingController {
  void selectAll() => selection = TextSelection(
        baseOffset: 0,
        extentOffset: value.text.length,
      );
}
