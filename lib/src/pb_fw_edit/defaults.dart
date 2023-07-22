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

    final title = PKFieldTitle(
      fieldKey: fieldKey,
    );

    switch (fieldKey) {
      case ConcreteFieldKey():
        final (
          message: _,
          :field,
        ) = fieldKey.resolve();

        return (editor, mfw) {
          return ListTile(
            title: title(editor, mfw),
          );
        };
      case OneofFieldKey():
        return (editor, mfw) {
          return PKOneofFieldEditor(fieldKey: fieldKey).call(
            editor,
            mfw,
          );
        };
    }
  }

  static PFN<Mfw, Widget> concreteFieldEditor(PKConcreteFieldEditor key) {
    final fieldKey = key.fieldKey;
    return (editor, input) {
      return ListTile(
        title: PKFieldTitle(
          fieldKey: fieldKey,
        ).call(editor, input),
      );
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
                for (final field in calc.fieldsInDescriptorOrder)
                  ListTile(
                    title: PKFieldTitle(
                      fieldKey: ConcreteFieldKey(
                        messageType: fieldKey.messageType,
                        tagNumber: field.tagNumber,
                      ),
                    ).call(editor, input),
                    selected: field.tagNumber == selectedTag,
                  ),
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
}

PFN _pfeDefault(PfeKey key) {
  final result = switch (key) {
    PKMessageEditor() => PfeDefault.messageEditor(key),
    PKFieldEditor() => PfeDefault.fieldEditor(key),
    PKFieldTitle() => PfeDefault.fieldTitle(key),
    PKOneofFieldEditor() => PfeDefault.oneofFieldEditor(key),
    PKConcreteFieldEditor() => PfeDefault.concreteFieldEditor(key),
  };

  return (editor, input) => result(editor, input);
}
