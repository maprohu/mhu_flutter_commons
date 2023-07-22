import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'image.dart';

class FileStoreImageProvider extends ImageProvider<FileStoreImageProvider> {
  final FileStore fileStore;
  final FilePath path;

  @override
  Future<FileStoreImageProvider> obtainKey(
          ImageConfiguration configuration) async =>
      this;

  Future<ImageInfo> imageInfo() async {
    return ImageInfo(
      image: await uiImage(
        await fileStore.read(
          path,
        ),
      ),
    );
  }

  @override
  ImageStreamCompleter loadImage(
      FileStoreImageProvider key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(key.imageInfo());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileStoreImageProvider &&
          runtimeType == other.runtimeType &&
          fileStore == other.fileStore &&
          path == other.path;

  @override
  int get hashCode => fileStore.hashCode ^ path.hashCode;

  FileStoreImageProvider({
    required this.fileStore,
    required this.path,
  });
}

FileLoader<K> flcCachedFileLoader<K>({
  required FileLoader<K> loader,
  required FileStore store,
  required FilePath Function(K key) pathProvider,
}) {
  final cache = Cache<K, Future<Future<Uint8List> Function()>>(
    (key) async {
      final path = pathProvider(key);

      if (!await store.exists(path)) {
        final data = await loader(key);
        await store.write(path, data);
      }

      return () => store.read(path);
    },
  );

  return (path) async {
    final fn = await cache.get(path);
    return await fn();
  };
}

class FileLoaderImageProvider<K>
    extends ImageProvider<FileLoaderImageProvider<K>> {
  final FileLoader<K> loader;
  final K key;

  @override
  Future<FileLoaderImageProvider<K>> obtainKey(
          ImageConfiguration configuration) async =>
      this;

  Future<ImageInfo> imageInfo() async {
    return ImageInfo(
      image: await uiImage(await loader(key)),
    );
  }

  @override
  ImageStreamCompleter loadImage(
      FileLoaderImageProvider<K> key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(key.imageInfo());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileLoaderImageProvider<K> &&
          runtimeType == other.runtimeType &&
          loader == other.loader &&
          key == other.key;

  @override
  int get hashCode => loader.hashCode ^ key.hashCode;

  FileLoaderImageProvider({
    required this.loader,
    required this.key,
  });
}
