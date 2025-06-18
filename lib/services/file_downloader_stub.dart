import 'package:flutter/material.dart';

class FileDownloader {
  static Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Unsupported platform")),
    );
  }
}
