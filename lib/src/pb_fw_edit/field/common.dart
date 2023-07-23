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
