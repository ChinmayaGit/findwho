import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Lobby/invite_code.dart';
import 'package:findwho/Pages/Lobby/color_dice_picker.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_game_contoller.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:findwho/database/offline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'waiting_lobby.dart';

class SelectBoard extends StatelessWidget {
   SelectBoard({super.key});
 int noOfPlayer=0;
   final RxBool createWait=false.obs;
   final CountController countController = Get.put(CountController());
   // final UserController _userController = Get.put(UserController());
  customCard({required String text, required String img, context}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
                                countController.count.value >= 3
                                    ? countController.decrement()
                                    : 0;
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
                                countController.count.value <= 3
                                    ? countController.increment()
                                    : 0;
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
                        child:createWait.value==false? GestureDetector(
                          onTap: () async{
                            createWait.value = true;
                            noOfPlayer = countController.count.value;
                            invitationCode = generateInvitationCode();
                            print(noOfPlayer);
                            Get.to(() => ColorDicePicker(maxPlayer:noOfPlayer));
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
                                Text("Create"),
                                SizedBox(width: 15),
                                Icon(Icons.arrow_forward_ios_sharp),
                              ],
                            ),
                          ),
                        ):Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            noOfPlayer = countController.count.value;
                            Get.to(InviteCode());
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
      body: Column(
        children: [
          customCard(
              img: "assets/soloPlayer.jpg",
              text: "Play\nSolo",
              context: context),
          customCard(
              img: "assets/multiplayerOffline.jpg",
              text: "Multiplayer\n    Offline",
              context: context),
          customCard(
              img: "assets/multiplayerOnline.jpg",
              text: "Multiplayer\n     Online",
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
