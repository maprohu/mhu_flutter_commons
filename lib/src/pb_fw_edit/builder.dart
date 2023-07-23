part of 'proto_edit_frp.dart';

class PfeBuilder {
  PfeConfig config;

  PfeBuilder([PfeConfig? config]) : config = config ?? IMap();

  void set<I, O>(PKIO<I, O> pk, PFN<I, O> fn) {
    config = config.set(pk, fn);
  }

  void hideField(FieldKey fieldKey) {
    set(
      PKFieldVisibility(fieldKey: fieldKey),
      (editor, input) => input.fw(false),
    );
  }

  void hideFieldMarker(FieldMarker fieldMarker) {
    hideField(fieldMarker.fieldKey);
  }
}

PfeConfig pfeConfig(
  void Function(PfeBuilder builder) build, {
  PfeConfig? initial,
}) {
  return PfeBuilder(initial).also(build).config;
}

extension PfeBuilderFieldMarkerX on FieldMarker {
  void hideField(PfeBuilder builder) => builder.hideField(fieldKey);
}
