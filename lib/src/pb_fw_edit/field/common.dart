part of '../proto_edit_frp.dart';

extension _CommonFieldAccessX on FieldAccess {
  Widget listTile({
    required Pfe editor,
    required Mfw input,
    Widget? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: PKFieldTitle(fieldKey: fieldKey).call(editor, input),
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}
