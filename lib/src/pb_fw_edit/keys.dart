part of 'proto_edit_frp.dart';

typedef PFN<I, O> = O Function(Pfe editor, I input);

abstract interface class PKIO<I, O> {}

typedef Mfw = Fw<GeneratedMessage>;

@freezed
sealed class PfeKey with _$PfeKey {
  @Implements.fromString("PKIO<Mfw, Widget>")
  const factory PfeKey.messageEditor({
    required Type messageType,
  }) = PKMessageEditor;

  @Implements.fromString("PKIO<Mfw, Widget>")
  const factory PfeKey.fieldEditor({
    required FieldKey fieldKey,
  }) = PKFieldEditor;

  @Implements.fromString("PKIO<Mfw, Widget>")
  const factory PfeKey.concreteFieldEditor({
    required ConcreteFieldKey fieldKey,
  }) = PKConcreteFieldEditor;

  @Implements.fromString("PKIO<Mfw, Widget>")
  const factory PfeKey.oneofFieldEditor({
    required OneofFieldKey fieldKey,
  }) = PKOneofFieldEditor;

  @Implements.fromString("PKIO<Mfw, Widget>")
  const factory PfeKey.fieldTitle({
    required FieldKey fieldKey,
  }) = PKFieldTitle;

  @Implements.fromString("PKIO<Mfw, dynamic>")
  const factory PfeKey.defaultFieldValue({
    required ConcreteFieldKey fieldKey,
  }) = PKDefaultFieldValue;
}
