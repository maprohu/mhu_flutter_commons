part of '../proto_edit_frp.dart';

extension _MapFieldAccessX on MapFieldAccess {
  PFN<Mfw, Widget> get editor =>
          (editor, input) {
        return listTile(
          editor: editor,
          input: input,
          subtitle: PKFieldSubtitle(fieldKey: fieldKey).call(editor, input),
          onTap: () {
            editor.ui.pushWidget(
                  (popper) {
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

                          final value = PKDefaultFieldValue(fieldKey: fieldKey)
                              .call(editor, input);

                          input.rebuild((message) {
                            get(message)[key.value] = value;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    body: flcFrr(() {
                      return ListView(
                        children: get(input()).entries.map((e) {
                          return ListTile();
                        }).toList(),
                      );
                    }),
                ).scaffold;
              },
            );
          },
        );
      };
}
