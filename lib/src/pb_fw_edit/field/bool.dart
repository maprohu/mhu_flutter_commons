part of '../proto_edit_frp.dart';

extension _BoolFieldAccessX on BoolFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return flcFrr(() {
          return SwitchListTile(
            title: PKFieldTitle(fieldKey: fieldKey).call(editor, input),
            value: get(input()),
            onChanged: (value) {
              setFw(input, value);
            },
          );
        });
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
