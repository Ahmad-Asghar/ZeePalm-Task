import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'file_downloader.dart'; // Import DownloaderProvider

class FileDownloader {
  static Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
    Function(double)? onProgress,
    DownloaderProvider? provider, // Add provider
  }) async {
    try {
      provider?.startDownload(url);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      provider?.completeDownload();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download started in browser")),
      );
    } catch (e) {
      provider?.failDownload(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Web download failed: $e")),
      );
    }
  }
}