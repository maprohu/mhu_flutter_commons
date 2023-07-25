part of '../proto_edit_frp.dart';

extension _CommonFieldAccessX on FieldAccess {
  Widget listTile({
    required Pfe editor,
    required Mfw input,
    Widget? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: fieldTitle(editor, input),
      subtitle: subtitle,
      onTap: onTap,
    );
  }
  
  
  Widget fieldTitle(Pfe editor, Mfw input) {
    return PKFieldTitle(
      fieldKey: fieldKey,
    ).call(
      editor,
      input,
    );
  }
}

Widget collectionItemWidget<M extends GeneratedMessage>({
  required PbMapKey pbKey,
  required CachedFu cachedFu,
  required Fw<M> input,
  required ConcreteFieldKey fieldKey,
  required Pfe editor,
  required void Function(M message) remove,
}) {

  return flcDsp((disposers) {
    final itemFw = cachedFu.item(pbKey.value);

    final itemInput = (
    mfw: input,
    fieldKey: fieldKey,
    key: pbKey,
    itemFw: itemFw,
    );

    final itemTitle = PKCollectionItemTitle(
      fieldKey: fieldKey,
    ).call(
      editor,
      itemInput,
    );

    void editItem() {
      PKEditCollectionItem(fieldKey: fieldKey).call(
        editor,
        itemInput,
      );
    }

    return Builder(
      builder: (context) {
        return ListTile(
          title: itemTitle,
          subtitle: PKCollectionItemSubtitle(
            fieldKey: fieldKey,
          ).call(
            editor,
            itemInput,
          ),
          trailing: Wrap(
            children: [
              IconButton(
                onPressed: () {
                  editor.ui.showConfirmDialog(
                    title: const Text("Delete Item"),
                    content: Wrap(
                      children: [
                        const Text(
                          "Are you sure you want to "
                              "delete the following item: ",
                        ),
                        itemTitle,
                      ],
                    ),
                    onConfirm: () {
                      input.rebuild(remove);
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: editItem,
                icon: const Icon(Icons.edit),
              ),
            ],
          ).withIconThemeOf(context),
          onTap: editItem,
        );
      },
    );
  });
}
