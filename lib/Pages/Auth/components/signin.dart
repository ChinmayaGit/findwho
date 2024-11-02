import 'package:firebase_auth/firebase_auth.dart';

import 'package:findwho/components/toast.dart';
signIn(
    {required String name, required String password, required context}) async {
  try {
    // Check if the email has '@gmail.com', if not, append it
    String email = name.contains('@gmail.com') ? name : "$name@gmail.com";

    // Use the corrected email to sign in
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
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
