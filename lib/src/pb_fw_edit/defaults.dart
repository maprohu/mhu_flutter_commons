part of 'proto_edit_frp.dart';

class PfeDefault {
  static PFN<Mfw, Widget> messageEditor(PKMessageEditor key) {
    final pbiMessage = lookupPbiMessage(key.messageType);
    final fieldKeys = pbiMessage.calc.topFieldKeys;

    return (editor, mfw) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final fieldKey in fieldKeys)
            editor(
              PKFieldEditor(fieldKey: fieldKey),
              mfw,
            ),
        ],
      );
    };
  }

  static PFN<Mfw, Widget> fieldEditor(PKFieldEditor key) {
    final fieldKey = key.fieldKey;

    final PFN<Mfw, Widget> fn = switch (fieldKey) {
      ConcreteFieldKey() => (editor, mfw) {
          return PKConcreteFieldEditor(
            fieldKey: fieldKey,
          ).call(
            editor,
            mfw,
          );
        },
      OneofFieldKey() => (editor, mfw) {
          return PKOneofFieldEditor(
            fieldKey: fieldKey,
          ).call(
            editor,
            mfw,
          );
        },
    };

    return (editor, input) {
      return _withFieldVisibility(
        editor: editor,
        fieldKey: fieldKey,
        builder: () {
          return fn(editor, input);
        },
      );
    };
  }

  static PFN<Mfw, Widget> concreteFieldEditor(PKConcreteFieldEditor key) {
    final fieldKey = key.fieldKey;
    final access = fieldKey.calc.access;

    return switch (access) {
      NumericIntFieldAccess() => access.editor,
      Int64FieldAccess() => access.editor,
      NumericDoubleFieldAccess() => access.editor,
      MessageFieldAccess() => access.editor,
      EnumFieldAccess() => access.editor,
      BoolFieldAccess() => access.editor,
      StringFieldAccess() => access.editor,
      BytesFieldAccess() => access.editor,
      RepeatedFieldAccess() => access.editor,
      MapFieldAccess() => access.editor,
    };
  }

  static PFN<Mfw, Widget> oneofFieldEditor(PKOneofFieldEditor key) {
    final fieldKey = key.fieldKey;
    final calc = fieldKey.calc;

    return (editor, input) {
      void showOneOfSelectDialog() {
        editor.ui.showDialog((popper) {
          return flcFrr(() {
            final which = calc.access.which(input());
            final selectedTag = calc.whichTagLookup.whichToTag[which]!;
            return SimpleDialog(
              title: PKFieldTitle(
                fieldKey: fieldKey,
              ).call(editor, input),
              children: [
                ...calc.fieldsInDescriptorOrder.map((field) {
                  final concreteFieldKey = ConcreteFieldKey(
                    messageType: fieldKey.messageType,
                    tagNumber: field.tagNumber,
                  );
                  final selected = field.tagNumber == selectedTag;
                  return ListTile(
                    title: PKFieldTitle(
                      fieldKey: concreteFieldKey,
                    ).call(editor, input),
                    selected: selected,
                    onTap: () {
                      popper.pop();
                      if (!selected) {
                        field.setFw(
                          input,
                          PKDefaultFieldValue(
                            fieldKey: concreteFieldKey,
                          ).call(
                            editor,
                            input,
                          ),
                        );
                      }
                    },
                  );
                }),
              ],
            );
          });
        });
      }

      final notSet = calc.oneof.which.last;

      return flcDsp((disposers) {
        return disposers.fr(() => calc.access.which(input())).asKey((which) {
          return Column(
            children: [
              ListTile(
                title: PKFieldTitle(
                  fieldKey: fieldKey,
                ).call(editor, input),
                subtitle: calc.fieldByWhich[which]?.let(
                      (field) {
                        return PKFieldTitle(
                          fieldKey: field.fieldKey,
                        ).call(editor, input);
                      },
                    ) ??
                    "<not set>".txt,
                onTap: showOneOfSelectDialog,
              ),
              if (which != notSet)
                PKConcreteFieldEditor(
                  fieldKey: calc.fieldByWhich[which]!.fieldKey,
                ).call(editor, input),
            ],
          );
        });
      });
    };
  }

  static PFN<Mfw, Widget> fieldTitle(PKFieldTitle key) {
    final fieldKey = key.fieldKey;
    switch (fieldKey) {
      case ConcreteFieldKey():
        final resolved = fieldKey.resolve();
        return (editor, mfw) {
          return resolved.field.name.titleCase.txt;
        };
      case OneofFieldKey():
        final resolved = fieldKey.calc;
        return (editor, mfw) {
          return resolved.oneof.name.titleCase.txt;
        };
    }
  }

  static PFN<Mfw, Widget?> fieldSubtitle(PKFieldSubtitle key) {
    final access = key.fieldKey.calc.access;
    return switch (access) {
      MapFieldAccess() => access.fieldSubtitle,
      RepeatedFieldAccess() => access.fieldSubtitle,
      _ => (editor, input) => null,
    };
  }

  static PFN<Mfw, dynamic> defaultFieldValue(PKDefaultFieldValue key) {
    return (editor, input) {
      return key.fieldKey.calc.defaultSingleValue;
    };
  }

  static PFN<DspReg, Fr<bool>> fieldVisibility(PKFieldVisibility key) {
    return (editor, input) {
      return input.fw(true);
    };
  }

  static PFN<Mfw, FutureOr<PbMapKey?>> createMapKey(PKCreateMapKey key) {
    final access = key.fieldKey.calc.access as MapFieldAccess;

    switch (access.defaultMapKey) {
      case PbIntMapKey():
        return (editor, input) {
          final keys = access.get(input.read()).keys as Iterable<int>;
          return PbMapKey.int((keys.maxOrNull ?? 0) + 1);
        };
      case PbStringMapKey():
        return (editor, input) async {
          PbStringMapKey? result;
          await ValidatingTextField.showDialog(
            ui: editor.ui,
            title: "New Item Key".txt,
            onSubmit: (value) {
              result = PbStringMapKey(value);
            },
            watchValidate: (value) {
              final currentValue = access.get(input());
              return [
                if (value.trim().isEmpty) 'Key must not be empty.',
                if (currentValue.containsKey(value)) 'Key already exists.',
              ];
            },
          );

          return result;
        };
    }
  }

  static PFN<PICreateCollectionItem, FutureOr<Object?>> createCollectionItem(
    PKCreateCollectionItem key,
  ) {
    final access = key.fieldKey.calc.singleValueFieldAccess;
    return switch (access) {
      NumericIntFieldAccess() => access.createCollectionItem,
      Int64FieldAccess() => access.createCollectionItem,
      NumericDoubleFieldAccess() => access.createCollectionItem,
      MessageFieldAccess() => access.createCollectionItem,
      EnumFieldAccess() => access.createCollectionItem,
      BoolFieldAccess() => access.createCollectionItem,
      StringFieldAccess() => access.createCollectionItem,
      BytesFieldAccess() => access.createCollectionItem,
      _ => throw access,
    };
  }

  static PFN<PICollectionItem, Widget> collectionItemTitle(
      PKCollectionItemTitle key) {
    final access = key.fieldKey.calc.access;
    return switch (access) {
      RepeatedFieldAccess() => access.collectionItemTitle,
      MapFieldAccess() => access.collectionItemTitle,
      _ => throw access,
    };
  }

  static PFN<PICollectionItem, Widget?> collectionItemSubtitle(
      PKCollectionItemSubtitle key) {
    final access = key.fieldKey.calc.singleValueFieldAccess;
    return switch (access) {
      NumericIntFieldAccess() => access.collectionItemSubtitle,
      Int64FieldAccess() => access.collectionItemSubtitle,
      NumericDoubleFieldAccess() => access.collectionItemSubtitle,
      MessageFieldAccess() => access.collectionItemSubtitle,
      EnumFieldAccess() => access.collectionItemSubtitle,
      BoolFieldAccess() => access.collectionItemSubtitle,
      StringFieldAccess() => access.collectionItemSubtitle,
      BytesFieldAccess() => access.collectionItemSubtitle,
      _ => throw access,
    };
  }

  static PFN<PISortCollectionItems, Iterable<PbEntry>> sortCollectionItems(
      PKSortCollectionItems key) {
    return (editor, input) => input.items;
  }

  static PFN<PICollectionItem, FutureOr<void>> editCollectionItem(
      PKEditCollectionItem key) {
    final access = key.fieldKey.calc.singleValueFieldAccess;
    return switch (access) {
      NumericIntFieldAccess() => access.collectionItemEditor,
      Int64FieldAccess() => access.collectionItemEditor,
      NumericDoubleFieldAccess() => access.collectionItemEditor,
      MessageFieldAccess() => access.collectionItemEditor,
      EnumFieldAccess() => access.collectionItemEditor,
      BoolFieldAccess() => access.collectionItemEditor,
      StringFieldAccess() => access.collectionItemEditor,
      BytesFieldAccess() => access.collectionItemEditor,
      _ => throw access,
    };
  }
}

PFN _pfeDefault(PfeKey key) {
  return switch (key) {
    PKMessageEditor() => PfeDefault.messageEditor(key).typeless,
    PKFieldEditor() => PfeDefault.fieldEditor(key).typeless,
    PKFieldTitle() => PfeDefault.fieldTitle(key).typeless,
    PKFieldSubtitle() => PfeDefault.fieldSubtitle(key).typeless,
    PKOneofFieldEditor() => PfeDefault.oneofFieldEditor(key).typeless,
    PKConcreteFieldEditor() => PfeDefault.concreteFieldEditor(key).typeless,
    PKDefaultFieldValue() => PfeDefault.defaultFieldValue(key).typeless,
    PKFieldVisibility() => PfeDefault.fieldVisibility(key).typeless,
    PKCreateMapKey() => PfeDefault.createMapKey(key).typeless,
    PKCreateCollectionItem() => PfeDefault.createCollectionItem(key).typeless,
    PKCollectionItemTitle() => PfeDefault.collectionItemTitle(key).typeless,
    PKCollectionItemSubtitle() =>
      PfeDefault.collectionItemSubtitle(key).typeless,
    PKSortCollectionItems() => PfeDefault.sortCollectionItems(key).typeless,
    PKEditCollectionItem() => PfeDefault.editCollectionItem(key).typeless,
  };
}
