import 'package:findwho/Drawer/my_drawer.dart';
import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Lobby/invite_code.dart';
import 'package:findwho/Pages/Lobby/color_dice_picker.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/toast.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:findwho/database/offline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'waiting_lobby.dart';

class SelectBoard extends StatelessWidget {
  SelectBoard({super.key});

  int noOfPlayer = 0;
  final RxBool createWait = false.obs;
  final CountController countController = Get.put(CountController());

  // final UserController _userController = Get.put(UserController());
  customCard(
      {required String text,
      required String img,
      required bool inProgress,
      context}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          foregroundDecoration: inProgress == true
              ? BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                )
              : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            image: DecorationImage(
              image: AssetImage(img),
              // Provide the path to your image asset
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Adjust opacity as needed
                BlendMode.darken, // You can also try BlendMode.multiply
              ), // Adjust the fit as per your requirement
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (inProgress == false) {
                                  countController.count.value >= 3
                                      ? countController.decrement()
                                      : 0;
                                }
                              },
                              child: CircleAvatar(child: Icon(Icons.remove)),
                            ),
                            Spacer(),
                            Obx(() => Container(
                                  child: Text(
                                    countController.count.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (inProgress == false) {
                                  countController.count.value <= 3
                                      ? countController.increment()
                                      : 0;
                                }
                              },
                              child: CircleAvatar(child: Icon(Icons.add)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: createWait.value == false
                            ? GestureDetector(
                                onTap: () async {
                                  if (inProgress == false) {
                                    createWait.value = true;
                                    noOfPlayer = countController.count.value;
                                    invitationCode = generateInvitationCode();
                                    print(noOfPlayer);
                                    Get.to(() =>
                                        ColorDicePicker(maxPlayer: noOfPlayer));
                                  } else {
                                    customToast(
                                        msg: "This mode is in development",
                                        context: context);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      color: Colors.white),
                                  child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Create"),
                                      SizedBox(width: 15),
                                      Icon(Icons.arrow_forward_ios_sharp),
                                    ],
                                  ),
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (inProgress == false) {
                              noOfPlayer = countController.count.value;
                              Get.to(InviteCode());
                            } else {
                              customToast(
                                  msg: "This mode is in development",
                                  context: context);
                            }
                            // getData().then((value) {
                            //   Get.to(InviteCode());
                            // });
                          },
                          child: Container(
                            height: 50,
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                color: Colors.white),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Join"),
                                SizedBox(width: 15),
                                Icon(Icons.arrow_forward_ios_sharp),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Zone"),
        centerTitle: true,
      ),
      // drawer: Drawer(
      //   child: myDrawer(context:context,outside: true),
      // ),
      body: Column(
        children: [
          customCard(
              img: "assets/multiplayerOnline.jpg",
              text: "Multiplayer\n     Online",
              inProgress: false,
              context: context),
         Row(
           children: [
             Expanded(
               flex: 3,
               child: Center(
                 child: GestureDetector(
                   onTap: () {
                     showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         // return object of type Dialog
                         return AlertDialog(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20.0),
                           ),
                           title: Text(
                             "Instruction",
                             textAlign: TextAlign.center,
                           ),
                           content: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,  // Ensures left alignment
                             mainAxisSize: MainAxisSize.min, // Ensures the column takes only as much space as needed
                             children: <Widget>[
                               Text("Select color"),
                               Text("Roll dice"),
                               Text("Enter in lobby"),
                               Text("Share the code with your friend"),
                               Text("Press ready"),
                               Text("Then press go to enter the home page"),
                               Text("1st round: You have to find the room which has evidence"),
                               Text("2nd round: Find the weapon used"),
                               Text("3rd round: Find who killed"),
                               Text("In every round, everyone will get an equal number of cards for rooms, weapons, and people"),
                               Text("The cards they have will be shown below—they are out of the suspect list"),
                               Text("You need to find the missing cards that no one has"),
                             ],
                           ),
                           actions: <Widget>[
                             TextButton(
                               child: Text("Close"),
                               onPressed: () {
                                 Navigator.of(context).pop(); // Close the dialog
                               },
                             ),
                           ],
                         );
                       },
                     );

                   },
                   child: Container(
                     decoration: ShapeDecoration(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         color: Colors.black26),
                     height: 30,
                     width: 130,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.info),
                         Text("How to play"),
                       ],
                     ),
                   ),
                 ),
               ),
             ),
             Expanded(
               child: Center(
                 child: GestureDetector(
                   onTap: () {
                     showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         // return object of type Dialog
                         return AlertDialog(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20.0),
                           ),
                           title: Text(
                             "Note:",
                             textAlign: TextAlign.center,
                           ),
                           content: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,  // Ensures left alignment
                             mainAxisSize: MainAxisSize.min, // Ensures the column takes only as much space as needed
                             children: <Widget>[
                               Text("This game is developed by a solo developer, and I am doing my best to address any bugs that may arise. If you encounter any issues or have any suggestions for improvement, I kindly ask for your support and feedback. Your help is greatly appreciated as I continue to enhance the game."),

                             ],
                           ),
                           actions: <Widget>[
                             TextButton(
                               child: Text("Close"),
                               onPressed: () {
                                 Navigator.of(context).pop(); // Close the dialog
                               },
                             ),
                           ],
                         );
                       },
                     );

                   },
                   child: Container(
                     decoration: ShapeDecoration(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         color: Colors.black26),
                     height: 30,
                     width: 80,
                     child: Center(child: Text("Note")),
                   ),
                 ),
               ),
             ),
           ],
         ),
          customCard(
              img: "assets/soloPlayer.jpg",
              text: "Play\nSolo",
              inProgress: true,
              context: context),
          customCard(
              img: "assets/multiplayerOffline.jpg",
              text: "Multiplayer\n    Offline",
              inProgress: true,
              context: context),
        ],
      ),
    );
  }
}

class CountController extends GetxController {
  var count = 2
      .obs; // "obs" stands for observable, and it's used to make the variable reactive

  void increment() {
    count++;
  }

  void decrement() {
    count--;
  }
}
