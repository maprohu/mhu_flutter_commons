import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/src/stream.dart';
import 'package:rxdart/rxdart.dart';

import 'aspect_ratio.dart';
import 'frp.dart';
import 'widgets.dart';

Widget flcGrowableListView<V>({
  required Stream<IList<V>> Function(int size) take,
  required ValueBuilder<V> itemBuilder,
  int pageSize = 16,
  String emptyMessage = 'No items found.',
}) {
  return flcAsyncDisposeWidget(
    waiting: busyWidget,
    builder: (disposers) async {
      final maxRequestedIndex = fw(
        0,
        disposers: disposers,
      );

      void requestIndex(int index) {
        maxRequestedIndex.value = max(maxRequestedIndex.value, index);
      }

      final maxRequestedHeadSize =
          maxRequestedIndex.map((i) => i - i % pageSize + pageSize * 2);

      final Stream<IList<V>> requestedItems =
          maxRequestedHeadSize.changes().switchMap(take);

      final requestedItemsVar = await requestedItems.fr(disposers);

      return flcFrr(() {
        final items = requestedItemsVar();
        if (items.isEmpty) {
          return Center(
            child: emptyMessage.txt,
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            requestIndex(index);
            final item = items[index];
            return itemBuilder(context, item);
          },
        );
      });
    },
  );
}

Widget flcGrowableGridView<K, V>({
  required Stream<IList<V>> Function(int size) take,
  required Widget Function(
          BuildContext context, V value, AverageAspectRatio<K> aspectRatio)
      itemBuilder,
  required Fr<int> columnCount,
  double padding = 4.0,
}) {
  return flcDsp((disposers) {
    final aspectRatios = flcAverageAspectRatio<K>(disposers: disposers);
    late final maxRequestedIndex = fw(0, disposers: disposers);
    return flcFrr(
      () {
        final aspectRatio = aspectRatios.rx();
        return columnCount.frWidget(
          (columnCount) {
            final pageSize = (columnCount * columnCount) + 4;

            void requestIndex(int index) {
              maxRequestedIndex.value = max(maxRequestedIndex.value, index);
            }

            late final maxRequestedHeadSize =
                maxRequestedIndex.map((i) => i - i % pageSize + pageSize * 2);

            late final Stream<IList<V>> requestedItems =
                maxRequestedHeadSize.changes().switchMap(take);

            return requestedItems.streamBuilder(
              (context, items) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: padding,
                  mainAxisSpacing: padding,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  requestIndex(index);

                  final info = items[index];

                  return itemBuilder(context, info, aspectRatios);
                },
                padding: EdgeInsets.all(padding),
              ),
            );
          },
        ).withKey(aspectRatio);
      },
    );
  });
}

List<Widget> flcGridColumnCountMenuButtons({
  required Fr<int> columnCount,
  required void Function(int) setter,
}) {
  return [
    flcFrr(() {
      final count = columnCount();
      return TextButton(
        onPressed: () {
          setter(count + 1);
        },
        child: const Text('More Columns'),
      );
    }),
    flcFrr(() {
      final count = columnCount();

      return TextButton(
        onPressed: count > 1
            ? () {
                setter(count - 1);
              }
            : null,
        child: const Text('Less Columns'),
      );
    }),
  ];
}
