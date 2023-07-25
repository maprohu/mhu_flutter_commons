part of '../proto_edit_frp.dart';
extension _BytesFieldAccessX on BytesFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
    return listTile(
      editor: editor,
      input: input,
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

