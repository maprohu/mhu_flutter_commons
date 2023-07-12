import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:rxdart/rxdart.dart';

class SubjectBuilder<T extends Object> extends StatelessWidget {
  final BehaviorSubject<T> subject;
  final Widget Function(BuildContext context, T value) builder;

  SubjectBuilder({
    super.key,
    required this.subject,
    required this.builder,
  }) {
    assert(subject.hasValue);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: subject.value,
      stream: subject,
      builder: (context, snapshot) {
        final data = snapshot.requireData;
        return builder(context, data);
      },
    );
  }
}

class RxBuilder<T> extends StatelessWidget {
  final RxVal<T> rxVal;
  final Widget Function(BuildContext context, T value) builder;

  const RxBuilder({
    super.key,
    required this.rxVal,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: rxVal.value,
      stream: rxVal.stream,
      builder: (context, snapshot) {
        final data = snapshot.data as T;
        return builder(context, data);
      },
    );
  }
}
