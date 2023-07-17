import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import 'package:mhu_dart_commons/commons.dart';

import 'image.dart';

class AverageAspectRatio<K> {
  final DspReg _disposers;

  AverageAspectRatio(this._disposers);

  final _processedKeys = <K>{};

  late final _aspectsRx = fw(
    IMap<K, Size>(),
    disposers: _disposers,
  );

  late final rx = _aspectsRx.map(
    (v) => v.isEmpty ? 1.0 : v.values.map((e) => e.aspectRatio).average,
  );

  void addImage(
    K key,
    UiImageProvider image,
  ) {
    addSize(
      key,
      () async {
        return (await image()).size;
      },
    );
  }

  void addSize(
    K key,
    Future<Size> Function() size,
  ) {
    if (!_processedKeys.contains(key)) {
      _processedKeys.add(key);

      () async {
        final imageSync = await size();
        if (_disposers.isDisposed) {
          return;
        }
        _aspectsRx.update(
          (value) => value.add(key, imageSync),
        );
      }();
    }
  }

  Size? getSize(K key) => _aspectsRx.value.get(key);
}

extension AspectSizeX on Size {
  double get aspectRatio => width / height;
}

AverageAspectRatio<K> flcAverageAspectRatio<K>({
  required DspReg disposers,
}) {
  return AverageAspectRatio(disposers);
}

void flcListenImageProviderFirstImage({
  required ImageProvider imageProvider,
  required BuildContext context,
  required FutureOr<void> Function(ImageInfo image) listener,
}) {
  late final ImageStreamListener streamListener;

  final imageStream = imageProvider.resolve(
    createLocalImageConfiguration(context),
  );

  streamListener = ImageStreamListener((image, synchronousCall) async {
    imageStream.removeListener(streamListener);

    try {
      await listener(image);
    } finally {
      image.dispose();
    }
  });

  imageStream.addListener(streamListener);
}

extension FlcImageProviderX on ImageProvider {
  void listenFirst(
    BuildContext context,
    FutureOr<void> Function(ImageInfo image) listener,
  ) =>
      flcListenImageProviderFirstImage(
        imageProvider: this,
        context: context,
        listener: listener,
      );

  Future<T> processFirst<T>(
    BuildContext context,
    FutureOr<T> Function(ImageInfo image) listener,
  ) {
    final completer = Completer<T>();
    listenFirst(
      context,
      (image) async {
        await completer.completeWith(
          () => listener(image),
        );
      },
    );
    return completer.future;
  }
}
