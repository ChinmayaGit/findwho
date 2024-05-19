import 'package:findwho/components/toast.dart';
import 'package:findwho/database/Global.dart';
import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/database/roomGlobal.dart';
import 'package:findwho/database/GameMap.dart';
import 'package:findwho/room/Result.dart';
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
              print(zone["solutionFound"]["room"]);

              // print();
              Get.to(()=> Result());
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
            icon: Icon(Icons.home),
            // child: Text("Tab1"),
          ),
          Tab(
            icon: Icon(Icons.security),
            // child: Text("Tab2"),
          ),
          Tab(
            icon: Icon(Icons.person),
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
              zone["solutionFound"]["room"]==""
                  ? GridContent(listRoom, 0)
                  : Stack(
                alignment: Alignment.topCenter,
                children: [
                    Text( "${zone["solutionFound"]["room"]} found the room"),
                gridCard(solutionRoom[0]),
              ],),
              zone["solutionFound"]["weapon"]==""
                  ? GridContent(listWeapon, 1)
                  : Stack(
                alignment: Alignment.topCenter,
                children: [
                  Text( "${zone["solutionFound"]["weapon"]} found the weapon"),
                  gridCard(solutionWeapon[0]),
                ],),
              zone["solutionFound"]["person"]==""
                  ? GridContent(listPerson, 2)
                  : Stack(
                alignment: Alignment.topCenter,
                children: [
                  Text( "${zone["solutionFound"]["person"]} found the person"),
                  gridCard(solutionPerson[0]),
                ],),

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
                  // print(zoneData.length);
                  // print(zone['playing']);
                  // print(zoneUserData['turn']);
                  if (zone['playing'] == zoneUserData['turn']) {
                    int playing = zone['playing'];
                    var zoneDocRef = FirebaseFirestore.instance
                        .collection("zone")
                        .doc(invitationCode);
                    var gameDocRef = zoneDocRef.collection('game').doc(authId);
                    var updateData = {
                      "times": {"room": 1, "weapon": 1, "person": 1}
                    };
                    if (zoneData.length == playing) {
                      zoneDocRef.update({"playing": 1});
                    } else {
                      zoneDocRef.update({"playing": playing + 1});
                    }

                    gameDocRef.update(updateData);
                    getZone();
                    // getUserData();
                    customToast(msg: 'Passed to Next Player', context: context);
                  } else {
                    customToast(
                        msg: 'Please wait for your turn', context: context);
                  }
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
  final int pageIndex;

  const GridContent(this.objects, this.pageIndex, {Key? key}) : super(key: key);

  @override
  State<GridContent> createState() => _GridContentState();
}

// int index = 0;

class _GridContentState extends State<GridContent> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.objects.length,
        itemBuilder: (context, index) {
          AssetInfo assetInfo = widget.objects[index];
          return GestureDetector(
            onTap: () async {
              print(index);
              await getZone();
              await getZoneUserData();
              if (zone['playing'] == zoneUserData['turn']) {
                await getZoneUserData();
                if (zoneUserData['times']['room'] == 1 &&
                    widget.pageIndex == 0) {
                  checkTurn(assetInfo, "room", index);
                } else if (zoneUserData['times']['weapon'] == 1 &&
                    widget.pageIndex == 1) {
                  checkTurn(assetInfo, "weapon", index);
                } else if (zoneUserData['times']['person'] == 1 &&
                    widget.pageIndex == 2) {
                  checkTurn(assetInfo, "person", index);
                } else {
                  customToast(
                      msg:
                          'Go to next or pass to next person your turn is over',
                      context: context);
                }
              } else {
                customToast(
                    msg: 'Current player: Player ${zone['playing']}',
                    context: context);
              }
            },
            onDoubleTap: () async {
              // print(zone['playing']);
              // print(zoneUserData['turn']);
              await getZone();
              await getZoneUserData();
              if (zone['playing'] == zoneUserData['turn']) {
                if (zoneUserData['times']['room'] == 1 &&
                    widget.pageIndex == 0) {
                  checkTurn(assetInfo, "room", widget.pageIndex);
                } else if (zoneUserData['times']['weapon'] == 1 &&
                    widget.pageIndex == 1) {
                  checkTurn(assetInfo, "weapon", widget.pageIndex);
                } else if (zoneUserData['times']['person'] == 1 &&
                    widget.pageIndex == 2) {
                  checkTurn(assetInfo, "person", widget.pageIndex);
                } else {
                  customToast(
                      msg:
                          'Go to next or pass to next person your turn is over',
                      context: context);
                }
              } else {
                customToast(
                    msg: 'Current player: Player ${zone['playing']}',
                    context: context);
              }
            },
            child: gridCard(assetInfo)
          );
        });
  }


  updateState({required String name, required int index}) async {
    final documentReference = FirebaseFirestore.instance
        .collection('zone')
        .doc(invitationCode)
        .collection("data")
        .doc("combinedData");

// Retrieve the document snapshot
    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      // Retrieve the data from the document
      final data = documentSnapshot.data() as Map<String, dynamic>;
      final persons = List<Map<String, dynamic>>.from(data[name] ?? []);

      // Update the state of the specific element
      if (index >= 0 && index < persons.length) {
        persons[index]['state'] = true;
      }
      print(persons[index]['state']);
      print(index);
      // Update the 'persons' array in the document
      await documentReference.update({name: persons});
    }
  }

  checkTurn(assetInfo, name, index) {
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
//updateing
                      await updateZoneUserData({
                        'times.$name': 0,
                      });
                      setState(() {
                        if (widget.pageIndex == 0) {
                          if (assetInfo.name == solutionRoom[0].name) {
                            FirebaseFirestore.instance
                                .collection('zone')
                                .doc(invitationCode)
                                .set({
                              "solutionFound": {
                                "room": zoneUserData['player']
                              }
                            }, SetOptions(merge: true));
                            customToast(
                                msg:
                                    'You found it someOne was killed on ${assetInfo.name}',
                                context: context);
                          } else {
                            updateState(name: 'rooms', index: index);
                            customToast(
                                msg: 'Wrong Room Try next time',
                                context: context);
                            assetInfo.state = true;
                          }
                        } else if (widget.pageIndex == 1) {
                          print(assetInfo.name);
                          print(solutionWeapon[0].name);
                          print("Chinu");
                          if (assetInfo.name == solutionWeapon[0].name) {
                            FirebaseFirestore.instance
                                .collection('zone')
                                .doc(invitationCode)
                                .set({
                              "solutionFound": {
                                "weapon": zoneUserData['player']
                              }
                            }, SetOptions(merge: true));
                            customToast(
                                msg:
                                    'You found it someOne was killed by ${assetInfo.name}',
                                context: context);
                          } else {
                            updateState(name: 'weapons', index: index);
                            customToast(
                                msg: 'Wrong Weapon Try next time',
                                context: context);
                            assetInfo.state = true;
                          }
                        } else if (widget.pageIndex == 2) {
                          if (assetInfo.name == solutionPerson[0].name) {
                            FirebaseFirestore.instance
                                .collection('zone')
                                .doc(invitationCode)
                                .set({
                              "solutionFound": {
                                "person": zoneUserData['player']
                              }
                            }, SetOptions(merge: true));
                            customToast(
                                msg:
                                    'You found it someOne was killed by ${assetInfo.name}',
                                context: context);
                          } else {
                            // Retrieve the document reference
                            updateState(name: 'persons', index: index);
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

gridCard(assetInfo){
  return Card(
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
  );
}