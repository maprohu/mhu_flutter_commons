part of 'proto_edit_frp.dart';

@freezed
class ProtoFwPath<M extends GeneratedMessage> with _$ProtoFwPath<M> {
  const factory ProtoFwPath({
    required Fw<M> root,
    required ProtoPath path,
  }) = _ProtoFwPath;
}

extension ProtoFwPathX<M extends GeneratedMessage> on ProtoFwPath<M> {
  ProtoFwPath<M> withPath(ProtoPath Function(ProtoPath parent) path) =>
      copyWith(
        path: path(this.path),
      );
}
