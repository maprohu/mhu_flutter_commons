import 'package:flutter/material.dart';

void showConfirmDialog({
  required BuildContext context,
  required Widget title,
  required void Function() callback,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            callback();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
