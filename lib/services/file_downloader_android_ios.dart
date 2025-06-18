import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  static Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      String savePath;

      if (io.Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Storage permission denied")),
          );
          return;
        }
        final dir = await getExternalStorageDirectory();
        if (dir == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cannot access storage directory")),
          );
          return;
        }
        savePath = "${dir.path}/$fileName";
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = "${dir.path}/$fileName";
      }

      final dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress((received / total) * 100);
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File downloaded to $savePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }
}
