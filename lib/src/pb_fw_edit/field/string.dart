part of '../proto_edit_frp.dart';

extension _StringFieldAccessX on StringFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input()) ?? '<not set>',
          ),
        );
      };
}
