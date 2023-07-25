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

  PFN<PICollectionItem, FutureOr<void>> get collectionItemEditor =>
      (editor, input) {};

  PFN<PICollectionItem, Widget?> get collectionItemSubtitle =>
      (editor, input) => null;

  PFN<PICreateCollectionItem, FutureOr<Object?>> get createCollectionItem {
    final defaultValue = defaultSingleValue;
    return (editor, input) => defaultValue.also(input.addToCollection);
  }
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

  PFN<PICollectionItem, FutureOr<void>> get collectionItemEditor =>
      (editor, input) {};

  PFN<PICollectionItem, Widget?> get collectionItemSubtitle =>
      (editor, input) => null;

  PFN<PICreateCollectionItem, FutureOr<Object?>> get createCollectionItem {
    final defaultValue = defaultSingleValue;
    return (editor, input) => defaultValue.also(input.addToCollection);
  }
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

  PFN<PICollectionItem, FutureOr<void>> get collectionItemEditor =>
      (editor, input) {};

  PFN<PICollectionItem, Widget?> get collectionItemSubtitle =>
      (editor, input) => null;

  PFN<PICreateCollectionItem, FutureOr<Object?>> get createCollectionItem {
    final defaultValue = defaultSingleValue;
    return (editor, input) => defaultValue.also(input.addToCollection);
  }
}
