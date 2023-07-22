part of '../proto_edit_frp.dart';

extension _NumericIntFieldAccessX on NumericIntFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
        );
      };
}

extension _Int64FieldAccessX on Int64FieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
        );
      };
}

extension _NumericDoubleFieldAccessX on NumericDoubleFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
        );
      };
}
