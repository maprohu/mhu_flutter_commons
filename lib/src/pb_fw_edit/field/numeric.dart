part of '../proto_edit_frp.dart';

extension _NumericIntFieldAccessX on NumericIntFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input())?.toString() ?? '<not set>',
          ),
          onTap: () {
            ValidatingTextField.showIntDialog(
              ui: editor.ui,
              title: fieldTitle(editor, input),
              initialValue: get(input.read()).toString(),
              onSubmit: setFwFor(input),
            );
          },
        );
      };
}

extension _Int64FieldAccessX on Int64FieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input())?.toString() ?? '<not set>',
          ),
          onTap: () {
            ValidatingTextField.showInt64Dialog(
              ui: editor.ui,
              title: fieldTitle(editor, input),
              initialValue: get(input.read()).toString(),
              onSubmit: setFwFor(input),
            );
          },
        );
      };
}

extension _NumericDoubleFieldAccessX on NumericDoubleFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input())?.toString() ?? '<not set>',
          ),
          onTap: () {
            ValidatingTextField.showDoubleDialog(
              ui: editor.ui,
              title: fieldTitle(editor, input),
              initialValue: get(input.read()).toString(),
              onSubmit: setFwFor(input),
            );
          },
        );
      };
}
