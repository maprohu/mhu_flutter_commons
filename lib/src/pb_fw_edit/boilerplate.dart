part of 'proto_edit_frp.dart';

class ProtoFwEditorImpl implements ProtoFwEditor {
  final Pfe _pfe;

  ProtoFwEditorImpl({
    PfeConfig? config,
    required FlcUi ui,
  }) : _pfe = Pfe(config: config ?? IMap(), ui: ui);

  @override
  Widget fieldEditor<M extends GeneratedMessage>({
    required Fw<M> message,
    required FieldMarker<M> field,
  }) {
    return _pfe(
      PKFieldEditor(
        fieldKey: field.fieldKey,
      ),
      message,
    );
  }

  @override
  Widget messageEditor<M extends GeneratedMessage>(
    Fw<M> message,
  ) {
    return _pfe(
      PKMessageEditor(
        messageType: message.read().runtimeType,
      ),
      message,
    );
  }
}
