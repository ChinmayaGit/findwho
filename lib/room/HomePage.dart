import 'package:findwho/database/Global.dart';
import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/database/roomGlobal.dart';
import 'package:findwho/room/ListPage.dart';
import 'package:findwho/player/Result.dart';
import 'package:findwho/room/components/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              customToast(msg: 'Under Progress..', context: context);
            },
            child: const Icon(Icons.menu)),
        //TODO here only player one selected
        title: Text("Now:${zoneUserData["player"]}"),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              // print();
              Get.to(const Result());
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 36,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text("0")),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: GFTabBar(
        tabBarHeight: 65,
        tabBarColor: Colors.white,
        length: 3,
        controller: tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.image),
            // child: Text("Tab1"),
          ),
          Tab(
            icon: Icon(Icons.picture_as_pdf),
            // child: Text("Tab2"),
          ),
          Tab(
            icon: Icon(Icons.directions_railway),
            // child: Text("Tab3"),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TabBarView(
            controller: tabController,
            children: <Widget>[
              GridContent(listRoom, 0),
              GridContent(listWeapon, 1),
              GridContent(listPerson, 2),
              // GridContent(whatever, 3),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          // <-- SEE HERE
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      builder: (context) {
                        return SizedBox(
                          height: 320,
                          child: GridView.count(
                            crossAxisCount: 4,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            children: tabController.index == 0
                                ? generateCards(playersRoom)
                                : tabController.index == 1
                                    ? generateCards(playersWeapon)
                                    : generateCards(playersPerson),
                          ),
                        );
                      });
                },
                child: Container(
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    color: Colors.white,
                  ),
                  height: 60,
                  width: 60,
                  child: const Icon(
                    Icons.upload_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  print(zoneData.length);
                  print(zone['playing']);
                  print(zoneUserData['turn']);
                  if (zone['playing'] == zoneUserData['turn']) {
                    if (zoneData.length == zone['playing']) {
                      FirebaseFirestore.instance
                          .collection("zone")
                          .doc(invitationCode)
                          .update({
                        "playing": 1,
                      });
                      FirebaseFirestore.instance
                          .collection("zone")
                          .doc(invitationCode)
                          .collection('game')
                          .doc(authQuerySnapshot.data()!["uid"])
                          .update({
                        "times": {
                          "room": 1,
                          "weapon": 1,
                          "person": 1,
                        },
                      });
                      getZone();
                      getUserData();
                      customToast(
                          msg:
                          'Passed to Next Player',
                          context: context);
                    } else {
                      FirebaseFirestore.instance
                          .collection("zone")
                          .doc(invitationCode)
                          .update({
                        "playing": zone['playing'] + 1,
                      });
                      FirebaseFirestore.instance
                          .collection("zone")
                          .doc(invitationCode)
                          .collection('game')
                          .doc(authQuerySnapshot.data()!["uid"])
                          .update({
                        "times": {
                          "room": 1,
                          "weapon": 1,
                          "person": 1,
                        },
                      });
                      getZone();
                      getUserData();
                      customToast(
                          msg:
                          'Passed to Next Player',
                          context: context);
                    }
                  } else {
                    customToast(
                        msg: 'Please wait for your turn', context: context);
                  }

                  // if (zone['playing']-1 == zoneUserData['turn']- 1) {
                  //
                  //   print(currentPlayerIndex);
                  //   print(playersTurn[currentPlayerIndex].turnOrder);
                  //   print(
                  //       'Current player: ${playersTurn[currentPlayerIndex].turnOrder}');
                  //   print(
                  //       'Current player: ${playersTurn[currentPlayerIndex].name}');
                  //   FirebaseFirestore.instance
                  //       .collection("zone")
                  //       .doc(invitationCode)
                  //       .update({
                  //     "playing": playersTurn[currentPlayerIndex].turnOrder,
                  //   });
                  //
                  //   getZone();
                  //   FirebaseFirestore.instance
                  //       .collection("zone")
                  //       .doc(invitationCode).collection('game').doc(authQuerySnapshot.data()!["uid"])
                  //       .update({
                  //     "times":{
                  //       "room": 1,
                  //       "weapon": 1,
                  //       "person": 1,},
                  //   });
                  // } else {
                  //   customToast(
                  //       msg:
                  //       'Please wait for your turn',
                  //       context: context);
                  // }
                },
                child: Container(
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                      ),
                    ),
                    color: Colors.white,
                  ),
                  height: 60,
                  width: 60,
                  child: const Icon(
                    Icons.next_plan,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> generateCards(List<AssetInfo> assetList) {
    return assetList
        .map((assetInfo) => Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(assetInfo.img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      assetInfo.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }
}

class GridContent extends StatefulWidget {
  final List<AssetInfo> objects;
  final int index;

  const GridContent(this.objects, this.index, {Key? key}) : super(key: key);

  @override
  State<GridContent> createState() => _GridContentState();
}

class _GridContentState extends State<GridContent> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: widget.objects.map((assetInfo) {
        if (assetInfo.state == false) {
          return GestureDetector(
            onTap: () async {
              print(zone['playing']);
              print(zoneUserData['turn']);
              await getZone();
              if (zone['playing'] == zoneUserData['turn']) {
                await getZoneUserData();
                if (zoneUserData['times']['room'] == 1 && widget.index == 0) {
                  await updateZoneUserData({'times.room': 0});
                  checkTurn(assetInfo);
                } else if (zoneUserData['times']['weapon'] == 1 &&
                    widget.index == 1) {
                  checkTurn(assetInfo);
                  await updateZoneUserData({'times.weapon': 0});
                } else if (zoneUserData['times']['person'] == 1 &&
                    widget.index == 2) {
                  checkTurn(assetInfo);
                  await updateZoneUserData({'times.person': 0});
                } else {
                  customToast(
                      msg:
                          'Go to next or pass to next person your turn is over',
                      context: context);
                }
              } else {
                customToast(
                    msg:
                        'Current player: ${zone['playing']}',
                    context: context);
              }
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(assetInfo.img),
                        fit: BoxFit.scaleDown,
                        colorFilter: assetInfo.state == true
                            ? const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.bookmark_border,
                        size: 15,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Text(
                        assetInfo.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      }).toList(),
    );
  }

  checkTurn(assetInfo) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: Text(
                assetInfo.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(assetInfo.img))),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      print(solutionRoom[0].name);
                      getZoneUserData();
                      Map<String, dynamic> existingSolutionFound = (zoneUserData
                              as Map<String, dynamic>?)?["solutionFound"] ??
                          {};

                      setState(() {
                        if (widget.index == 0) {
                          if (assetInfo.name == solutionRoom[0].name) {
                            existingSolutionFound["room"] = {
                              "img": solutionRoom[0].img,
                              "name": solutionRoom[0].name,
                              "state": solutionRoom[0].state
                            };
                            FirebaseFirestore.instance
                                .collection('zone')
                                .doc(invitationCode)
                                .collection("game")
                                .doc(authQuerySnapshot.data()!["uid"])
                                .update(
                                    {"solutionFound": existingSolutionFound});
                            customToast(
                                msg:
                                    'You found it someOne was killed on ${assetInfo.name}',
                                context: context);
                          } else {
                            FirebaseFirestore.instance
                                .collection('zone')
                                .doc(invitationCode)
                                .collection("game")
                                .doc(authQuerySnapshot.data()!["uid"])
                                .update(
                                    {"solutionFound": existingSolutionFound});
                            customToast(
                                msg: 'Wrong Room Try next time',
                                context: context);
                            assetInfo.state = true;
                          }
                        } else if (widget.index == 1) {
                          if (assetInfo.name == solutionWeapon[0].name) {
                            existingSolutionFound["weapon"] = {
                              "img": solutionWeapon[0].img,
                              "name": solutionWeapon[0].name,
                              "state": solutionWeapon[0].state
                            };
                            FirebaseFirestore.instance
                                .collection('zone')
                                .doc(invitationCode)
                                .collection("game")
                                .doc(authQuerySnapshot.data()!["uid"])
                                .update(
                                    {"solutionFound": existingSolutionFound});
                            customToast(
                                msg:
                                    'You found it someOne was killed by ${assetInfo.name}',
                                context: context);
                          } else {
                            customToast(
                                msg: 'Wrong Weapon Try next time',
                                context: context);
                            assetInfo.state = true;
                          }
                        } else if (widget.index == 2) {
                          if (assetInfo.name == solutionPerson[0].name) {
                            existingSolutionFound["person"] = {
                              "img": solutionPerson[0].img,
                              "name": solutionPerson[0].name,
                              "state": solutionPerson[0].state
                            };
                            FirebaseFirestore.instance
                                .collection('zone')
                                .doc(invitationCode)
                                .collection("game")
                                .doc(authQuerySnapshot.data()!["uid"])
                                .update(
                                    {"solutionFound": existingSolutionFound});
                            customToast(
                                msg:
                                    'You found it someOne was killed by ${assetInfo.name}',
                                context: context);
                          } else {
                            customToast(
                                msg: 'Wrong Person Try next time',
                                context: context);
                            assetInfo.state = true;
                          }
                        }
                        Get.back();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.green),
                      height: 60,
                      child: const Center(
                          child: Text(
                        "Select",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.red),
                      height: 60,
                      child: const Center(
                          child: Text(
                        "Reject",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
