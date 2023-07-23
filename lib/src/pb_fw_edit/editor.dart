part of 'proto_edit_frp.dart';

class Pfe {
  final FlcUi ui;
  final Cache<PfeKey, PFN> _cache;

  Pfe({
    required PfeConfig config,
    required this.ui,
  }) : _cache = Cache(
          (key) => config[key] ?? _pfeDefault(key),
        );

  O call<I, O>(PKIO<I, O> key, I input) {
    final PFN fn = _cache.get(key as PfeKey);
    return fn(this, input) as O;
  }
}

extension EditorPKIOX<I, O> on PKIO<I, O> {
  O call(Pfe editor, I input) => editor.call(this, input);
}
