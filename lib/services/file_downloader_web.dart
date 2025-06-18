import 'package:flutter/material.dart';
import 'dart:html' as html;

class FileDownloader {
  static Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download started in browser")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Web download failed: $e")),
      );
    }
  }
}
