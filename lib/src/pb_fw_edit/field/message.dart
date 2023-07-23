part of '../proto_edit_frp.dart';

extension _MessageFieldAccessX on MessageFieldAccess {
  PFN<Mfw, Widget> get editor {
    return (editor, input) {
      return flcDsp(
        (disposers) {
          final fld = fieldFw(input, disposers: disposers);
          return PKMessageEditor(
            messageType: valueType,
          ).call(
            editor,
            fld,
          );
        },
      );
    };
  }
}
