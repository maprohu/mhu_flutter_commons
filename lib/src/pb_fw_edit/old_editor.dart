class FlcDefaultProtoFwEditor implements FlcProtoFwEditor {












  // "concrete" means it is not  "oneof"
  Widget editorTileForConcreteField(
      PdFld fld,
      Fw<GeneratedMessage> msgFw,
      ProtoFwPath path,
      ) {
    late final subtitle = subtitleForField(
      fld,
      msgFw,
      path,
    );

    late final title = titleForPdFld(fld);
    // late final conf = ListTile$Conf(
    //   title: title,
    // );

    // late final confSub = conf.copyWith(
    //   subtitle: subtitle,
    // );

    Widget stringEditor() {
      final fldFw = _fldFw(msgFw: msgFw, pdFld: fld);
      return flcFrr(() {
        final String value = fldFw();
        return ListTile(
          title: title,
          subtitle: subtitle,
          onTap: () {
            stringEditorDialog(
              ui: ui,
              title: title,
              initialValue: value,
              onSubmit: fldFw.set,
            );
          },
        );
      });
    }

    Widget intEditor() {
      final fldFw = _fldFw(msgFw: msgFw, pdFld: fld);
      return flcFrr(() {
        final int value = fldFw();
        return ListTile(
          title: title,
          subtitle: subtitle,
          onTap: () {
            intEditorDialog(
              ui: ui,
              title: title,
              initialValue: value,
              onSubmit: fldFw.set,
            );
          },
        );
      });
    }

    Widget boolEditor() {
      final fldFw = _fldFw(msgFw: msgFw, pdFld: fld);
      return flcFrr(() {
        final bool value = fldFw();
        return SwitchListTile(
          title: title,
          subtitle: subtitle,
          value: value,
          onChanged: fldFw.set,
        );
      });
    }

    Widget enumEditor(PdEnum enumType) {
      final fldFw = _fldFw(msgFw: msgFw, pdFld: fld);
      final pmEnum = enumType.payload.lib.enums[enumType.index];
      return Builder(builder: (context) {
        return ListTile(
          title: title,
          subtitle: subtitle,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return flcFrr(() {
                  final ProtobufEnum value = fldFw();
                  return SimpleDialog(
                    title: title,
                    children: pmEnum
                        .values()
                        .map(
                          (e) => ListTile(
                        title: Text(e.label),
                        selected: e == value,
                        onTap: () {
                          Navigator.pop(context);
                          fldFw.value = e;
                        },
                      ),
                    )
                        .toList(),
                  );
                });
              },
            );
          },
        );
      });
    }

    Widget repeatedMessageEditor(PdMsg messageType) {
      final fldFr = _fldFr(msgFw: msgFw, pdFld: fld);
      final pmFld = pmFldFor(fld) as PmRepeatedField;

      Fw<GeneratedMessage> createItemFw(int index) {
        return Fw.fromFr(
          fr: fldFr.map((t) {
            t as List;
            return t.getOrNull(index) ?? pmFld.create();
          }),
          set: (value) {
            msgFw.update((m) {
              return m.rebuild((b) {
                final list = pmFld.get(b);
                if (list.length > index) {
                  list[index] = value;
                }
              });
            });
          },
        );
      }

      return Builder(builder: (context) {
        void editItem(int index) {
          final itemFw = createItemFw(index);
          ui.pushWidget(
                (popper) => ScaffoldParts(
              title: flcFrr(() {
                return titleWidgetForMessageItem(
                  messageType,
                  itemFw(),
                  index,
                );
              }),
              body: SingleChildScrollView(
                child: editorForMessage(
                  messageType,
                  itemFw,
                  path.withPath(
                        (parent) => ProtoPath.repeated(
                      parent: parent,
                      field: pmFld,
                      index: index,
                    ),
                  ),
                ),
              ),
            ).scaffold,
          );
        }

        return ListTile(
          title: title,
          subtitle: subtitle,
          onTap: () {
            ui.pushWidget(
                  (popper) => ScaffoldParts(
                title: title,
                actions: [
                  IconButton(
                    onPressed: () {
                      late final int index;
                      msgFw.update((m) {
                        return m.rebuild((b) {
                          final list = pmFld.get(b);
                          index = list.length;
                          list.add(createNewItemForCollection(index, fld));
                        });
                      });
                      editItem(index);
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
                body: flcFrr(() {
                  final List items = fldFr();
                  return ListView(
                    children: items.mapIndexed((index, element) {
                      return ListTile(
                        title: titleWidgetForMessageItem(
                          messageType,
                          element,
                          index,
                        ),
                        onTap: () {
                          editItem(index);
                        },
                        trailing: Wrap(
                          children: [
                            if (canDeleteItemFrom(fld))
                              IconButton(
                                onPressed: () {
                                  msgFw.update((m) {
                                    return m.rebuild((b) {
                                      pmFld.get(b).removeAt(index);
                                    });
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                          ],
                        ).withIconThemeOf(context),
                      );
                    }).toList(),
                  );
                }),
              ).scaffold,
            );
          },
        );
      });
    }

    Widget mapOfScalarEditor<K extends Comparable<K>>(
        PdfValueType keyType,
        ) {
      return 'mapOfScalarEditor not yet implemented (${fld.name})'.txt;
    }

    Widget mapOfMessageEditor<K extends Comparable<K>>(
        PdfValueType keyType,
        PdMsg messageType,
        ) {
      final fldFr = _fldFr(msgFw: msgFw, pdFld: fld);
      final pmFld = pmFldFor(fld) as PmMapField;

      Fw<GeneratedMessage> createItemFw(K key) {
        return Fw.fromFr(
          fr: fldFr.map((t) {
            t as Map;
            return t[key] ?? pmFld.create();
          }),
          set: (value) {
            msgFw.update((m) {
              return m.rebuild((b) {
                final map = pmFld.get(b);
                map[key] = value;
              });
            });
          },
        );
      }

      void editItem(K key) {
        final itemFw = createItemFw(key);

        ui.pushWidget(
              (completer) {
            return ScaffoldParts(
              title: flcFrr(() {
                return titleWidgetForMessageItem(
                  messageType,
                  itemFw(),
                  key,
                );
              }),
              body: SingleChildScrollView(
                child: editorForMessage(
                  messageType,
                  createItemFw(key),
                  path.withPath(
                        (parent) => ProtoPath.mapOf(
                      parent: parent,
                      field: pmFld,
                      key: key,
                    ),
                  ),
                ),
              ),
            ).scaffold;
          },
        );
      }

      void create(K key) {
        msgFw.update((m) {
          return m.rebuild((b) {
            pmFld.get(b)[key] = createNewItemForCollection(key, fld);
          });
        });
        editItem(key);
      }

      // final adder = keyType.when(
      //   stringType: () => () {
      //     stringEditorDialog(
      //       ui: ui,
      //       title: const Text('Add New Item'),
      //       initialValue: '',
      //       onSubmit: (value) {
      //         create(value as K);
      //       },
      //       validator: (value) {
      //         final Map map = fldFr();
      //         return [
      //           if (map.containsKey(value())) 'Item already exists.',
      //         ];
      //       },
      //     );
      //   },
      //   intType: () => () {
      //     final Map<K, dynamic> items = fldFr.read();
      //     intEditorDialog(
      //       ui: ui,
      //       title: const Text('Add New Item'),
      //       initialValue: (items.keys.maxOrNull as int? ?? 0) + 1,
      //       onSubmit: (value) {
      //         create(value as K);
      //       },
      //       validator: (value) {
      //         final Map map = fldFr();
      //         return [
      //           if (map.containsKey(value())) 'Item already exists.',
      //         ];
      //       },
      //     );
      //   },
      // );

      return ListTile(
        title: title,
        subtitle: subtitle,
        onTap: () {
          ui.pushWidget(
                (completer) => ScaffoldParts(
              title: title,
              actions: [
                IconButton(
                  onPressed: () async {
                    final newKey = await createMapItemKey(fld, msgFw);
                    if (newKey == null) return;
                    create(newKey as K);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
              body: flcFrr(() {
                final Map<K, dynamic> items = fldFr();
                return Builder(builder: (context) {
                  return ListView(
                    children: items.entries.sortedBy((e) => e.key).map((e) {
                      final MapEntry(:key, value: element) = e;
                      return ListTile(
                        title: titleWidgetForMessageItem(
                          messageType,
                          element,
                          key,
                        ),
                        onTap: () {
                          editItem(key);
                        },
                        trailing: Wrap(
                          children: [
                            if (canDeleteItemFrom(fld))
                              IconButton(
                                onPressed: () {
                                  msgFw.update((m) {
                                    return m.rebuild((b) {
                                      pmFld.get(b).remove(key);
                                    });
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                          ],
                        ).withIconThemeOf(context),
                      );
                    }).toList(),
                  );
                });
              }),
            ).scaffold,
          );
        },
      );
    }

    Widget messageEditor(PdMsg messageType) {
      final fldFw = _fldFwMsg(msgFw: msgFw, pdFld: fld);

      return editorForMessage(
        messageType,
        fldFw,
        path.withPath(
              (parent) => parent.andField(
            pmFldFor(fld) as PmMsgFieldOfMessageOfType,
          ),
        ),
      );
    }

    late final titleSub = ListTile(
      title: title,
      subtitle: subtitle,
    );

    return switch (fld.cardinality) {
      PdfSingle() => switch (fld.singleValueType) {
        PdfStringType() => stringEditor(),
        PdfIntType() => intEditor(),
        PdfBoolType() => boolEditor(),
        PdfEnumType(:final pdEnum) => enumEditor(pdEnum),
        PdfMessageType(:final pdMsg) => messageEditor(pdMsg),
        _ => titleSub,
      },
      PdfRepeated() => switch (fld.singleValueType) {
        PdfMessageType(:final pdMsg) => repeatedMessageEditor(pdMsg),
        _ => titleSub,
      },
      PdfMapOf(fields: final mapOf) => switch (fld.singleValueType) {
        PdfMessageType(:final pdMsg) => switch (mapOf.key.singleValueType) {
          PdfIntType() => mapOfMessageEditor<num>(
            mapOf.key.singleValueType,
            pdMsg,
          ),
          PdfStringType() => mapOfMessageEditor<String>(
            mapOf.key.singleValueType,
            pdMsg,
          ),
          _ => throw 0,
        },
        _ => switch (mapOf.key.singleValueType) {
          PdfIntType() => mapOfScalarEditor<num>(
            mapOf.key.singleValueType,
          ),
          PdfStringType() => mapOfScalarEditor<String>(
            mapOf.key.singleValueType,
          ),
          _ => throw 0,
        }
      }
    }
        .withKey(fld.name);
  }

  bool canDeleteItemFrom(PdFld fld) => true;

  Widget titleWidgetForMessageItem(
      PdMsg msg,
      GeneratedMessage message,
      dynamic key,
      ) =>
      Text(key.toString());

  Future<Object?> createMapItemKey(
      PdFld fld,
      Fw<GeneratedMessage> msgFw,
      ) async {
    final fldFr = _fldFr(msgFw: msgFw, pdFld: fld);

    return switch (fld.mapKeyField.singleValueType) {
      PdfStringType() => await showTextInputDialog(
        ui: ui,
        title: const Text('Add New Item'),
        initialValue: '',
        validator: (value) {
          final Map map = fldFr();
          return [
            if (map.containsKey(value())) 'Item already exists.',
          ];
        },
      ),
      PdfIntType() => (fldFr.read().keys.cast<int>().maxOrNull ?? 0) + 1,
      _ => throw 0,
    };
  }

  Object createNewItemForCollection(
      Object key,
      PdFld fld,
      ) {
    final pmFld = pmFldFor(fld) as PmCollectionField;

    return pmFld.create();
  }

  void showMessageEditor(
      PdMsg pdMsg,
      Fw<GeneratedMessage> msgFw,
      dynamic key,
      ProtoFwPath path,
      ) {
    ui.pushWidget(
          (completer) {
        return ScaffoldParts(
          title: flcFrr(() {
            return titleWidgetForMessageItem(
              pdMsg,
              msgFw(),
              key,
            );
          }),
          body: SingleChildScrollView(
            child: editorForMessage(
              pdMsg,
              msgFw,
              path,
            ),
          ),
        ).scaffold;
      },
    );
  }
}
