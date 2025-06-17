import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/image_picker.dart';

class ProfilePicProvider extends ChangeNotifier {

  String imagePath = '';

  Future<void> pickImage(BuildContext context) async {
    String pickedImage = await ImagePickerProvider.pickImage(context);
    imagePath=pickedImage;
    notifyListeners();
  }

  void clearImage() {
    imagePath = '';
    notifyListeners();
  }


  Future<Map<String, dynamic>> uploadImageToFirebase(File imageFile) async {
    String responseData = '';
    bool isSuccess = false;

    try {

      FirebaseStorage storage = FirebaseStorage.instance;

      String fileName = basename(imageFile.path);

      Reference ref = storage.ref().child('images/$fileName');

      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      responseData = 'Image successfully uploaded!';
      isSuccess = true;

      return {
        'responseData': responseData,
        'isSuccess': isSuccess,
        'imageUrl': imageUrl
      };
    } catch (e) {
      responseData = 'Error uploading image: $e';
      print('Error uploading image: $e');
      isSuccess = false;
      return {
        'responseData': responseData,
        'isSuccess': isSuccess,
        'imageUrl': null
      };
    }
  }



}
