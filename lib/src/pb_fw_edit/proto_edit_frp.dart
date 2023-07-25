import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';
import 'package:recase/recase.dart';

import '../flc_edit.dart';
import '../frp.dart';
import '../widgets.dart';
import '../app.dart';

part 'proto_edit_frp.freezed.dart';

part 'defaults.dart';

part 'boilerplate.dart';

part 'config.dart';

part 'keys.dart';

part 'editor.dart';

part 'builder.dart';

part 'common.dart';

part 'field/common.dart';

part 'field/message.dart';

part 'field/enum.dart';

part 'field/bool.dart';

part 'field/bytes.dart';

part 'field/numeric.dart';

part 'field/string.dart';

part 'field/repeated.dart';

part 'field/map.dart';


abstract interface class ProtoFwEditor {
  Widget messageEditor<M extends GeneratedMessage>(
    Fw<M> message,
  );

  Widget fieldEditor<M extends GeneratedMessage>({
    required Fw<M> message,
    required FieldMarker<M> field,
  });
}


