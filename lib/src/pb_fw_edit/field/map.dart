part of '../proto_edit_frp.dart';

extension _MapFieldAccessX on MapFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
    return listTile(
      editor: editor,
      input: input,
    );
  };
}

