import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_rv/domain/user_model.dart';

class FirebaseAuthService {
  Future<(String?, UserModel?)> login({
    required String email,
    required String password,
  }) async {
    UserCredential? credentials;

    try {
      //------------------------------------------sign in
      credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());

      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       duration: Duration(seconds: 2),
      //       width: 300,
      //       behavior: SnackBarBehavior.floating,
      //       content: Text(e.code.toString())));

      return (e.code.toString(), null);
    }

    if (credentials != null) {
      //----------------------------------------get uid

      String uid = credentials.user!.uid;

      //---------------------------get user details by uid
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      //-------------convert received data to model.
      UserModel user =
          UserModel.fromJson(userData.data() as Map<String, dynamic>);

      return (null, user);
    }

    return ('Some error happened', null);
  }

  Future<String> register(
    {required String email,
    required String password,
    required String fullname}) async {
  UserCredential? credentials;
  try {
    credentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    log(e.code.toString());

    return e.message.toString();
  }

  if (credentials != null) {
    //--------------------------------------------get uid after signup
    final String uid = credentials.user!.uid;

    //----------------------------------generate usermodel
    UserModel user = UserModel(
      uid: uid,
      fullname: fullname,
      email: email,
    );

    //------------------------------------save to firestone
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(user.toJson())
        .then((value) {
      log('New user created');
    });

    return '';
  }

  return 'Error Occured while creating account';
}

}

