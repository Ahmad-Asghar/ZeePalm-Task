export 'file_downloader_stub.dart'
    if (dart.library.html) 'file_downloader_web.dart'
    if (dart.library.io) 'file_downloader_android_ios.dart';

import 'package:flutter/material.dart';

enum DownloadStatus { idle, downloading, success, error }

class DownloaderProvider extends ChangeNotifier {
  DownloadStatus _status = DownloadStatus.idle;
  double _progress = 0.0;
  String? _errorMessage;
  String? _currentFileName;

  DownloadStatus get status => _status;
  double get progress => _progress;
  String? get errorMessage => _errorMessage;
  String? get currentFileName => _currentFileName;

  void startDownload(String currentFileName) {
    _currentFileName = currentFileName;
    _status = DownloadStatus.downloading;
    _progress = 0.0;
    _errorMessage = null;
    notifyListeners();
  }

  void updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void completeDownload() {
    _status = DownloadStatus.success;
    _progress = 100.0;
    notifyListeners();
  }

  void failDownload(String error) {
    _status = DownloadStatus.error;
    _errorMessage = error;
    notifyListeners();
  }

  void reset() {
    _status = DownloadStatus.idle;
    _progress = 0.0;
    _errorMessage = null;
    notifyListeners();
  }
}
