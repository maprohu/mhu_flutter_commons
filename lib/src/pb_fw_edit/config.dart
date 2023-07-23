part of 'proto_edit_frp.dart';

typedef PfeConfig = IMap<PfeKey, PFN>;

extension PfeConfigX on PfeConfig {
  PfeConfig set<I, O>(PKIO<I, O> pk, PFN<I, O> fn) {
    return add(
      pk as PfeKey,
      (editor, input) => fn(editor, input),
    );
  }
}

// @freezed
// class PfeConfig with _$PfeConfig {
//   const factory PfeConfig({
//     required IMap<PfeKey, PFN> map,
//   }) = _PfeConfig;
//
//   static PfeConfig empty() => PfeConfig(
//         map: IMap(),
//       );
// }
