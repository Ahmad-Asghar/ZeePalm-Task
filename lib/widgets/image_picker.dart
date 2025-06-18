import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePickerProvider {
  static Future<dynamic> pickImageCrossPlatform(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: kIsWeb, // for web, get bytes
    );

    if (result != null) {
      if (kIsWeb) {
        return result.files.first.bytes;
      } else {
        return result.files.first.path;
      }
    } else {
      return null;
    }
  }
}
