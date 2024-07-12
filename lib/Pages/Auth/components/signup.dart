import 'package:findwho/components/game_status.dart';
import 'package:findwho/components/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      "inGame": GameStatusManager.idle,
      "uid": userCredential.user!.uid,
      "inviteId": "0000",
    });
    return "true";
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  } catch (e) {
    print(e);
  }
}