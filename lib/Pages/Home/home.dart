import 'package:findwho/Drawer/my_drawer.dart';
import 'package:findwho/Pages/Exit/exit.dart';
import 'package:findwho/Pages/Home/components/home_components.dart';
import 'package:findwho/Pages/Result/Result.dart';
import 'package:findwho/components/controller/zone_controller.dart';
import 'package:findwho/components/controller/zone_data_controller.dart';
import 'package:findwho/components/controller/zone_solution_controller.dart';
import 'package:findwho/components/model/game_item_model.dart';
import 'package:findwho/components/model/zone_game_model.dart';
import 'package:findwho/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/allocater.dart';
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
  final ZoneSolutionController _zoneSolutionController =
  Get.put(ZoneSolutionController());
  // @override
  // void initState() {
    // pageController.pageValue.value = 0;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      key: _scaffoldKey,
      drawer: Drawer(
        child: myDrawer(context:context,outside: false),
      ),
      body: Obx(
        () {
          if (_zoneGameController.isLoadingZoneGameController.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (_zoneGameController.zoneGameCollection.isEmpty) {
            return Column(
              children: [
                Expanded(child: Center(child: Text('Others have left the game!'))),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        Get.to(() => Exit(last: true,));
                      },
                      child: Container(
                        height: 50,
                        width: 120,
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.red),
                        child: const Center(
                          child: Text(
                            "Exit",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          print(_zoneGameController.zoneGameDoc.value?.persons.length);
          final zoneGameDoc = _zoneGameController.zoneGameCollection.first;
          final int currentTurn = _zoneController.zoneDoc.value?.turn ?? 1;
          var roomsList = _zoneGameController.zoneGameDoc.value?.getRoomsList();
          if (roomsList != null && roomsList.isNotEmpty) {
            for (var room in roomsList) {
              print(
                  'Room Image: ${room.img}, Room Name: ${room.name}, Room State: ${room.state}');
            }
          } else {
            print('No rooms available.');
          }
          return SafeArea(
            child: _zoneController.zoneDoc.value!.page != 3? Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: Get.height,
                  child: Image.asset(
                    _zoneController.zoneDoc.value!.page == 0
                        ? 'assets/background/${backImg[ _zoneController.zoneDoc.value!.page]}'
                        :  _zoneController.zoneDoc.value!.page ==1
                        ? 'assets/background/${backImg[ _zoneController.zoneDoc.value!.page]}'
                        : 'assets/background/${backImg[ _zoneController.zoneDoc.value!.page]}',
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
                  padding: const EdgeInsets.only(top: 90.0,bottom: 140),
                  child:  _zoneController.zoneDoc.value!.page == 0
                      ? gridContent<RoomModel>(
                    objects:
                    _zoneDataController.zoneDataDoc.value?.rooms ?? [],
                    // Fetch rooms list
                    assetName: "rooms",
                    // Example asset name, adjust as needed
                    context: context,
                  )
                      :  _zoneController.zoneDoc.value!.page == 1
                      ? gridContent<WeaponModel>(
                      objects:
                      _zoneDataController.zoneDataDoc.value?.weapons ?? [],
                      assetName: "weapons",
                      context: context)
                      : gridContent<PersonModel>(
                      objects: _zoneDataController.zoneDataDoc.value
                          ?.persons ??
                          [],
                      assetName: "persons",
                      context: context),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height / 1.2),
                  child:  _zoneController.zoneDoc.value!.page == 0
                      ? SwipeableCardDeck<RoomModel>(
                    playersCards: _zoneGameController.zoneGameDoc.value
                        ?.getRoomsList() ??
                        [],
                  )
                      :  _zoneController.zoneDoc.value!.page == 1
                      ? SwipeableCardDeck<WeaponModel>(
                    playersCards: _zoneGameController.zoneGameDoc.value
                        ?.getWeaponsList() ?? [],
                  )
                      : SwipeableCardDeck<PersonModel>(
                    playersCards: _zoneGameController
                        .zoneGameDoc.value
                        ?.getPersonsList() ??
                        [],
                  ),
                ),
              ],
            ):Result(),
          );
        },
      ),
    );
  }
}
