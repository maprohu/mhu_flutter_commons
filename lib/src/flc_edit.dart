import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'layout.dart';
import 'textfield.dart';
import 'app.dart';
import 'frp.dart';

Future<String?> showTextInputDialog({
  required FlcUi ui,
  required Widget title,
  String? initialValue,
  String hint = "",
  Widget? submitLabel,
  Iterable<String> Function(Fr<String> value) validator = empty1,
}) async {
  return await ui.showDialog(
    (completer) => flcDsp((disposers) {
      final textFieldController = TextEditingController(text: initialValue);
      textFieldController.selectAll();

      final valueFw = fw(initialValue ?? '');

      final errorsFr = fr(() => validator(valueFw), disposers: disposers);

      textFieldController.addListener(
        () => valueFw.value = textFieldController.text,
      );

      disposers.add(textFieldController.dispose);

      return flcFrr(() {
        final errors = errorsFr();
        final submit = errors.isEmpty
            ? () {
                completer.pop(
                  textFieldController.text,
                );
              }
            : null;
        return AlertDialog(
          title: title,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textFieldController,
                decoration: InputDecoration(hintText: hint),
                autofocus: true,
                // textInputAction: TextInputAction.none,
                onSubmitted: submit?.let((e) => e()),
              ),
              ...errors.where((msg) => msg.isNotEmpty).map(
                    (e) => Builder(builder: (context) {
                      return Text(
                        e,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ).withPadding();
                    }),
                  )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: completer.pop,
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: submit,
              child: submitLabel ?? const Text('OK'),
            ),
          ],
        );
      });
    }),
  );
}

typedef StringValidator = Iterable<String> Function(Fr<String> value);

// Future<void> stringEditorDialog({
//   required FlcUi ui,
//   required Widget title,
//   required String initialValue,
//   required void Function(String value) onSubmit,
//   StringValidator validator = empty1,
//   Widget? submitLabel,
// }) async {
//   final value = await showTextInputDialog(
//     ui: ui,
//     title: title,
//     initialValue: initialValue,
//     validator: validator,
//     submitLabel: submitLabel,
//   );
//   if (value != null) {
//     onSubmit(value);
//   }
// }

// Future<void> intEditorDialog({
//   required FlcUi ui,
//   required Widget title,
//   required int? initialValue,
//   required void Function(int value) onSubmit,
//   StringValidator validator = empty1,
// }) {
//   return stringEditorDialog(
//     ui: ui,
//     title: title,
//     initialValue: initialValue?.let((v) => v.toString()) ?? '',
//     onSubmit: (value) {
//       onSubmit(int.parse(value));
//     },
//     validator: (value) => [
//       ...validateStringOfInt(value),
//       ...validator(value),
//     ],
//   );
// }

Iterable<String> validateStringOfInt(Fr<String> value) => [
      if (int.tryParse(value()) == null) 'Not a valid number.',
    ];

// Future<void> decimalEditorDialog({
//   required FlcUi ui,
//   required Widget title,
//   required Decimal? initialValue,
//   required void Function(Decimal value) onSubmit,
//   StringValidator validator = empty1,
// }) {
//   return stringEditorDialog(
//     ui: ui,
//     title: title,
//     initialValue: initialValue?.let((v) => v.toStringAsFixed(2)) ?? '',
//     onSubmit: (value) {
//       onSubmit(
//         tryParseDecimal(value)!,
//       );
//     },
//     validator: (value) => [
//       ...validateStringOfDecimal(value),
//       ...validator(value),
//     ],
//   );
// }

Iterable<String> validateStringOfDecimal(Fr<String> value) {
  final string = value();
  if (string.isEmpty) return [''];
  return [
    if (tryParseDecimal(string) == null) 'Enter a valid decimal number.',
  ];
}
