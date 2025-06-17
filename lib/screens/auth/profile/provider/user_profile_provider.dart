import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:zeepalm_task/screens/auth/profile/provider/profile_pic_provider.dart';

import '../../../../core/utils/user_pref_utils.dart';
import '../../../../core/utils/validation_utils.dart';
import '../model/user_model.dart';
import '../repo/user_profile_repo.dart';

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

     if(result is UserModel){
       userModel = result;
       isLoading = false;
       notifyListeners();

     }
     else if(result is String){
       isLoading=false;
       notifyListeners();

     }
  }

  Future<void> updateUserImage(String image,BuildContext context)async {
    isUpdating = true;
    notifyListeners();
         profilePicProvider. uploadImageToFirebase(File(image)).then((result) async {
      if (result['isSuccess']) {
        userModel.picture=result['imageUrl'];
        bool updateModel = await updateUser(userModel);
        if(updateModel){
          isUpdating = false;
          notifyListeners();
          showSnackBar(context, result['responseData']);
        }else{
          isUpdating = false;
          notifyListeners();
          return ;
        }
      } else {
        isUpdating = false;
        notifyListeners();
        showSnackBar(context, result['responseData'],isError: true);
      }
    });
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
