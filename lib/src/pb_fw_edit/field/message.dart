part of '../proto_edit_frp.dart';

extension _MessageFieldAccessX on MessageFieldAccess {
  PFN<Mfw, Widget> get editor {
    return (editor, input) {
      return flcDsp(
        (disposers) {
          final fld = withScalarGenerics<Fw>(
            <M extends GeneratedMessage, F>(access) => access.fieldFw(
              input as Fw<M>,
              disposers: disposers,
            ),
          ) as Mfw;
          return PKMessageEditor(
            messageType: valueType,
          ).call(
            editor,
            fld,
          );
        },
      );
    };
  }

  PFN<PICollectionItem, FutureOr<void>> get collectionItemEditor =>
      (editor, input) async {
        await editor.ui.pushWidget((popper) {
          return ScaffoldParts(
            title: PKCollectionItemTitle(
              fieldKey: input.fieldKey,
            ).call(editor, input),
            body: SafeArea(
              child: SingleChildScrollView(
                child: PKMessageEditor(messageType: valueType).call(
                  editor,
                  input.itemFw as Mfw,
                ),
              ),
            ),
          ).scaffold;
        });
      };

  PFN<PICollectionItem, Widget?> get collectionItemSubtitle =>
      (editor, input) => null;

  PFN<PICreateCollectionItem, FutureOr<Object?>> get createCollectionItem {
    final defaultValue = defaultSingleValue;
    return (editor, input) async {
      final itemFw = input.addToCollection(defaultValue);

      final itemInput = (
        mfw: input.mfw,
        fieldKey: input.fieldKey,
        key: input.key,
        itemFw: itemFw,
      );
      await PKEditCollectionItem(
        fieldKey: input.fieldKey,
      ).call(
        editor,
        itemInput,
      );

      return itemFw.read();
    };
  }
}
