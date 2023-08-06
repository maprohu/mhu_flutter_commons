part of '../proto_edit_frp.dart';

extension _RepeatedFieldAccessX on RepeatedFieldAccess {
  PFN<Mfw, Widget> get editor {
    final defaultValue = fieldKey.calc.defaultSingleValue;

    return (editor, input) {
      return listTile(
          editor: editor,
          input: input,
          subtitle: PKFieldSubtitle(fieldKey: fieldKey).call(editor, input),
          onTap: () {
            editor.ui.pushWidget(
              (popper) {
                return flcDsp((disposers) {
                  final cachedFu = withListGenerics<CachedFu>(
                    <M extends GeneratedMessage, V>(access) =>
                        CachedFu.list<V, Fw<V>>(
                      fv: access.fuHot(
                        input as Fw<M>,
                        disposers: disposers,
                      ),
                      wrap: bareFw,
                      defaultValue: defaultValue,
                      disposers: disposers,
                    ),
                  ) as ListFu;

                  return ScaffoldParts(
                    title: PKFieldTitle(fieldKey: fieldKey).call(editor, input),
                    bottomNavigatorBar: BottomAppBar(
                      child: IconButton(
                        onPressed: () async {
                          final index = get(input.read()).length;

                          await PKCreateCollectionItem(
                            fieldKey: fieldKey,
                          ).call(
                            editor,
                            (
                              mfw: input,
                              fieldKey: fieldKey,
                              key: PbIntMapKey(index),
                              addToCollection: (item) {
                                input.rebuild((message) {
                                  final list = get(message);
                                  list.add(item);
                                });

                                return cachedFu.item(index);
                              }
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    body: flcFrr(() {
                      final items = PKSortCollectionItems(
                        fieldKey: fieldKey,
                      ).call(
                        editor,
                        (
                          mfw: input,
                          items: get(input()).mapIndexed(
                            (index, e) => (
                              key: PbIntMapKey(index),
                              value: e,
                            ),
                          ),
                        ),
                      );
                      return SafeScrollColumn(
                        children: items.map((item) {
                          final pbKey = item.key as PbIntMapKey;

                          return collectionItemWidget(
                            pbKey: pbKey,
                            cachedFu: cachedFu,
                            input: input,
                            fieldKey: fieldKey,
                            editor: editor,
                            remove: (message) {
                              get(message).removeAt(pbKey.value);
                            },
                          ).withKey(item.key);
                          // return flcDsp((disposers) {
                          //   final itemFw = cachedFu.item(pbKey.value);
                          //
                          //   final itemInput = (
                          //     mfw: input,
                          //     fieldKey: fieldKey,
                          //     key: pbKey,
                          //     itemFw: itemFw,
                          //   );
                          //
                          //   final itemTitle = PKCollectionItemTitle(
                          //     fieldKey: fieldKey,
                          //   ).call(
                          //     editor,
                          //     itemInput,
                          //   );
                          //
                          //   void editItem() {
                          //     PKEditCollectionItem(fieldKey: fieldKey).call(
                          //       editor,
                          //       itemInput,
                          //     );
                          //   }
                          //
                          //   return Builder(
                          //     builder: (context) {
                          //       return ListTile(
                          //         title: itemTitle,
                          //         subtitle: PKCollectionItemSubtitle(
                          //           fieldKey: fieldKey,
                          //         ).call(
                          //           editor,
                          //           itemInput,
                          //         ),
                          //         trailing: Wrap(
                          //           children: [
                          //             IconButton(
                          //               onPressed: () {
                          //                 editor.ui.showConfirmDialog(
                          //                   title: const Text("Delete Item"),
                          //                   content: Wrap(
                          //                     children: [
                          //                       const Text(
                          //                         "Are you sure you want to "
                          //                         "delete the following item: ",
                          //                       ),
                          //                       itemTitle,
                          //                     ],
                          //                   ),
                          //                   onConfirm: () {
                          //                     input.rebuild((message) {
                          //                       get(message)
                          //                           .remove(pbKey.value);
                          //                     });
                          //                   },
                          //                 );
                          //               },
                          //               icon: const Icon(Icons.delete),
                          //             ),
                          //             IconButton(
                          //               onPressed: editItem,
                          //               icon: const Icon(Icons.edit),
                          //             ),
                          //           ],
                          //         ).withIconThemeOf(context),
                          //         onTap: editItem,
                          //       );
                          //     },
                          //   );
                          // });
                        }).toList(),
                      );
                    }),
                  ).scaffold;
                });
              },
            );
          });
    };
  }

  PFN<Mfw, Widget?> get fieldSubtitle {
    return (editor, input) {
      return flcText(() {
        final count = get(input()).length;
        return '$count ${count == 1 ? 'item' : 'items'}';
      });
    };
  }

  PFN<PICollectionItem, Widget> get collectionItemTitle => (editor, input) {
        final key = input.key as PbIntMapKey;

        return Wrap(
          children: [
            PKFieldTitle(fieldKey: input.fieldKey).call(editor, input.mfw),
            const Text(": "),
            key.value.toString().txt
          ],
        );
      };
}
