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

  PfeConfigurator<M> configure<M>(M marker) => PfeConfigurator(
        builder: this,
        marker: marker,
      );

  PfeConfigurator<PbiMessage> configureMessage<M extends GeneratedMessage>() =>
      PfeConfigurator(
        builder: this,
        marker: lookupPbiMessage(M),
      );
}

PfeConfig pfeConfig(
  void Function(PfeBuilder builder) build, {
  PfeConfig? initial,
}) {
  return PfeBuilder(initial).also(build).config;
}

extension PfeBuilderFieldMarkerX<F extends FieldMarker> on F {
  void hideField(PfeBuilder builder) => builder.hideField(fieldKey);

  PfeConfigurator<F> configure(PfeBuilder builder) => PfeConfigurator(
        builder: builder,
        marker: this,
      );
}

class PfeConfigurator<M> {
  final PfeBuilder builder;
  final M marker;

  const PfeConfigurator({
    required this.builder,
    required this.marker,
  });
}

extension PfeMapFieldConfiguratorX<M extends GeneratedMessage, K, V>
    on PfeConfigurator<MapFieldAccess<M, K, V>> {
  void fieldEditor(PFN<MapFu<K, V>, Widget> pfn) {
    builder.set(
      PKFieldEditor(fieldKey: marker.fieldKey),
      (editor, input) {
        return flcDsp((disposers) {
          final mapFu = CachedFu.map(
            fv: marker.fu(
              input as Fw<M>,
              disposers: disposers,
            ),
            wrap: bareFw<V>,
            defaultValue: marker.defaultSingleValue,
            disposers: disposers,
          );
          return pfn(editor, mapFu);
        });
      },
    );
  }
}

extension PfeScalarFieldConfiguratorX<M extends GeneratedMessage, F>
    on PfeConfigurator<ScalarFieldAccess<M, F>> {
  void fieldEditor(PFN<Fw<F>, Widget> pfn) {
    builder.set(
      PKFieldEditor(fieldKey: marker.fieldKey),
      (editor, input) {
        return flcDsp((disposers) {
          final itemFw = marker.fieldFw(
            input as Fw<M>,
            disposers: disposers,
          );
          return pfn(editor, itemFw);
        });
      },
    );
  }

  void defaultValue(F value) {
    builder.set(
      PKDefaultFieldValue(fieldKey: marker.fieldKey),
      (editor, input) => value,
    );
  }
}

extension PfeMapFieldAccess<M extends GeneratedMessage, K, V>
    on MapFieldAccess<M, K, V> {}
