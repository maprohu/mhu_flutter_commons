part of '../proto_edit_frp.dart';

extension _StringFieldAccessX on StringFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input()) ?? '<not set>',
          ),
          onTap: PKFieldOnTap(fieldKey: fieldKey).call(editor, input),
        );
      };

  PFN<Mfw, VoidCallback?> get fieldOnTap => (editor, input) {
        return () {
          ValidatingTextField.showDialog(
            ui: editor.ui,
            title: fieldTitle(editor, input),
            initialValue: get(input.read()),
            onSubmit: setFwFor(input),
            watchValidate: empty1,
            textProcessor: identity,
          );
        };
      };

  PFN<PICollectionItem, FutureOr<void>> get collectionItemEditor =>
      (editor, input) {
        ValidatingTextField.showDialog(
          ui: editor.ui,
          title: "Edit Item: ${input.key.value}".txt,
          initialValue: input.itemFw.read(),
          onSubmit: input.itemFw.set,
          watchValidate: empty1,
          textProcessor: identity,
        );
      };

  PFN<PICollectionItem, Widget?> get collectionItemSubtitle =>
      (editor, input) => flcText(() => input.itemFw());

  PFN<PICreateCollectionItem, FutureOr<Object?>> get createCollectionItem {
    return (editor, input) async {
      String? result;
      await ValidatingTextField.showDialog(
        ui: editor.ui,
        title: "Value for item: ${input.key.value}".txt,
        initialValue: '',
        onSubmit: (value) => result = value,
        watchValidate: empty1,
        textProcessor: identity,
      );
      return result?.also(input.addToCollection);
    };
  }
}
