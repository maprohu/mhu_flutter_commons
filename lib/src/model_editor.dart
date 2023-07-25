import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_flutter_commons/src/widgets.dart';

import 'frp.dart';
import 'pb_fw_edit/proto_edit_frp.dart';

extension CommonsPfeConfigX on PfeConfig {
  PfeConfig withCommons() {
    return rebuild(
      (builder) {
        builder
            .configure(CmnColorThemeMsg$.seedColor)
            .fieldEditor((editor, input) {
          return Builder(
            builder: (context) {
              return flcFrr(() {
                final value = Color(input()).withOpacity(1);

                final title = 'Theme Color'.txt;
                return ListTile(
                  title: title,
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Colors.black,
                          ),
                          color: value,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    editor.ui.showDialog((popper) {
                      var color = value;
                      return AlertDialog(
                        title: title,
                        content: SingleChildScrollView(
                          child: MaterialPicker(
                            pickerColor: value,
                            onColorChanged: (value) {
                              color = value;
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              popper.pop();
                              input.value = color.value;
                            },
                            child: 'OK'.txt,
                          ),
                        ],
                      );
                    });
                  },
                );
              });
            },
          );
        });

      },
    );
  }
}

