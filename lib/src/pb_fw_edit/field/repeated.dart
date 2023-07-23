part of '../proto_edit_frp.dart';

extension _RepeatedFieldAccessX on RepeatedFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
    return listTile(
      editor: editor,
      input: input,
      subtitle: flcText(
            () {
          final count = get(input()).length;
          return '$count ${count == 1 ? 'item' : 'items'}';
        },
      ),
    );
  };
}

