import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'textfield.freezed.dart';

extension TextEditingControllerX on TextEditingController {
  void selectAll() => selection = TextSelection(
        baseOffset: 0,
        extentOffset: value.text.length,
      );
}

class ValidatingTextController {
  final String initialValue;
  final Iterable<String> Function(String value) validator;
  final String Function(String value) textProcessor;

  static Iterable<String> defaultValidator(String value) => [
        if (value.isEmpty) 'Must provide a value',
      ];

  static String defaultTextProcessor(String value) => value.trim();

  ValidatingTextController({
    required String initialValue,
    this.validator = defaultValidator,
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
    final errors = validator(text);
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
    Iterable<String> Function(String value) validator =
        ValidatingTextController.defaultValidator,
    String Function(String value) textProcessor =
        ValidatingTextController.defaultTextProcessor,
  }) async {
    final controller = ValidatingTextController(
      initialValue: initialValue,
      validator: validator,
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
    required ParseResult<T> Function(String value) parser,
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
}

@freezed
sealed class ParseResult<T extends Object> with _$ParseResult<T> {
  const factory ParseResult.success({
    required T result,
  }) = ParseSuccess<T>;

  const factory ParseResult.failure({
    required Iterable<String> errors,
  }) = ParseFailure<T>;

  T? get orNull {
    switch (this) {
      case ParseFailure():
        return null;
      case ParseSuccess(:final result):
        return result;
    }
  }
}

extension ParseResultT<T extends Object> on ParseResult<T> {
  Iterable<String> get errors => switch (this) {
        ParseSuccess() => const Iterable.empty(),
        ParseFailure(:final errors) => errors,
      };
}

class ParsingTextController<T extends Object> extends ValidatingTextController {
  final ParseResult<T> Function(String value) parser;

  late final ParseResult<T> initialParsedValue = parser(initialValue);

  ParsingTextController({
    required this.parser,
    required super.initialValue,
  }) : super(
          validator: (value) => parser(value).errors,
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
