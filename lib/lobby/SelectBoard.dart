import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/database/roomGlobal.dart';
import 'package:findwho/lobby/InviteCode.dart';
import 'package:findwho/lobby/SelectColorAndDice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/Global.dart';
import 'WaitingLobby.dart';

class SelectBoard extends StatelessWidget {
  SelectBoard({super.key});

  final CountController controller = Get.put(CountController());

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
                                controller.count.value >= 3
                                    ? controller.decrement()
                                    : 0;
                              },
                              child: CircleAvatar(child: Icon(Icons.remove)),
                            ),
                            Spacer(),
                            Obx(() => Container(
                                  child: Text(
                                    controller.count.toString(),
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
                                controller.count.value <= 3
                                    ? controller.increment()
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
                          onTap: () {
                            createWait.value = true;
                            noOfPlayer = controller.count.value;
                            getData().then((value) async {
                              invitationCode = generateInvitationCode();
                              await FirebaseFirestore.instance
                                  .collection("zone")
                                  .doc(invitationCode)
                                  .set({
                                "PlayerCount": noOfPlayer,
                                "InvitationCode": invitationCode,
                                "Date": DateTime.now(),
                                "RoomCreated": false,
                                "playing":1,
                                "solutionFound": {
                                  "room": "",
                                  "weapon": "",
                                  "person": "",
                                },
                                "Colors": {
                                  "Red": false,
                                  "Green": false,
                                  "Blue": false,
                                  "Yellow": false,
                                  "Orange": false,
                                  "Purple": false,
                                },
                              });
                              await FirebaseFirestore.instance
                                  .collection("zone")
                                  .doc(invitationCode)
                                  .collection("game")
                                  .doc(authId)
                                  .set({
                                "player": "na",
                                "color": "na",
                                "dice": "na",
                                "room": "na",
                                "weapon": "na",
                                "person": "na",
                                "uid": authId,
                                "ready": "Not Ready",
                                "turn": "",
                                "times": {
                                  "room": 1,
                                  "weapon": 1,
                                  "person": 1,
                                },
                                // "solutionFound": {
                                //   "room": {},
                                //   "weapon": {},
                                //   "person": {},
                                // },
                              });
                              Get.to(SelectColorAndDice());
                            });
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
                            noOfPlayer = controller.count.value;
                            getData().then((value) {
                              Get.to(InviteCode());
                            });
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
