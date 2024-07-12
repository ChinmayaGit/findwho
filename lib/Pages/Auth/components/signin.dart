import 'package:firebase_auth/firebase_auth.dart';

import 'package:findwho/components/toast.dart';

signIn(
    {required String name, required String password, required context}) async {
  try {
    // UserCredential userCredential = await FirebaseAuth.instance
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: "$name@gmail.com", password: password)
        .then(
          (value) {
        customToast(msg: 'Welcome to findWho', context: context);
        return value;
      },
    );
    return "true";
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  }
}