part of '../proto_edit_frp.dart';

extension _EnumFieldAccessX on EnumFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input())?.name.titleCase ?? '<not set>',
          ),
        );
      };
}
