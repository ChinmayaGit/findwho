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


  Widget authCheck() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return customToast(
            msg: 'Error: ${snapshot.error}',
            context: context,
          );
        } else {
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
      )); // Show loading indicator while fetching data
    }  else {
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
class AuthPageUpdater extends GetxController {
  RxBool signUp = false.obs;
  RxBool loading = false.obs;
}
// Future<void> checkInGame() async {
//   String? inGame = authQuerySnapshot.data()!["inGame"];
//   invitationCode = authQuerySnapshot.data()!["inviteId"];
//   if (inGame == "true") {
//     print("chinu");
//     print(zone['PlayerCount']);
//     await getZone();
//     print(zone['PlayerCount']);
//     noOfPlayer = zone['PlayerCount'];
//     await getZoneGame();
//     await getZoneUserData();
//     await fetchDataIfGameClosed();
//     await fetchSolutionIfGameClosed();
//     Get.to(() => const Home());
//   } else if (inGame == "waiting") {
//     await getZone();
//     noOfPlayer = zone['PlayerCount'];
//     await getZoneGame();
//     await getZoneUserData();
//     Get.to(() => const WaitingLobby());
//   } else {
//     Get.to(() => SelectBoard());
//   }
// }
