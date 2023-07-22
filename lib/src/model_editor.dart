// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_dart_model/mhu_dart_model.dart';
// import 'package:mhu_dart_proto/mhu_dart_proto.dart' as $mdp;
// import 'package:mhu_flutter_commons/src/widgets.dart';
// import 'package:protobuf/protobuf.dart';
//
// import 'frp.dart';
// import 'proto_edit_frp.dart';
//
// class MhuDartCommonsEditor extends FlcDefaultProtoFwEditor {
//   MhuDartCommonsEditor({
//     required super.ui,
//     required Iterable<$mdp.PmLib> libs,
//   }) : super(
//           libs: [
//             ...libs,
//             mhuDartModelLib,
//           ],
//         );
//
//   @override
//   Widget titleWidgetForMessageItem(PdMsg msg, GeneratedMessage message, key) {
//     switch (scst(msg, message)) {
//       case Scst<CmnEnumOptionMsg$$>(:final message):
//         return message.labelOrValueOr('<no name>').txt;
//     }
//
//     return super.titleWidgetForMessageItem(msg, message, key);
//   }
//
//   @override
//   Object createNewItemForCollection(Object key, PdFld fld) {
//     switch (pmFldFor(fld)) {
//       case CmnEnumTypeMsg$$options():
//         return CmnEnumOptionMsg()
//           ..value = 'value$key'
//           ..freeze();
//     }
//     return super.createNewItemForCollection(key, fld);
//   }
//
//   @override
//   Widget editorTileForConcreteField(PdFld fld, Fw<GeneratedMessage> msgFw,
//       ProtoFwPath<GeneratedMessage> path) {
//     switch (fcst(fld, msgFw)) {
//       case Pcst<CmnColorThemeMsg$$seedColor>(:final fldFw):
//         return Builder(builder: (context) {
//           return flcFrr(() {
//             final value = Color(fldFw()).withOpacity(1);
//
//             final title = 'Theme Color'.txt;
//             return ListTile(
//               title: title,
//               trailing: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Theme.of(context).textTheme.bodyMedium?.color ??
//                             Colors.black,
//                       ),
//                       color: value,
//                     ),
//                   ),
//                 ),
//               ),
//               onTap: () {
//                 ui.showDialog((popper) {
//                   var color = value;
//                   return AlertDialog(
//                     title: title,
//                     content: SingleChildScrollView(
//                       child: MaterialPicker(
//                         pickerColor: value,
//                         onColorChanged: (value) {
//                           color = value;
//                         },
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           popper.pop();
//                           fldFw.value = color.value;
//                         },
//                         child: 'OK'.txt,
//                       ),
//                     ],
//                   );
//                 });
//               },
//             );
//           });
//         });
//     }
//     return super.editorTileForConcreteField(fld, msgFw, path);
//   }
//
// // @override
// // Object createDefaultValueForField(PdFld fld, Fw<GeneratedMessage> msgFw,
// //     ProtoFwPath<GeneratedMessage> path) {
// //   final pmFld = pmFldFor(fld);
// //
// //   switch (pmFld) {
// //     case CameraTimingMsg$$customDelay():
// //       return CameraTimingDelayedMsg(
// //         shutterDelayMilliseconds: 1000,
// //       )..freeze();
// //   }
// //
// //   return super.createDefaultValueForField(fld, msgFw, path);
// // }
// }
