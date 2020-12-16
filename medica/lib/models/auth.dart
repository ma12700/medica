import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'http_exception.dart';

class Auth {
  static String type;
  static String userName = '';
  static String userId;
  static UserCredential userCredential;
  static DatabaseReference database = FirebaseDatabase.instance.reference();

  static Future<bool> login(String email, String password) async {
    try {
      await Firebase.initializeApp();
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userId = userCredential.user.uid;
      await database
          .child('users/$userId')
          .once()
          .then((DataSnapshot snapshot) {
        type = snapshot.value['type'];
        userName = snapshot.value['name'];
      });
    } on FirebaseAuthException catch (e) {
      HttpException(e.code);
    }
    return true;
  }

  static Future<bool> signup(String email, String password, String name) async {
    userName = name;
    try {
      await Firebase.initializeApp();
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userId = userCredential.user.uid;
      await database.child('users/$userId').update({
        'name': userName,
        'type': 'patient',
      });
    } on FirebaseAuthException catch (e) {
      HttpException(e.code);
    }
    return true;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
