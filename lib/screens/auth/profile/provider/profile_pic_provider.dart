import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../widgets/image_picker.dart';

class ProfilePicProvider extends ChangeNotifier {
  String imagePath = '';
  Uint8List? webImageBytes;

Future<void> pickImage(BuildContext context) async {
  final result = await ImagePickerProvider.pickImageCrossPlatform(context);

  if (kIsWeb) {
    if (result != null) {
      webImageBytes = result;
      debugPrint('Web image bytes set. Length: ${webImageBytes?.length}');
      notifyListeners();
    } else {
      debugPrint('No image picked on web.');
    }
  } else {
    if (result != null && result is String) {
      imagePath = result;
      debugPrint('Image path set: $imagePath');
      notifyListeners();
    } else {
      debugPrint('No image picked on mobile.');
    }
  }
}

  void clearImage() {
    imagePath = '';
    webImageBytes = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> uploadImageToFirebase(BuildContext context) async {
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
        showSnackBar(context, 'No image selected to upload.');
        throw Exception('No image selected to upload.');
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      responseData = 'Image successfully uploaded!';
      isSuccess = true;
    } catch (e) {
      showSnackBar(context, 'Error uploading image: $e');
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
