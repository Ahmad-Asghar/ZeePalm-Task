import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference fireStore =
      FirebaseFirestore.instance.collection("Users");

  Future<dynamic> login(String email, String password) async {
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials;
    } catch (e) {
      return e.toString();
    }
  }


}
