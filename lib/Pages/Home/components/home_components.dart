import 'package:findwho/Pages/Exit/exit.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_controller.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_data_controller.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_solution_controller.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Lobby/components/model/game_item_model.dart';
import 'package:findwho/Pages/Lobby/components/model/zone_game_model.dart';
import 'package:findwho/Pages/Result/Result.dart';
import 'package:findwho/components/room_status.dart';
import 'package:findwho/components/toast.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_game_contoller.dart';
import 'package:findwho/database/fetch_data.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int pageValue = 1;

//now will always stays 1 because if dice is high he will assigned 1 (decideTurn())
RxInt now = RxInt(1);
final ZoneController _zoneController = Get.put(ZoneController());
final ZoneGameController _zoneGameController = Get.put(ZoneGameController());
final ZoneSolutionController _zoneSolutionController = Get.put(ZoneSolutionController());
final ZoneDataController _zoneDataController = Get.put(ZoneDataController());
//Layer 1
Widget topBar(_scaffoldKey, context) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
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
              child:  Text(
                  "Now: \nPlayer ${_zoneController.zoneDoc.value?.turn.toString()}",
                  style: const TextStyle(color: Colors.white),
                ),

            ),
          ),
        ),
      ],
    ),
  );
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
              "Player ${_zoneGameController.zoneGameDoc.value?.playerTurn.toString()}",
              style: const TextStyle(
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
        leading: const Icon(Icons.home_outlined),
        title: const Text('Home'),
        onTap: () {
          // Handle the action here
        },
      ),
      ListTile(
        leading: const Icon(Icons.scoreboard_outlined),
        title: const Text('Result'),
        onTap: () {
          Get.to(Result());
        },
      ),
      ListTile(
        leading: const Icon(Icons.settings_applications_outlined),
        title: const Text('Settings'),
        onTap: () {
          // Handle the action here
        },
      ),
      ListTile(
        leading: const Icon(Icons.exit_to_app_sharp),
        title: const Text('Exit'),
        onTap: () {
          Get.to(Exit());
        },
      ),
    ],
  );
}

//Layer 2

Widget gridContent<T extends GameItem>({
  required List<T>? objects,
  required String assetName,
  required BuildContext context,
}) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.8,
    ),
    itemCount: objects?.length,
    itemBuilder: (context, index) {
      T gameItems = objects![index];
      return GestureDetector(
        onTap: () {

          // Handle onTap logic based on the type of T (Room, Weapon, or Person)
          if (gameItems is RoomModel) {
            // Handle Room specific logic
            checkTurn(gameItems, RoomStatusManager.rooms, index, context);
            print('Room tapped: ${gameItems.name}');
          } else if (gameItems is WeaponModel) {
            // Handle Weapon specific logic
            checkTurn(gameItems, RoomStatusManager.weapons, index, context);
            print('Weapon tapped: ${gameItems.name}');
          } else if (gameItems is PersonModel) {
            // Handle Person specific logic
            checkTurn(gameItems, RoomStatusManager.persons, index, context);
            print('Person tapped: ${gameItems.name}');
          }
        },
        child: gridCard(gameItems, index),
      );
    },
  );
}

checkTurn(gameItems, name, index, context) {
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
              gameItems.name,
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
              child: Image.asset(gameItems.img),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    //updateing
                    await _zoneController.updateZoneDocument({
                      'Turn': _zoneController.zoneDoc.value?.turn == _zoneGameController.zoneGameDoc.value?.playerTurn
                          ? 1
                          : (_zoneController.zoneDoc.value?.turn)! + 1,
                    });
                    if (gameItems.name ==
                        (name == RoomStatusManager.rooms
                            ? _zoneSolutionController.zoneSolutionDoc.value?.rooms
                            : name == RoomStatusManager.weapons
                                ? _zoneSolutionController.zoneSolutionDoc.value?.weapons
                                : _zoneSolutionController.zoneSolutionDoc.value?.persons)) {

                      FirebaseFirestore.instance
                          .collection('zone')
                          .doc(invitationCode)
                          .set({
                        "solutionFound": {name: _zoneGameController.zoneGameDoc.value?.playerTurn}
                      }, SetOptions(merge: true));
                      customToast(msg: 'You found the $name', context: context);
                      // pageValue = 2;
                    } else {

                      // print("chinu");
                      // print(_zoneController.zoneDoc.value?.turn);
                      // online update

                      // offline update
                      // gameItems.state = true;
                      print("chinu");
                      print(name+index.toString());

                      updateState(name: name, index: index);
                      customToast(
                          msg: 'Wrong $name Try next time', context: context);
                    }

                    Get.back();
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

updateState({required String name, required int index}) async {

  // final documentReference = FirebaseFirestore.instance
  //     .collection('zone')
  //     .doc(invitationCode)
  //     .collection("data")
  //     .doc("combinedData");
  // // Retrieve the document snapshot
  // final documentSnapshot = await documentReference.get();

  await _zoneDataController.updateZoneDataDocument({
    'weapons': {
      0: {'state': true} // Example update for a weapon with ID `weaponId`
    }
  });
  // if (documentSnapshot.exists) {
  //   // Retrieve the data from the document
  //   final data = documentSnapshot.data() as Map<String, dynamic>;
  //   final RWP = List<Map<String, dynamic>>.from(data[name] ?? []);
  //
  //   // Update the state of the specific element
  //   if (index >= 0 && index < RWP.length) {
  //     RWP[index]['state'] = true;
  //   }
  //   await _zoneDataController.updateZoneDataDocument({
  //     name: RWP,
  //   });
  //   // Update the 'persons' array in the document
  //   // await documentReference.update({name: RWP});
  // } else {
  //   print("unable update state (line 340)");
  // }
}

Widget gridCard(GameItem gameItems, int index) {
  print(gameItems.name);
  print("chinu");
  return Card(
    color: Colors.transparent,
    elevation: 0,
    child: Row(
      mainAxisAlignment: index % 2 != 0
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
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
                    image: AssetImage(gameItems.img),
                    fit: BoxFit.cover,
                    colorFilter: gameItems.state
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
                gameItems.name,
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
    top: 90,
    child: Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: isLeft ? Radius.circular(40.0) : Radius.zero,
            bottomRight: isLeft ? Radius.circular(40.0) : Radius.zero,
            topLeft: isLeft ? Radius.zero : Radius.circular(40.0),
            bottomLeft: isLeft ? Radius.zero : Radius.circular(40.0),
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
class SwipeableCardDeck<T extends GameItem> extends StatelessWidget {
  final List<T>? playersCards;

  const SwipeableCardDeck({Key? key, required this.playersCards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
      viewportFraction: 0.3,
      initialPage: 1,
    );
    return SizedBox(
      height: 400, // Adjust the height as needed
      child: playersCards != null && playersCards!.isNotEmpty
          ? PageView.builder(
        controller: controller,
        itemCount: playersCards!.length,
        itemBuilder: (BuildContext context, int index) {
          return Transform.scale(
            scale: 0.9,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(playersCards![index].img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: ShapeDecoration(
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
                          playersCards![index].name,
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
