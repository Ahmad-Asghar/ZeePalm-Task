


import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserProfileRepo{

  final CollectionReference fireStore = FirebaseFirestore.instance.collection("Users");

  Future<dynamic> getUser(String userID) async {
    try {
      DocumentSnapshot documentReference = await fireStore
          .doc(userID)
          .get();
      UserModel  userModel = UserModel.fromJson(documentReference.data() as Map<String, dynamic>);
      return userModel;
    } catch (e) {
      return e.toString();
    }
  }



}