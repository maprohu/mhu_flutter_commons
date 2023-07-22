import 'package:go_router/go_router.dart';
import 'package:mhu_dart_commons/commons.dart';

extension RouteBaseX on RouteBase {
  String get path => switch (this) {
        GoRoute(:final path) => path,
        _ => throw this,
      };

  String get label => path.substring(1).camelCaseToLabel;
}
