import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Home/home.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_controller.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/game_status.dart';
import 'package:findwho/components/colors.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/toast.dart';
import 'package:findwho/Pages/Auth/auth_check.dart';

import 'package:findwho/database/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/database/fetch_zone.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  _WaitingLobbyState createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  bool micState = false;
  bool nextPage = false;

  @override
  void initState() {
    super.initState();
  }

  final UserController _userController = Get.put(UserController());
  final ZoneController _zoneController = Get.put(ZoneController());
  final ZoneGameController _zoneGameController = Get.put(ZoneGameController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _zoneController.isLoadingZoneController.value
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                title: Text("Lobby"),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      print(_zoneGameController.zoneGameCollection.length);
                      setState(() {
                        // _zoneDataFuture = getZoneGame(); // Trigger data refresh
                      });
                    },
                  ),
                ],
              ),

              // floatingActionButton: FloatingActionButton(onPressed: (){
              //   decideTurn();
              // },),

              body: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Invite Code: "),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Clipboard.setData(
                                        new ClipboardData(text: invitationCode))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Copied to your clipboard !')));
                                });
                              },
                              child: Text(invitationCode),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Max Players: ${_zoneController.zoneDoc.value?.maxPlayers}"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50.0),
                                bottomRight: Radius.circular(50.0),
                              ),
                            ),
                            color: Colors.black26),
                        child: ListView.builder(
                          itemCount:
                              _zoneGameController.zoneGameCollection.length,
                          itemBuilder: (context, index) {
                            // Your list item widget code goes here
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                width: Get.width,
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 28.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Name: Player ${_zoneGameController.zoneGameCollection[index].playerTurn.toString()}"),
                                                Text(
                                                    "Dice: ${_zoneGameController.zoneGameCollection[index].dice.toString()}"),
                                                Text(
                                                    "Player: ${_zoneGameController.zoneGameCollection[index].ready}"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 40,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    micState =
                                                        !micState; // Toggle micState
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  height: 35,
                                                  width: 35,
                                                  child: micState == false
                                                      ? Icon(Icons.mic_off)
                                                      : Icon(Icons.mic),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                              color: stringToColor(
                                                  _zoneGameController
                                                      .zoneGameCollection[index]
                                                      .color
                                                      .toString()),
                                            ),
                                            height: 100,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _zoneGameController.zoneGameDoc.value?.ready !=
                                true
                            ? GestureDetector(
                                onTap: () async {
                                  await _zoneGameController
                                      .updateZoneGameDocument({
                                    "ready": true,
                                  });

                                },
                                child: Container(
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    color: Colors.black,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Ready",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  int localReady = 0;
                                  for (int i = 0;
                                      i <
                                          _zoneGameController
                                              .zoneGameCollection.length;
                                      i++) {
                                    if (_zoneGameController
                                            .zoneGameCollection[i].ready ==
                                        true) {
                                      localReady++;
                                    }
                                  }

                                  if (localReady ==
                                      _zoneController
                                          .zoneDoc.value?.maxPlayers) {

                                    _userController.updateUserDocument({
                                      "inGame": GameStatusManager.activeGame
                                    });

                                    if (_zoneController
                                            .zoneDoc.value?.roomCreated ==
                                        false) {
                                      //ToDo:Here we deside the playe suffeling cards
                                      await createItemsData();
                                      _zoneController.updateZoneDocument({
                                        "RoomCreated": true,
                                      });
                                      // Get.to(() =>const Home());
                                    } else {
                                      Get.to(() => const Home());
                                    }
                                  } else {
                                    customToast(
                                        msg:
                                            "Other are not ready yet! please press refresh again",
                                        context: context);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    color: Colors.black,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Go",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )),
                  ),
                ],
              ),
            ),
    );
  }}

