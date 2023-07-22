part of 'proto_edit_frp.dart';

class ProtoFwEditorImpl implements ProtoFwEditor {
  final Pfe pfe;

  ProtoFwEditorImpl({
    PfeConfig? cfg,
    required FlcUi ui,
  }) : pfe = Pfe(cfg: cfg ?? IMap(), ui: ui);

  @override
  Widget fieldEditor<M extends GeneratedMessage>({
    required Fw<M> message,
    required FieldMarker<M> field,
  }) {
    return pfe(
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
    return pfe(
      PKMessageEditor(
        messageType: message.read().runtimeType,
      ),
      message,
    );
  }
}
