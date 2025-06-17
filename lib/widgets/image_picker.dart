import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core/utils/app_colors.dart';
import 'app_text.dart';

class ImagePickerProvider {
  static Future<String> pickImage(BuildContext context) async {
    Completer<String> completer = Completer<String>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextWidget(
                title: "Choose Option",
                fontSize: 4.5.w,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                    context,
                    icon: Icons.camera_alt,
                    label:"Take Photo",
                    onTap: () async {
                      Navigator.pop(context);
                      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        completer.complete(pickedFile.path);
                      } else {
                        completer.complete('');
                      }
                    },
                  ),
                  _buildOption(
                    context,
                    icon: Icons.photo_library,
                    label: "Upload Photo",
                    onTap: () async {
                      Navigator.pop(context);
                      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        completer.complete(pickedFile.path);
                      } else {
                        completer.complete('');
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    return completer.future;
  }

  static Widget _buildOption(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryColor,
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 10),
          CustomTextWidget(
            title:  label,
            fontSize: 4.w,
          ),
        ],
      ),
    );
  }
}
