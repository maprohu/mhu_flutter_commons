part of '../proto_edit_frp.dart';

extension _EnumFieldAccessX on EnumFieldAccess {
  PFN<Mfw, Widget> get editor => (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: flcText(
            () => getOpt(input())?.name.titleCase ?? '<not set>',
          ),
          onTap: () {
            editor.ui.showDialog(
              (popper) {
                return flcFrr(() {
                  final ProtobufEnum currentValue = get(input());
                  return SimpleDialog(
                    title: fieldTitle(editor, input),
                    children: enumValues
                        .map(
                          (enumValue) => ListTile(
                            title: Text(enumValue.label),
                            selected: enumValue == currentValue,
                            onTap: () {
                              popper.pop();
                              setFw(input, enumValue);
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
      };
}
