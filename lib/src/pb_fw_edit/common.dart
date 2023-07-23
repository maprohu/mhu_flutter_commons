part of 'proto_edit_frp.dart';

Widget _withFieldVisibility({
  required Pfe editor,
  required FieldKey fieldKey,
  required Widget Function() builder,
}) {
  late final child = builder();
  return flcDsp((disposers) {
    final visibility = PKFieldVisibility(
      fieldKey: fieldKey,
    ).call(
      editor,
      disposers,
    );

    return visibility.asKey((visible) {
      if (!visible) {
        return nullWidget;
      }

      return child;
    });
  });
}
