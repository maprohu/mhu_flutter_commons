part of '../proto_edit_frp.dart';


extension _MessageFieldAccessX on MessageFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
    return listTile(
      editor: editor,
      input: input,
    );
  };
}

