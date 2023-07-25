part of '../proto_edit_frp.dart';

extension _MapFieldAccessX on MapFieldAccess {
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
                final cachedFu = withMapGenerics<CachedFu>(
                  <M extends GeneratedMessage, K, V>(access) =>
                      CachedFu.map<V, K, Fw<V>>(
                    fv: access.fu(
                      input as Fw<M>,
                      disposers: disposers,
                    ),
                    wrap: bareFw,
                    defaultValue: defaultValue,
                    disposers: disposers,
                  ),
                );

                return ScaffoldParts(
                  title: PKFieldTitle(fieldKey: fieldKey).call(editor, input),
                  bottomNavigatorBar: BottomAppBar(
                    child: IconButton(
                      onPressed: () async {
                        final key = await PKCreateMapKey(fieldKey: fieldKey)
                            .call(editor, input);

                        if (key == null) {
                          return;
                        }

                        await PKCreateCollectionItem(
                          fieldKey: fieldKey,
                        ).call(
                          editor,
                          (
                            mfw: input,
                            fieldKey: fieldKey,
                            key: key,
                            addToCollection: (item) {
                              input.rebuild((message) {
                                get(message)[key.value] = item;
                              });

                              return cachedFu.item(key.value);
                            }
                          ),
                        );
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                  body: flcFrr(() {
                    final keyWrapper = defaultMapKey.withValue;
                    final items = PKSortCollectionItems(
                      fieldKey: fieldKey,
                    ).call(
                      editor,
                      (
                        mfw: input,
                        items: get(input()).entries.map(
                              (e) => (
                                key: keyWrapper(e.key),
                                value: e.value,
                              ),
                            ),
                      ),
                    );
                    return ListView(
                      children: items.map((item) {
                        final PbMapKey pbKey = item.key;
                        return collectionItemWidget(
                          pbKey: pbKey,
                          cachedFu: cachedFu,
                          input: input,
                          fieldKey: fieldKey,
                          editor: editor,
                          remove: (message) {
                            get(message).remove(pbKey.value);
                          },
                        );
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
                        //                       get(message).remove(pbKey.value);
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
        },
      );
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
    return input.key.value.toString().txt;
  };
}
