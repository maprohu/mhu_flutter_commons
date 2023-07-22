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

    switch (fieldKey) {
      case ConcreteFieldKey():
        return (editor, mfw) {
          return PKConcreteFieldEditor(
            fieldKey: fieldKey,
          ).call(
            editor,
            mfw,
          );
        };
      case OneofFieldKey():
        return (editor, mfw) {
          return PKOneofFieldEditor(
            fieldKey: fieldKey,
          ).call(
            editor,
            mfw,
          );
        };
    }
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

  static PFN<Mfw, dynamic> defaultFieldValue(PKDefaultFieldValue key) {
    return (editor, input) {
      return key.fieldKey.calc.defaultSingleValue;
    };
  }
}

PFN _pfeDefault(PfeKey key) {
  final result = switch (key) {
    PKMessageEditor() => PfeDefault.messageEditor(key),
    PKFieldEditor() => PfeDefault.fieldEditor(key),
    PKFieldTitle() => PfeDefault.fieldTitle(key),
    PKOneofFieldEditor() => PfeDefault.oneofFieldEditor(key),
    PKConcreteFieldEditor() => PfeDefault.concreteFieldEditor(key),
    PKDefaultFieldValue() => PfeDefault.defaultFieldValue(key),
  };

  return (editor, input) => result(editor, input);
}
