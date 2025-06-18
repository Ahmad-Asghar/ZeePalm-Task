import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../repo/user_profile_repo.dart';
import '../../../../core/utils/user_pref_utils.dart';
import '../../../../core/utils/validation_utils.dart';
import 'profile_pic_provider.dart';

class UserProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isUpdating = false;
  late UserModel userModel;
  UserProfileRepo userProfileRepo = UserProfileRepo();
  ProfilePicProvider profilePicProvider = ProfilePicProvider();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UserProfileProvider() {
    getUser();
  }

  Future<void> getUser() async {
    isLoading = true;
    notifyListeners();

    String? userId = await UserPrefUtils().getUserID();
    var result = await userProfileRepo.getUser(userId!);

    if (result is UserModel) {
      userModel = result;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserImage(BuildContext context) async {
    isUpdating = true;
    notifyListeners();

    var result = await profilePicProvider.uploadImageToFirebase();
    if (result['isSuccess']) {
      userModel.picture = result['imageUrl'];
      bool updateModel = await updateUser(userModel);

      if (updateModel) {
        showSnackBar(context, result['responseData']);
      } else {
        showSnackBar(context, 'Failed to update user.', isError: true);
      }
    } else {
      showSnackBar(context, result['responseData'], isError: true);
    }

    isUpdating = false;
    notifyListeners();
  }

  Future<bool> updateUser(UserModel userModel) async {
    try {
      await _fireStore.collection('Users').doc(userModel.uid).update(userModel.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
