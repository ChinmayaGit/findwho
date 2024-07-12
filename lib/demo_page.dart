// import 'package:findwho/Pages/Auth/AuthPage.dart';
// import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
// import 'package:findwho/Pages/Auth/components/user_data_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//  // Import your UserData
//
// Widget checkGameStatus() {
//   final UserController userController = Get.put(UserController());
//
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Check Game Status'),
//     ),
//     body: Center(
//       child: Obx(() {
//         var userData = userController.userData.value;
//         var isLoading = userController.isLoading.value;
//
//         if (isLoading) {
//           return CircularProgressIndicator(); // Show loading indicator while fetching data
//         } else if (userData == null) {
//           return Text('User data not available'); // Handle case where userData is null
//         } else {
//           String? gameStatus = userData.inGame;
//           print("Game Status: $gameStatus");
//
//           if (gameStatus == 'activeGame') {
//             return UserPage(); // Replace with your Home widget
//           } else if (gameStatus == 'waiting') {
//             return AuthPage(); // Replace with your WaitingLobby widget
//           } else {
//             return UserPage(); // Replace with your SelectBoard widget
//           }
//         }
//       }),
//     ),
//   );
// }
// class UserPage extends StatelessWidget {
//   final UserController userController = Get.put(UserController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Details'),
//       ),
//       body: Center(
//         child: Obx(
//               () {
//             var userData = userController.userData.value;
//             if (userData == null) {
//               return CircularProgressIndicator(); // Show loading indicator while fetching data
//             } else {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     userData.userName,
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text('In Game: ${userData.inGame}'),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Example of updating user data
//                       var updatedUserData = UserData(
//                         inGame: "se",
//                         inviteId: userData.inviteId,
//                         pass: userData.pass, // Example of changing password
//                         time: userData.time,
//                         uid: userData.uid,
//                         userName: userData.userName,
//                       );
//                       userController.updateUser(updatedUserData);
//                     },
//                     child: Text('Update Password'),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }