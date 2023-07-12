import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'rxdart.dart';
import 'textfield.dart';

typedef EditCallback<T> = void Function(
  BuildContext context,
  T? value,
  void Function(T value) callback,
);

typedef EditorWidget<T> = ({
  Widget widget,
  ValueListenable<T?> listenable,
});

typedef Validator<T> = Iterable<String> Function(T value);

EditCallback<T> editDialogCallback<T>({
  required Widget title,
  required EditorWidget<T> Function(T? initial) editorWidget,
}) {
  return (context, value, callback) {
    final editor = editorWidget(value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: editor.widget,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder(
              valueListenable: editor.listenable,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value == null
                      ? null
                      : () {
                          Navigator.pop(context);
                          callback(value);
                        },
                  child: const Text('OK'),
                );
              },
            ),
          ],
        );
      },
    );
  };
}

EditCallback<String> editStringCallback({
  required Widget title,
  Validator<String> validator = empty1,
}) =>
    editDialogCallback(
      title: title,
      editorWidget: (initial) => stringEditorWidget(
        initial: initial,
        validator: validator,
      ),
    );

EditCallback<double> editDoubleCallback({
  required Widget title,
  Validator<double> validator = empty1,
}) =>
    editDialogCallback(
      title: title,
      editorWidget: (initial) => doubleEditorWidget(
        initial: initial,
        validator: validator,
      ),
    );

EditorWidget<String> stringEditorWidget({
  required String? initial,
  Validator<String> validator = empty1,
  TextInputType? keyboardType,
}) {
  final controller = TextEditingController(text: initial ?? '')..selectAll();

  final notifier = ValueNotifier<String?>(null);

  void updateNotifier({
    required String value,
    required bool valid,
  }) {
    if (!valid || value == initial) {
      notifier.value = null;
    } else {
      notifier.value = value;
    }
  }

  updateNotifier(
    value: controller.text,
    valid: validator(controller.text).isEmpty,
  );

  final validationErrors = ValueNotifier<String?>(null);

  controller.addListener(() {
    final value = controller.text;
    final errors = validator(value);

    final valid = errors.isEmpty;

    updateNotifier(value: value, valid: valid);

    validationErrors.value = valid ? null : errors.join('\n');
  });

  return (
    widget: ValueListenableBuilder(
      valueListenable: validationErrors,
      builder: (context, errorText, child) {
        return TextField(
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(
            errorText: errorText,
          ),
          keyboardType: keyboardType,
        );
      },
    ),
    listenable: notifier,
  );
}

final doubleEditFormat = NumberFormat()
  ..minimumFractionDigits = 0
  ..turnOffGrouping();

EditorWidget<double> doubleEditorWidget({
  required double? initial,
  Validator<double> validator = empty1,
}) {
  double? parseDouble(String string) =>
      string.trim().replaceAll(',', '.').let(double.tryParse);

  final stringEditor = stringEditorWidget(
    initial: initial?.let(doubleEditFormat.format),
    validator: (stringValue) {
      final doubleValue = parseDouble(stringValue);
      if (doubleValue == null) {
        return [
          'Value must be a valid number.',
        ];
      }

      return validator(doubleValue);
    },
    keyboardType: TextInputType.numberWithOptions(
      signed: false,
      decimal: true,
    ),
  );

  final doubleNotifier = ValueNotifier<double?>(null);

  stringEditor.listenable.addListener(() {
    doubleNotifier.value = stringEditor.listenable.value?.let(parseDouble);
  });

  return (
    widget: stringEditor.widget,
    listenable: doubleNotifier,
  );
}

void showEditStringDialog({
  required BuildContext context,
  required Widget title,
  Validator<String> validator = empty1,
  String initial = '',
  required void Function(String value) callback,
}) {
  editStringCallback(
    title: title,
    validator: validator,
  ).call(
    context,
    initial,
    callback,
  );
}

EditCallback<T> editOptionsCallback<T>({
  required Widget title,
  required RxVal<List<T>> options,
  required Widget Function(T option) labelBuilder,
}) =>
    (context, value, callback) {
      showDialog(
        context: context,
        builder: (context) {
          return RxBuilder(
            rxVal: options,
            builder: (context, items) {
              return SimpleDialog(
                title: title,
                children: items
                    .map(
                      (e) => ListTile(
                        title: labelBuilder(e),
                        selected: e == value,
                        onTap: () {
                          Navigator.pop(context);
                          callback(e);
                        },
                      ),
                    )
                    .toList(),
              );
            },
          );
        },
      );
    };
// editDialogCallback(
//   title: title,
//   editorWidget: (initial) {
//     final notifier = ValueNotifier<T?>(null);
//
//     return (
//       widget: RxBuilder(
//         rxVal: options,
//         builder: (context, values) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               for (final option in values)
//                 ListTile(
//                   title: labelBuilder(option),
//                   selected: initial == option,
//                   onTap: () {},
//                 )
//             ],
//           );
//         },
//       ),
//       listenable: notifier,
//     );
//   },
// );
