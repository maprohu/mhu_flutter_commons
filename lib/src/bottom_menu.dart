import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget flcBottomMenu(
  List<Widget> items,
) {
  return SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    ),
  );
}


