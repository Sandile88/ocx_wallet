import 'package:flutter/services.dart';

class ClipboardUtil {
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}