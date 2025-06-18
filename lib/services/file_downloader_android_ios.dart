import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'file_downloader.dart';

class FileDownloader {
  static Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    final provider = Provider.of<DownloaderProvider>(context, listen: false);

    try {
      provider.startDownload(url);

      String savePath;

      if (io.Platform.isAndroid) {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final androidInfo = await deviceInfoPlugin.androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        print('Android SDK version: $sdkInt');
        print('Android version release: ${androidInfo.version.release}');

        // Permission handling based on SDK version
        if (sdkInt >= 33) {
          var status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Storage permission denied")),
            );
            return;
          }
        } else {
          // Android 12 and below
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Storage permission denied")),
            );
            return;
          }
        }

        final dir = await getExternalStorageDirectory();
        if (dir == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cannot access storage directory")),
          );
          return;
        }
        savePath = "${dir.path}/$fileName";
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = "${dir.path}/$fileName";
      }

      // Download the file
      final dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total) * 100;
            onProgress?.call(progress);
            provider.updateProgress(progress);
          }
        },
      );

      provider.completeDownload();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File downloaded to $savePath")),
      );
    } catch (e) {
      provider.failDownload(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }
}
