part of 'proto_edit_frp.dart';

typedef PFN<I, O> = O Function(Pfe editor, I input);

extension PFNX<I, O> on PFN<I, O> {
  PFN get typeless => (editor, input) => call(editor, input);
}

abstract interface class PKIO<I, O> {}


typedef PICreateCollectionItem = ({
  Mfw mfw,
  ConcreteFieldKey fieldKey,
  PbMapKey key,
  Fw Function(Object item) addToCollection,
});

typedef PICollectionItem = ({
  Mfw mfw,
  ConcreteFieldKey fieldKey,
  PbMapKey key,
  Fw itemFw,
});

typedef PbEntry<T> = ({
  PbMapKey key,
  T value,
});

typedef PISortCollectionItems = ({
  Mfw mfw,
  Iterable<PbEntry> items,
});

typedef PKIOSortCollectionItems
    = PKIO<PISortCollectionItems, Iterable<PbEntry>>;

@Freezed(
  when: FreezedWhenOptions.none,
)
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

  @Implements.fromString("PKIO<Mfw, VoidCallback?>")
  const factory PfeKey.fieldOnTap({
    required ConcreteFieldKey fieldKey,
  }) = PKFieldOnTap;

  @Implements.fromString("PKIO<PICollectionItem, Widget>")
  const factory PfeKey.collectionItemTitle({
    required ConcreteFieldKey fieldKey,
  }) = PKCollectionItemTitle;

  @Implements.fromString("PKIO<PICollectionItem, Widget?>")
  const factory PfeKey.collectionItemSubtitle({
    required ConcreteFieldKey fieldKey,
  }) = PKCollectionItemSubtitle;

  @Implements.fromString("PKIO<Mfw, Widget?>")
  const factory PfeKey.fieldSubtitle({
    required ConcreteFieldKey fieldKey,
  }) = PKFieldSubtitle;

  @Implements.fromString("PKIO<Mfw, dynamic>")
  const factory PfeKey.defaultFieldValue({
    required ConcreteFieldKey fieldKey,
  }) = PKDefaultFieldValue;

  @Implements.fromString("PKIO<DspReg, Fr<bool>>")
  const factory PfeKey.fieldVisibility({
    required FieldKey fieldKey,
  }) = PKFieldVisibility;

  @Implements.fromString("PKIO<Mfw, FutureOr<PbMapKey?>>")
  const factory PfeKey.createMapKey({
    required ConcreteFieldKey fieldKey,
  }) = PKCreateMapKey;

  @Implements.fromString("PKIO<PICreateCollectionItem, FutureOr<Object?>>")
  const factory PfeKey.createCollectionItem({
    required ConcreteFieldKey fieldKey,
  }) = PKCreateCollectionItem;

  @Implements.fromString("PKIO<PICollectionItem, FutureOr<void>>")
  const factory PfeKey.editCollectionItem({
    required ConcreteFieldKey fieldKey,
  }) = PKEditCollectionItem;

  @Implements.fromString("PKIOSortCollectionItems")
  const factory PfeKey.sortCollectionItems({
    required ConcreteFieldKey fieldKey,
  }) = PKSortCollectionItems;
}
