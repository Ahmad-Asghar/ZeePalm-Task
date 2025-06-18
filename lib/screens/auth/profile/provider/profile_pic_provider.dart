import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/image_picker.dart';

class ProfilePicProvider extends ChangeNotifier {
  String imagePath = '';
  Uint8List? webImageBytes;

  Future<void> pickImage(BuildContext context) async {
    final result = await ImagePickerProvider.pickImageCrossPlatform(context);

    if (kIsWeb) {
      if (result != null) {
        webImageBytes = result;
        notifyListeners();
      }
    } else {
      if (result != null && result is String) {
        imagePath = result;
        notifyListeners();
      }
    }
  }

  void clearImage() {
    imagePath = '';
    webImageBytes = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> uploadImageToFirebase() async {
    String responseData = '';
    bool isSuccess = false;
    String? imageUrl;

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('images/$fileName');

      UploadTask uploadTask;

      if (kIsWeb && webImageBytes != null) {
        uploadTask = ref.putData(webImageBytes!);
      } else if (!kIsWeb && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (!file.existsSync()) {
          throw Exception('Selected file does not exist.');
        }
        uploadTask = ref.putFile(file);
      } else {
        throw Exception('No image selected to upload.');
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      responseData = 'Image successfully uploaded!';
      isSuccess = true;
    } catch (e) {
      responseData = 'Error uploading image: $e';
      print(responseData);
    }

    return {
      'responseData': responseData,
      'isSuccess': isSuccess,
      'imageUrl': imageUrl
    };
  }
}
