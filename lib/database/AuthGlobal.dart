import 'package:findwho/components/toast.dart';
import 'package:findwho/database/Global.dart';
import 'package:findwho/login/AuthPage.dart';
import 'package:findwho/room/HomePage.dart';
import 'package:findwho/lobby/SelectBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> getUserData() async {
  authQuerySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid)
      .get();
  authId=authQuerySnapshot.data()!["uid"];
  await checkPlace();
}

Widget authCheck() {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else {
        if (snapshot.hasData && snapshot.data != null) {
          getUserData();
          return const Center(child: CircularProgressIndicator());
        } else {
          return const AuthPage();
        }
      }
    },
  );
}

signUp(
    {required String name, required String password, required context}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: "$name@gmail.com", password: password)
        .then((value) {
      customToast(msg: 'Welcome to findWho', context: context);
      return value;
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
      "userName": "$name@gmail.com",
      "pass": password,
      "time": DateTime.now(),
      "inGame": "false",
      "uid": userCredential.user!.uid,
      "inviteId":"0000",
    });
    return "true";
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  } catch (e) {
    print(e);
  }
}

signIn(
    {required String name, required String password, required context}) async {
  try {
    // UserCredential userCredential = await FirebaseAuth.instance
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: "$name@gmail.com", password: password)
        .then((value) {
      customToast(msg: 'Welcome to findWho', context: context);
      return value;
    });
    return "true";
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  }
}
