import 'package:flutter/material.dart';

import 'package:mhu_dart_commons/commons.dart';

import 'widgets.dart';
import 'frp.dart';
import 'scaffold.dart';

part 'bottom_navigator.freezed.dart';

@freezed
class TabItem with _$TabItem {
  const factory TabItem({
    required IconData icon,
    required String label,
    required ScaffoldParts scaffold,
    @Default(false) bool defaultItem,
  }) = _TabItem;
}

Widget tabbedScaffold({
  required ScaffoldParts scaffold,
  required List<TabItem> items,
}) {
  var defaultIndex = items.indexWhere((element) => element.defaultItem);
  if (defaultIndex == -1) {
    defaultIndex = 0;
  }

  final indexFw = fw(defaultIndex);

  return flcFrr(() {
    final index = indexFw();
    final item = items[index];
    return item.scaffold
        .copyWith(
          bottomNavigatorBar: BottomNavigationBar(
            currentIndex: indexFw(),
            items: items
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  ),
                )
                .toList(),
            onTap: indexFw.set,
          ),
        )
        .scaffold.withKey(index);
  });
}

extension BottomNavigatorScaffoldX on ScaffoldParts {
  Widget tabbed(List<TabItem> items) => tabbedScaffold(
        scaffold: this,
        items: items,
      );
}
