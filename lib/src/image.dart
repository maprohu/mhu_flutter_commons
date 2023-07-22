import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'package:image/image.dart' as img;

part 'image.freezed.dart';

Future<ui.Image> uiImage(Uint8List imageBytes) {
  final imageDecodeCompleter = Completer<ui.Image>();
  ui.decodeImageFromList(
    imageBytes,
    imageDecodeCompleter.complete,
  );
  return imageDecodeCompleter.future;
}

Future<double> uiImageAspectRatio(Uint8List imageBytes) async {
  final image = await uiImage(imageBytes);
  return image.width / image.height;
}

@freezed
class ThumbnailKey<KO> with _$ThumbnailKey<KO> {
  const factory ThumbnailKey({
    required KO original,
    required int width,
  }) = _ThumbnailKey;
}

Future<Uint8List> _resize({
  required Uint8List originalFile,
  required int targetWidth,
}) async {
  final cmd = img.Command()
    ..decodeImage(originalFile)
    ..copyResize(
      width: targetWidth,
      interpolation: img.Interpolation.cubic,
    )
    ..encodeJpg();

  await cmd.executeThread();

  return cmd.outputBytes!;
}

FileLoader<ThumbnailKey<KO>> flcThumbnailLoader<KO>({
  required FileLoader<KO> originalLoader,
}) {
  final queue = TaskQueue(disposers: DspImpl());
  return (key) async {
    return await queue.submit(() async {
      final originalFile = await originalLoader(key.original);
      final targetWidth = key.width;
      return await _resize(
        originalFile: originalFile,
        targetWidth: targetWidth,
      );
    });
  };
}

FileLoader<ThumbnailKey<KO>> flcThumbnailsCache<KO>({
  required FileLoader<KO> originalLoader,
  required FileStore thumbnailStore,
  required FilePathProvider<KO> thumbnailsPathProvider,
}) {
  return flcCachedFileLoader(
    loader: flcThumbnailLoader(originalLoader: originalLoader),
    store: thumbnailStore,
    pathProvider: (key) =>
        thumbnailsPathProvider(key.original).add(key.width.toString()),
  );
}

typedef UiImage = ui.Image;
typedef UiImageProvider = Future<ui.Image> Function();

extension UiImageX on UiImage {
  Size get size => Size(
    width.toDouble(),
    height.toDouble(),
  );
}
