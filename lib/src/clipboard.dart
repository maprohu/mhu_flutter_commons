
import 'package:flutter/services.dart';

Future<String?> getStringFromClipboard() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text;
}