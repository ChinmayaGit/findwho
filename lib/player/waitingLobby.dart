import 'package:findwho/room/ListPage.dart';
import 'package:findwho/room/components/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/database/Global.dart';
import 'package:findwho/room/HomePage.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  _WaitingLobbyState createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late Future<void> _zoneDataFuture;
  bool micState = false;
  bool gogo = false;

  @override
  void initState() {
    super.initState();
    _zoneDataFuture = getZoneData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print(readyCount);
              setState(() {
                _zoneDataFuture = getZoneData(); // Trigger data refresh
              });
            },
          ),
        ],
      ),
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
                      child: Text("Invite Code: $invitationCode"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Max Players: ${zone?["PlayerCount"].toString()}"),
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
                child: RefreshIndicator(
                  onRefresh: getZoneData,
                  // Assign the refresh function to the RefreshIndicator
                  child: FutureBuilder(
                    future: _zoneDataFuture,
                    // Use the future that holds the latest data
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: zoneData.length,
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
                                                    "Name: ${zoneData[index]['player'].toString()} ${index + 1}"),
                                                Text(
                                                    "Dice: ${zoneData[index]['dice'].toString()}"),
                                                Text(
                                                    "Player: ${zoneData[index]['ready']}"),
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
                                                  zoneData[index]['color']
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
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: zoneUserData['ready'] != 'Ready'
                  ? GestureDetector(
                      onTap: () async {
                        FirebaseFirestore.instance
                            .collection("zone")
                            .doc(invitationCode)
                            .collection("game")
                            .doc(authQuerySnapshot.data()!["uid"])
                            .update({
                          "ready": "Ready",
                        });
                        await getZoneUserData();
                        setState(() {
                          _zoneDataFuture = getZoneData();
                          gogo = true; // Trigger data refresh
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
                  : gogo == false
                      ? GestureDetector(
                          onTap: () async {
                            readyCount = 0;
                            for (int i = 0; i < zoneData.length; i++) {
                              if (zoneData[i]['ready'] == "Ready") {
                                readyCount += 1;
                              }
                            }
                            if (zone?["PlayerCount"] == readyCount) {
                              // FirebaseFirestore.instance
                              //     .collection("users")
                              //     .doc(authQuerySnapshot.data()!["uid"])
                              //     .update({
                              //   "inGame": "true",
                              // });

                              List<Map<String, dynamic>> resultsList = [];
                              for (int i = 0; i < zoneData.length; i++) {
                                // Create a temporary map to store values for this iteration
                                Map<String, dynamic> tempMap = {
                                  "dice": zoneData[i]["dice"],
                                  "uid": zoneData[i]["uid"],
                                };
                                resultsList.add(tempMap);
                              }
                              resultsList.sort(
                                  (a, b) => b["dice"].compareTo(a["dice"]));
                              print(resultsList[0]["uid"]);

                              for (int i = 0; i < zoneData.length; i++) {
                                FirebaseFirestore.instance
                                    .collection("zone")
                                    .doc(invitationCode)
                                    .collection("game")
                                    .doc(resultsList[i]["uid"])
                                    .update({
                                  "player": "Player ${i + 1}",
                                  "turn": i + 1
                                });
                              }
                              if (noOfPlayer == 0) {
                                await getZone();
                                noOfPlayer=zone['PlayerCount'];
                                makeEqual();
                              } else {
                                makeEqual();
                              }

//                                 if (sortedDiceLists.length > 1) {
//                                   print(sortedDiceLists[1]);
//                                 } else {
//                                   print('sortedDiceLists does not have enough elements');
//                                 }
                              // Get.to(const Home());
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
                        )
                      : Center(child: const CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
