part of '../proto_edit_frp.dart';

extension _StringFieldAccessX on StringFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input()) ?? '<not set>',
          ),
          onTap: () {
            ValidatingTextField.showDialog(
              ui: editor.ui,
              title: fieldTitle(editor, input),
              initialValue: get(input.read()),
              onSubmit: setFwFor(input),
              validator: empty1,
              textProcessor: identity,
            );
          },
        );
      };
}
