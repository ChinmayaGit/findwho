import 'package:findwho/Pages/Auth/auth_page.dart';
import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Home/home.dart';
import 'package:findwho/Pages/Lobby/select_board.dart';
import 'package:findwho/Pages/Lobby/waiting_lobby.dart';
import 'package:findwho/components/game_status.dart';
import 'package:findwho/components/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String authUid = FirebaseAuth.instance.currentUser!.uid;

class AuthPageUpdater extends GetxController {
  RxBool signUp = false.obs;
  RxBool loading = false.obs;
}

Widget authCheck() {
  //getting users
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
      //checking internet
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: Text("no internet.."));
      } else if (snapshot.hasError) {
        return customToast(
          msg: 'Error: ${snapshot.error}',
          context: context,
        );
      } else {
        //checking if user exist
        if (snapshot.hasData && snapshot.data != null) {
          return checkGameStatus();
        } else {
          return AuthPage();
        }
      }
    },
  );
}

Widget checkGameStatus() {
  final UserController _userController = Get.put(UserController());
  return Obx(() {
    var userData = _userController.userDataDocument.value;
    var isLoading = _userController.isLoadingUserConroller.value;
    if (isLoading) {
      return const Center(child: Column(
        children: [
          CircularProgressIndicator(),
          Text("AuthPage")
        ],
      ));
    }  else {
      print(userData!.inGame);
      String? gameStatus = userData!.inGame;
      if (gameStatus == GameStatusManager.activeGame) {
        return const Home(); // Replace with your Home widget
      } else if (gameStatus == GameStatusManager.waiting) {
        return const WaitingLobby(); // Replace with your WaitingLobby widget
      } else {
        return SelectBoard(); // Replace with your SelectBoard widget
      }
    }
  }
  );
}




