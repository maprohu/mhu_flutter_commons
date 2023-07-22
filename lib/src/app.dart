import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/src/package_info.dart';
import 'package:mhu_flutter_commons/src/widgets.dart';

import 'bottom_menu.dart';
import 'frp.dart';
import 'model.dart';

part 'app.freezed.dart';


@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String id,
    required String title,
    String? webClientId,
  }) = _AppConfig;
}

typedef Nav = GlobalKey<NavigatorState>;
typedef Messenger = GlobalKey<ScaffoldMessengerState>;

extension NavX on Nav {
  BuildContext get context => currentContext!;

  NavigatorState get state => currentState!;

  void pop<T>([T? result]) => currentState!.pop(result);

  Future<T?> push<T>(Widget widget) => currentState!.push(
        MaterialPageRoute(
          builder: (context) => widget,
        ),
      );
}

extension AppScaffoldMessengerStateX on ScaffoldMessengerState {
  void showException(dynamic e) {
    showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        duration: const Duration(days: 365),
        showCloseIcon: true,
      ),
    );
  }

  void showMessage(String message) {
    showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
      ),
    );
  }
}

extension AppBuildContextX on BuildContext {
  void showMessage(String message) {
    ScaffoldMessenger.of(this).showMessage(message);
  }

  void showException(dynamic e) {
    ScaffoldMessenger.of(this).showException(e);
  }

  Popper popper() {
    return Popper(
      pop: ([result]) => Navigator.pop(this, result),
    );
  }
}

extension MessengerX on Messenger {
  ScaffoldMessengerState get state => currentState!;

  void showException(dynamic e) {
    final state = currentState;

    if (state != null) {
      state.showException(e);
    }
  }

  void showMessage(String e) {
    final state = currentState;

    if (state != null) {
      state.showMessage(e);
    }
  }
}

typedef PopperBuilder<W, T> = W Function(Popper<T> popper);

@freezed
class Popper<T> with _$Popper<T> {
  const Popper._();

  const factory Popper({
    required void Function([T? result]) pop,
  }) = _Popper;

  T popWithSync(T Function() result) {
    try {
      final value = result();
      pop(value);
      return value;
    } catch (_) {
      pop();
      rethrow;
    }
  }

  Future<T> popWith(FutureOr<T> Function() result) async {
    try {
      final value = await result();
      pop(value);
      return value;
    } catch (_) {
      pop();
      rethrow;
    }
  }
}

// @freezed
// class Cancellation with _$Cancellation {
//   factory Cancellation() = _Cancellation;
//
//   final canCancelProcessFw = fw(true);
//
//   final cancelCompleter = Completer();
//
//   late final cancelledFr = fw(false).also((cancelled) {
//     () async {
//       await cancelCompleter.future;
//       cancelled.value = true;
//     }();
//   });
//
//   late final cancelActionAvailableFr = fr(
//     () => canCancelProcessFw() && !cancelledFr(),
//   );
//
//   late final cancelledFuture = cancelCompleter.future;
// }

mixin HasFlcUi {
  FlcUi get ui;

  late final context = ui.navigator.context;
}

class FlcUi {
  final Nav nav;
  final GoRouter? goRouter;

  final messenger = Messenger();
  final themeConfig = fw(defaultCmnColorThemeMsg);

  NavigatorState get navigator => nav.state;

  BuildContext get context => nav.currentContext!;

  Future<T?> push<T>(
    Route<T> Function(Popper<T> popper) pusher,
  ) async {
    T? currentResult;
    final disposers = DspImpl();
    final popper = Popper<T>(
      pop: ([result]) {
        currentResult ??= result;
        disposers.dispose();
      },
    );
    final route = pusher(popper);
    final poppedFuture = navigator.push(route);

    disposers.add(() {
      if (route.isActive) {
        navigator.popUntil((r) => r == route);
        navigator.pop(currentResult);
      }
    });

    return await poppedFuture;
  }

  Future<T?> pushWidget<T>(
    Widget Function(Popper<T> popper) builder,
  ) {
    return push(
      (popper) {
        final widget = builder(popper);
        return MaterialPageRoute(
          builder: (context) => widget,
        );
      },
    );
  }

  Future<T?> showBottomSheet<T>(
    Widget Function(Popper<T> popper) builder, {
    Color? modalBarrierColor,
  }) {
    return push(
      (popper) {
        final sheet = builder(popper);
        return ModalBottomSheetRoute(
          builder: (context) => sheet,
          isScrollControlled: true,
          modalBarrierColor: modalBarrierColor,
        );
      },
    );
  }

  Future<T?> showBottomMenu<T>(
    List<Widget> Function(Popper<T> popper) items, {
    Color? modalBarrierColor,
  }) {
    return showBottomSheet(
      (popper) => flcBottomMenu(
        items(popper),
      ),
      modalBarrierColor: modalBarrierColor,
    );
  }

  Widget showBottomMenuIconButton(
    PopperBuilder<List<Widget>, void>? builder, {
    Color? modalBarrierColor,
    Future<void> Function(Future<void> Function() show)? shower,
  }) {
    final effectiveShower = shower ?? (show) => show();
    return IconButton(
      icon: Builder(builder: (context) {
        final iconTheme = IconTheme.of(context);
        final iconSize = iconTheme.size ?? 24;
        return SvgPicture.asset(
          'assets/icons/bottom_panel_open.svg',
          package: packageName,
          colorFilter: ColorFilter.mode(
            iconTheme.color ?? Colors.white,
            BlendMode.srcIn,
          ),
          width: iconSize,
          height: iconSize,
        );
      }),
      onPressed: builder == null
          ? null
          : () {
              effectiveShower(
                () => showBottomMenu(
                  builder,
                  modalBarrierColor: modalBarrierColor,
                ),
              );
            },
    );
  }

  Future<T?> showDialog<T>(
    PopperBuilder<Widget, T> builder, {
    bool barrierDismissible = true,
  }) {
    return push(
      (popper) {
        final dialog = builder(popper);
        return DialogRoute(
          context: nav.context,
          builder: (context) => dialog,
          barrierDismissible: barrierDismissible,
        );
      },
    );
  }

  Future<T?> showConfirmDialog<T>({
    required Widget title,
    required FutureOr<T> Function() onConfirm,
  }) {
    return showDialog(
      (popper) => AlertDialog(
        title: title,
        actions: [
          TextButton(
            onPressed: popper.pop,
            child: 'Cancel'.txt,
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await onConfirm();
              popper.pop(result);
            },
            child: 'OK'.txt,
          ),
        ],
      ),
    );
  }

  FlcUi._({
    required this.nav,
    this.goRouter,
  });

  static FlcUi create({
    Nav? nav,
    GoRouter? goRouter,
  }) {
    nav ??= Nav();

    final ui = FlcUi._(
      nav: nav,
      goRouter: goRouter,
    );

    ui.bindErrorReporting();

    return ui;
  }

  void bindErrorReporting() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      try {
        messenger.showException(details.exception);
      } catch (_) {}
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      try {
        messenger.showException(exception);
      } catch (_) {}
      return false;
    };
  }

  void go(String location) {
    goRouter!.go(location);
  }

  Future<T?> processCancellable<T>({
    required Widget title,
    required Future<T> Function() process,
  }) {
    return push((popper) {
      popper.popWith(process);

      return DialogRoute(
        context: nav.context,
        builder: (context) {
          return AlertDialog(
            title: title,
            actions: [
              flcFrr(
                () => TextButton(
                  onPressed: popper.pop,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          );
        },
        barrierDismissible: false,
      );
    });
  }

  Future<T?> process<T>({
    required Widget title,
    required Future<T> Function() process,
  }) {
    return push((popper) {
      popper.popWith(process);

      return DialogRoute(
        context: nav.context,
        builder: (context) {
          return WillPopScope(
            child: AlertDialog(
              title: title,
            ),
            onWillPop: () async => false,
          );
        },
        barrierDismissible: false,
      );
    });
  }
}

bool flcMounted(BuildContext context) => context.mounted;
