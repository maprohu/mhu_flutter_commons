import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

extension TextEditingControllerX on TextEditingController {
  void selectAll() => selection = TextSelection(
        baseOffset: 0,
        extentOffset: value.text.length,
      );
}

class ValidatingTextController {
  final String initialValue;
  final Iterable<String> Function(String value) watchValidate;
  final String Function(String value) textProcessor;

  static Iterable<String> defaultValidator(String value) => [
        if (value.isEmpty) 'Must provide a value',
      ];

  static String defaultTextProcessor(String value) => value.trim();

  ValidatingTextController({
    required String initialValue,
    this.watchValidate = defaultValidator,
    this.textProcessor = defaultTextProcessor,
  }) : initialValue = textProcessor(initialValue);

  late final textEditingController = TextEditingController(
    text: initialValue,
  )..selectAll();

  late final _changed = fw(false);

  late final Fr<String> editingText = fw(initialValue).also((e) {
    textEditingController.addListener(() {
      final text = textProcessor(textEditingController.value.text);
      if (text != initialValue) {
        _changed.value = true;
      }
      e.value = text;
    });
  });

  late final editingState = fr(() {
    final text = editingText();
    final errors = watchValidate(text);
    return (
      text: text,
      errors: errors,
      valid: errors.isEmpty,
      dirty: text != initialValue,
    );
  });

  late final validationErrors = fr(
    () => editingState().errors,
  );

  late final validationErrorText = fr(() {
    final errors = validationErrors();

    if (errors.isEmpty) {
      return null;
    }

    return errors.join('\n');
  });

  late final validationErrorTextSkipInitial = fr(() {
    if (!_changed()) {
      return null;
    }
    return validationErrorText();
  });

  late final dirty = fr(() => editingText() != initialValue);

  late final validEditingText = fr(() {
    final state = editingState();
    return state.valid ? state.text : null;
  });

  late final validDirtyEditingText = fr(() {
    final state = editingState();
    return state.valid && state.dirty ? state.text : null;
  });
}

extension ValidatingTextControllerX on ValidatingTextController {
  Future<void> showDialog<T extends Object>({
    required FlcUi ui,
    required Widget title,
    required void Function(T value) onSubmit,
    required Fr<T?> result,
  }) async {
    await ui.showDialog((popper) {
      return AlertDialog(
        title: title,
        content: ValidatingTextField(
          controller: this,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: popper.pop,
            child: const Text("Cancel"),
          ),
          flcFrr(() {
            final value = result();
            return ElevatedButton(
              onPressed: value == null
                  ? null
                  : () {
                      popper.pop();
                      onSubmit(value);
                    },
              child: const Text("OK"),
            );
          }),
        ],
      );
    });
  }
}

class ValidatingTextField extends StatelessWidget {
  final ValidatingTextController controller;
  final bool autofocus;
  final String? labelText;

  ValidatingTextField({
    super.key,
    required this.controller,
    this.autofocus = false,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return flcFrr(() {
      return TextField(
        controller: controller.textEditingController,
        autofocus: autofocus,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: controller.validationErrorTextSkipInitial(),
        ),
      );
    });
  }

  static Future<void> showDialog({
    required FlcUi ui,
    required Widget title,
    String initialValue = '',
    required void Function(String value) onSubmit,
    Iterable<String> Function(String value) watchValidate =
        ValidatingTextController.defaultValidator,
    String Function(String value) textProcessor =
        ValidatingTextController.defaultTextProcessor,
  }) async {
    final controller = ValidatingTextController(
      initialValue: initialValue,
      watchValidate: watchValidate,
      textProcessor: textProcessor,
    );
    await controller.showDialog(
      ui: ui,
      title: title,
      onSubmit: onSubmit,
      result: controller.validDirtyEditingText,
    );
  }

  static Future<void> showParsingDialog<T extends Object>({
    required FlcUi ui,
    required Widget title,
    String initialValue = '',
    required ParseFunction<T> parser,
    required void Function(T value) onSubmit,
  }) async {
    final controller = ParsingTextController(
      initialValue: initialValue,
      parser: parser,
    );

    await controller.showDialog(
      ui: ui,
      title: title,
      onSubmit: onSubmit,
      result: controller.validDirtyParsedValue,
    );
  }

  static Future<void> showIntDialog({
    required FlcUi ui,
    required Widget title,
    String initialValue = '',
    required void Function(int value) onSubmit,
  }) async {
    await showParsingDialog(
      ui: ui,
      title: title,
      parser: intParseFunction,
      onSubmit: onSubmit,
      initialValue: initialValue,
    );
  }
  static Future<void> showInt64Dialog({
    required FlcUi ui,
    required Widget title,
    String initialValue = '',
    required void Function(Int64 value) onSubmit,
  }) async {
    await showParsingDialog(
      ui: ui,
      title: title,
      parser: int64ParseFunction,
      onSubmit: onSubmit,
      initialValue: initialValue,
    );
  }
  static Future<void> showDoubleDialog({
    required FlcUi ui,
    required Widget title,
    String initialValue = '',
    required void Function(double value) onSubmit,
  }) async {
    await showParsingDialog(
      ui: ui,
      title: title,
      parser: doubleParseFunction,
      onSubmit: onSubmit,
      initialValue: initialValue,
    );
  }

  static Future<void> showDecimalDialog({
    required FlcUi ui,
    required Widget title,
    String initialValue = '',
    required void Function(Decimal value) onSubmit,
  }) async {
    await showParsingDialog(
      ui: ui,
      title: title,
      parser: decimalParseFunction,
      onSubmit: onSubmit,
      initialValue: initialValue,
    );
  }
}

class ParsingTextController<T extends Object> extends ValidatingTextController {
  final ParseFunction<T> parser;

  late final ParseResult<T> initialParsedValue = parser(initialValue);

  ParsingTextController({
    required this.parser,
    required super.initialValue,
  }) : super(
          watchValidate: (value) => parser(value).errors,
          textProcessor: identity,
        );

  late final validParsedValue = fr(
    () => parser(editingText()).orNull,
  );

  late final validDirtyParsedValue = fr(() {
    final value = validParsedValue();
    if (value == null || value == initialParsedValue) {
      return null;
    }
    return value;
  });
}
