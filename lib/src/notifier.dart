import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

ValueListenable<List<T>> listOfValueListenables<T>(
    List<ValueListenable<T>> listenables) {
  final result = ValueNotifier<List<T>>(
    List.unmodifiable(
      listenables.map((e) => e.value),
    ),
  );

  listenables.forEachIndexed(
    (index, element) {
      element.addListener(() {
        final value = element.value;
        final values = List.of(result.value);
        values[index] = value;
        result.value = List.unmodifiable(values);
      });
    },
  );

  return result;
}
