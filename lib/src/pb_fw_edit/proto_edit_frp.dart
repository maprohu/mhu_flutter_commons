import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';
import 'package:recase/recase.dart';

import '../frp.dart';
import '../widgets.dart';
import '../app.dart';

part 'proto_edit_frp.freezed.dart';

part 'defaults.dart';

part 'boilerplate.dart';

part 'config.dart';

part 'path.dart';

part 'keys.dart';

part 'editor.dart';

part 'field/common.dart';

part 'field/message.dart';

part 'field/enum.dart';

part 'field/bool.dart';

part 'field/bytes.dart';

part 'field/numeric.dart';

part 'field/string.dart';
part 'field/repeated.dart';
part 'field/map.dart';

final _logger = Logger();

abstract interface class ProtoFwEditor {
  Widget messageEditor<M extends GeneratedMessage>(
    Fw<M> message,
  );

  Widget fieldEditor<M extends GeneratedMessage>({
    required Fw<M> message,
    required FieldMarker<M> field,
  });
}

extension ProtoFwX on Fw<GeneratedMessage> {
  Fw<F> fldCast<F>(PmFullField<GeneratedMessage, F> fld) {
    return Fw.fromFr(
      fr: map(fld.get),
      set: (value) {
        update((t) {
          return t.rebuild(
            (b) => fld.set(b, value),
          );
        });
      },
    );
  }
}

extension PmFullFieldProtoX<F> on PmFullField<GeneratedMessage, F> {
  Widget Function(Fw<GeneratedMessage> msgFw) fldCast(
      Widget Function(Fw<F> fldFw) builder) {
    return (msgFw) {
      final fldFw = msgFw.fldCast(this);
      return builder(fldFw);
    };
  }

  O Function(Fw<GeneratedMessage> msgFw, I input) fldCastIO<I, O>(
      O Function(Fw<F> fldFw, I input) builder) {
    return (msgFw, input) {
      final fldFw = msgFw.fldCast(this);
      return builder(fldFw, input);
    };
  }
}

Widget Function(Fw<GeneratedMessage> msgFw) Function(
        PmSingleField<GeneratedMessage, F> pmFld)
    fldCaster<F>(Widget Function(Fw<F> fldFw, PmSingleField fld) builder) {
  return (fld) => fld.fldCast(
        (fldFw) => builder(fldFw, fld),
      );
}

O Function(Fw<GeneratedMessage> msgFw, I input) Function(
        PmSingleField<GeneratedMessage, F> pmFld)
    fldCasterIO<F, I, O>(
        O Function(Fw<F> fldFw, PmSingleField fld, I input) builder) {
  return (fld) => fld.fldCastIO(
        (fldFw, input) => builder(fldFw, fld, input),
      );
}
