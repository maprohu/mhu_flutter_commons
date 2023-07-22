part of 'proto_edit_frp.dart';

class Pfe {
  final PfeConfig cfg;
  final FlcUi ui;
  final Cache<PfeKey, PFN> _cache;

  Pfe({
    required this.cfg,
    required this.ui,
  }) : _cache = Cache(
          (key) => cfg[key] ?? _pfeDefault(key),
        );

  O call<I, O>(PKIO<I, O> key, I input) =>
      _cache.get(key as PfeKey).call(this, input) as O;
}

extension EditorPKIOX<I, O> on PKIO<I, O> {
  O call(Pfe editor, I input) => editor.call(this, input);
}
