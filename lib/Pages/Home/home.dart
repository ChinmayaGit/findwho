import 'package:findwho/Pages/Home/components/home_components.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_controller.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_data_controller.dart';
import 'package:findwho/Pages/Lobby/components/model/game_item_model.dart';
import 'package:findwho/Pages/Lobby/components/model/zone_game_model.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_game_contoller.dart';
import 'package:findwho/database/fetch_data.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const backImg = ["house.jpeg", "weapon.jpeg", "person.jpeg"];
  final ZoneController _zoneController = Get.put(ZoneController());
  final ZoneGameController _zoneGameController = Get.put(ZoneGameController());
  final ZoneDataController _zoneDataController = Get.put(ZoneDataController());
  @override
  void initState() {
    pageValue = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      key: _scaffoldKey,
      drawer: Drawer(
        child: myDrawer(context),
      ),
      body: Obx(
        () {

          if (_zoneGameController.isLoadingZoneGameController.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (_zoneGameController.zoneGameCollection.isEmpty) {
            return Center(child: Text('No data available'));
          }
          print(_zoneGameController.zoneGameDoc.value?.persons.length);
          final zoneGameDoc = _zoneGameController.zoneGameCollection.first;
          final int currentTurn =
              _zoneController.zoneDoc.value?.turn ?? 1;
          print("newnew");
          var roomsList = _zoneGameController.zoneGameDoc.value?.getRoomsList();
          if (roomsList != null && roomsList.isNotEmpty) {
            for (var room in roomsList) {
              print('Room Image: ${room.img}, Room Name: ${room.name}, Room State: ${room.state}');
            }
          } else {
            print('No rooms available.');
          }
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  height: Get.height,
                  child: Image.asset(
                    pageValue == 1
                        ? 'assets/background/${backImg[pageValue - 1]}'
                        : pageValue == 2
                            ? 'assets/background/${backImg[pageValue]}'
                            : 'assets/background/${backImg[pageValue + 1]}',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color:
                      Colors.black.withOpacity(0.5), // Adjust opacity as needed
                ),
                topBar(_scaffoldKey, context),
                backGlassContainer(isLeft: true),
                backGlassContainer(isLeft: false),
                Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: pageValue == 1
                      ?gridContent<RoomModel>(
                    objects: _zoneDataController.zoneDataDoc.value?.rooms ?? [], // Fetch rooms list
                    assetName: "rooms", // Example asset name, adjust as needed
                    context: context,
                  )

                        : pageValue == 2
                          ? gridContent<WeaponModel>(
                              objects:  _zoneGameController.zoneGameDoc.value?.getWeaponsList() ?? [],
                              assetName: "weapons",
                              context: context)
                          : gridContent<PersonModel>(
                              objects: _zoneGameController.zoneGameDoc.value?.getPersonsList() ?? [],
                              assetName: "persons",
                              context: context),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height / 1.2),
                  child: pageValue == 1
                      ?SwipeableCardDeck<RoomModel>(
                    playersCards: _zoneGameController.zoneGameDoc.value?.getRoomsList() ?? [],
                  )
                      : pageValue == 2
                          ? SwipeableCardDeck<WeaponModel>(
                              playersCards: _zoneGameController.zoneGameDoc.value?.getWeaponsList() ?? [],)
                          : SwipeableCardDeck<PersonModel>(
                  playersCards:  _zoneGameController.zoneGameDoc.value?.getPersonsList() ?? [],
                ),),
                // Center(
                //     child: Text(
                //   _zoneController.zoneDoc.value?.turn.toString(),
                //   style: TextStyle(fontSize: 40, color: Colors.white),
                // )),
              ],
            ),
          );
        },
      ),
    );
  }
}
