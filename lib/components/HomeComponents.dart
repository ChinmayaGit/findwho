import 'package:findwho/components/LobbyComponents.dart';
import 'package:findwho/components/toast.dart';
import 'package:findwho/database/FetchData.dart';
import 'package:findwho/database/FetchZone.dart';
import 'package:findwho/room/GameClose.dart';
import 'package:findwho/room/Result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Layer 1
Widget topBar(_scaffoldKey) {
  return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 55.0, left: 0),
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white,
                    ),
                    bottom: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(25, 17, 10, 18),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: Get.width / 4.3, top: 15),
            child: const CircleAvatar(
              radius: 50,
              child: Icon(Icons.mic),
            ),
          ),
          const Spacer(),
          // This will push the following widget to the right corner
          Padding(
            padding: const EdgeInsets.only(bottom: 55.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white,
                  ),
                  bottom: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Text(
                  "Now: \n${zoneUserData["player"]}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ));
}

Widget myDrawer(context) {
  return ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: [
             Text(
              zoneUserData["player"],
              style:const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Invite Code: "),
            ),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: invitationCode))
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to your clipboard !'),
                    ),
                  );
                });
              },
              child: Text(invitationCode),
            ),
          ],
        ),
      ),
      ListTile(
        leading:const Icon(Icons.home_outlined),
        title:const Text('Home'),
        onTap: () {
          // Handle the action here
        },
      ),
      ListTile(
        leading:const Icon(Icons.scoreboard_outlined),
        title:const Text('Result'),
        onTap: () {
          Get.to(Result());
        },
      ),
      ListTile(
        leading:const Icon(Icons.settings_applications_outlined),
        title:const Text('Settings'),
        onTap: () {
          // Handle the action here
        },
      ),
      ListTile(
        leading:const Icon(Icons.exit_to_app_sharp),
        title:const Text('Exit'),
        onTap: () {
          Get.to(GameCloser(text: "true"));
        },
      ),
    ],
  );
}

//Layer 2
class GridContent extends StatefulWidget {
  final List<AssetInfo> objects;
  final int pageIndex;

  const GridContent(this.objects, this.pageIndex, {Key? key}) : super(key: key);

  @override
  State<GridContent> createState() => _GridContentState();
}

class _GridContentState extends State<GridContent> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      itemCount: widget.objects.length,
      itemBuilder: (context, index) {
        AssetInfo assetInfo = widget.objects[index];
        return GestureDetector(
          onTap: () async {
            if (zoneUserData['times']['room'] == 1 && widget.pageIndex == 0) {
            } else {
              customToast(
                  msg: 'Current player: Player ${zone['playing']} turn',
                  context: context);
            }

            // updateZone()
            // Move from (zone/id/game/time)to(zone/id)



            // await getZone();
            // await getZoneUserData();
            // if (zone['playing'] == zoneUserData['turn']) {
            //   await getZoneUserData();
            //   if (zoneUserData['times']['room'] == 1 && widget.pageIndex == 0) {
            //     checkTurn(assetInfo, "room", index);
            //   } else if (zoneUserData['times']['weapon'] == 1 &&
            //       widget.pageIndex == 1) {
            //     checkTurn(assetInfo, "weapon", index);
            //   } else if (zoneUserData['times']['person'] == 1 &&
            //       widget.pageIndex == 2) {
            //     checkTurn(assetInfo, "person", index);
            //   } else {
            //     customToast(
            //         msg: 'Go to next or pass to next person your turn is over',
            //         context: context);
            //   }
            // } else {
            //   customToast(
            //       msg: 'Current player: Player ${zone['playing']} turn',
            //       context: context);
            // }
          },
          child: gridCard(assetInfo, index),
        );
      },
    );
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
                child: Image.asset(assetInfo.img),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      //updateing
                      await updateZoneUserData({
                        'times.$name': 0,
                      });
                      setState(
                            () {
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
                              },
                                  SetOptions(merge: true));
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
                        },
                      );
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
                        ),
                      ),
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
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

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
    // Update the 'persons' array in the document
    await documentReference.update({name: persons});
  }
}

Widget gridCard(assetInfo, index) {
  return Card(
    color: Colors.transparent,
    elevation: 0,
    child: Row(
      mainAxisAlignment:
      index % 2 != 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: AssetImage(assetInfo.img),
                    fit: BoxFit.cover,
                    colorFilter: assetInfo.state
                        ? const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.saturation,
                    )
                        : null,
                  ),
                ),
              ),
            ),
            Container(
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
          ],
        ),
      ],
    ),
  );
}

Widget backGlassContainer({required bool isLeft}) {
  return Positioned(
    left: isLeft ? 0 : null,
    right: isLeft ? null : 0,
    top: 100,
    child: Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: isLeft ? Radius.circular(50.0) : Radius.zero,
            bottomRight: isLeft ? Radius.circular(50.0) : Radius.zero,
            topLeft: isLeft ? Radius.zero : Radius.circular(50.0),
            bottomLeft: isLeft ? Radius.zero : Radius.circular(50.0),
          ),
        ),
        color: Colors.white.withOpacity(0.2),
      ),
      height: Get.height / 1.45,
      width: Get.width / 3.25,
    ),
  );
}

//Layer 3
class SwipeableCardDeck extends StatelessWidget {
  final List<AssetInfo> playersCards;

  const SwipeableCardDeck({Key? key, required this.playersCards})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
      viewportFraction: 0.3,
      initialPage: 1,
    );
    return SizedBox(
      height: 400, // Adjust the height as needed
      child: playersCards.isNotEmpty
          ? PageView.builder(
              controller: controller,
              itemCount: playersCards.length,
              itemBuilder: (BuildContext context, int index) {
                return Transform.scale(
                  scale: 0.9,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        color: Colors.black,
                      ),
                      child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(playersCards[index].img),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              ),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                playersCards[index].name,
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
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'No data available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
    );
  }
}


