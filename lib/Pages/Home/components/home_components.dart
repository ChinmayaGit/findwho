import 'package:findwho/Pages/Exit/exit.dart';
import 'package:findwho/components/colors.dart';
import 'package:findwho/components/controller/zone_controller.dart';
import 'package:findwho/components/controller/zone_data_controller.dart';
import 'package:findwho/components/controller/zone_solution_controller.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/model/game_item_model.dart';
import 'package:findwho/components/model/zone_game_model.dart';
import 'package:findwho/Pages/Result/Result.dart';
import 'package:findwho/components/room_status.dart';
import 'package:findwho/components/toast.dart';
import 'package:findwho/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/allocater.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//now will always stays 1 because if dice is high he will assigned 1 (decideTurn())
RxInt now = RxInt(1);
final ZoneController _zoneController = Get.put(ZoneController());
final ZoneGameController _zoneGameController = Get.put(ZoneGameController());
final ZoneDataController _zoneDataController = Get.put(ZoneDataController());
final ZoneSolutionController _zoneSolutionController =
Get.put(ZoneSolutionController());

//Layer 1
Widget topBar(_scaffoldKey, context) {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 16.0),
      // Adjust the top padding as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            padding: const EdgeInsets.only(left: 22.0),
            child: const CircleAvatar(
              radius: 30,
              child: Icon(Icons.mic),
            ),
          ),

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
                  "Now: \nPlayer ${_zoneController.zoneDoc.value?.turn.toString()}",
                  style: TextStyle(color:_zoneController.zoneDoc.value?.turn==_zoneGameController.zoneGameDoc.value!.playerTurn?stringToColor(_zoneGameController.zoneGameDoc.value!.color):Colors.grey ),

                ),
              ),

            ),
          ),

        ],
      ),
    ),
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
        onTap: () async {
          if(gameItems.state==false){
          if (_zoneGameController.zoneGameDoc.value?.playerTurn ==
              _zoneController.zoneDoc.value?.turn) {
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
          } else {
            Get.snackbar('WAIT:',
                'Now Player ${_zoneController.zoneDoc.value?.turn} is Playing wait for your turn',
                colorText: Colors.white);
          }
          // print(_zoneGameController.zoneGameDoc.value?.playerTurn);
          // print("xyz");

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
    builder: (BuildContext dialogContext) {
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
                    print("chinuS");
                    print(gameItems.name);
                    print(name);
                    print(RoomStatusManager.rooms);
                    print(_zoneSolutionController
                        .zoneSolutionDoc.value!.rooms?['name']);
                    print("chinuE");

                    if (gameItems.name ==
                        (name == RoomStatusManager.rooms
                            ? _zoneSolutionController
                                .zoneSolutionDoc.value?.rooms!['name']
                            : name == RoomStatusManager.weapons
                                ? _zoneSolutionController
                                    .zoneSolutionDoc.value?.weapons!['name']
                                : _zoneSolutionController
                                    .zoneSolutionDoc.value?.persons!['name'])) {


                      // await _zoneController.updateZoneDocument({
                      //   "solutionFound": {
                      //     name:
                      //     _zoneGameController.zoneGameDoc.value?.playerTurn
                      //   }
                      // });
                      FirebaseFirestore.instance
                          .collection('zone')
                          .doc(invitationCode)
                          .set({
                        "solutionFound": {
                          name:
                              _zoneGameController.zoneGameDoc.value?.playerTurn
                        }
                      }, SetOptions(merge: true));

                      name == RoomStatusManager.rooms
                          ?   _zoneController.updateZoneDocument({
                        "page": 1,
                      })
                          : name == RoomStatusManager.weapons
                              ?   _zoneController.updateZoneDocument({
                        "page": 2,
                      })
                              :  _zoneController.updateZoneDocument({
                        "page": 3,
                      });


                      Get.snackbar('WOW!:', 'You found the $name',
                          colorText: Colors.white);
                    } else {
                      // print(_zoneController.zoneDoc.value?.turn);
                      // online update

                      // offline update
                      // gameItems.state = true;
                      // print(name + index.toString());
                      await _zoneController.updateZoneDocument({
                        'Turn': _zoneController.zoneDoc.value?.maxPlayers ==
                            _zoneGameController.zoneGameDoc.value?.playerTurn
                            ? 1
                            : (_zoneController.zoneDoc.value?.turn)! + 1,
                      });
                      updateState(name: name, index: index);
                      Get.snackbar('Message:', 'Wrong $name Try next time',
                          colorText: Colors.white);
                    }

                    Navigator.of(dialogContext).pop();
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
  await _zoneDataController.updateZoneDataDocument(index, true, name);
}

Widget gridCard(GameItem gameItems, int index) {
  print(gameItems.name);
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
      height: Get.height / 1.40,
      width: Get.width / 3.25,
    ),
  );
}

//Layer 3
class SwipeableCardDeck<T extends GameItem> extends StatelessWidget {
  final List<T>? playersCards;

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
