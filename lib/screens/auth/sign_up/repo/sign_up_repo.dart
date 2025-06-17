import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../profile/model/user_model.dart';

class SignUpRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference fireStore =FirebaseFirestore.instance.collection("Users");


  Future<dynamic> signUp(String email, String password) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> addNewUser(UserModel userModel,UserCredential credentials) async {
    try {
      await fireStore.doc(credentials.user?.uid.toString()).set(userModel.toJson());
      return true;
    } catch (e) {
      return e.toString();
    }
  }


}
