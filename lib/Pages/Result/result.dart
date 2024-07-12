import 'package:findwho/Pages/Exit/exit.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_controller.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_game_contoller.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:findwho/database/fetch_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Result extends StatelessWidget {
  Result({super.key});

  final Map<int, int> playerScores = {};
  final ZoneController _zoneController = Get.put(ZoneController());
  final ZoneGameController _zoneGameController = Get.put(ZoneGameController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Founded"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(Exit());
        },
        child: const Text("Exit"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Obx(()=>Row(
        children: _zoneGameController.zoneGameCollection.map((data) {
          playerScores.clear();
          if (data.playerTurn == _zoneController.zoneDoc.value!.solutionFound?['rooms']) {
            playerScores[data.playerTurn] =
                (playerScores[data.playerTurn] ?? 0) + 1;
          }

          // Increment player score if player matches the solution weapon
          if (data.playerTurn == _zoneController.zoneDoc.value!.solutionFound?["weapons"]) {
            playerScores[data.playerTurn] =
                (playerScores[data.playerTurn] ?? 0) + 1;
          }

          // Increment player score if player matches the solution person
          if (data.playerTurn == _zoneController.zoneDoc.value!.solutionFound?["persons"]) {
            playerScores[data.playerTurn] =
                (playerScores[data.playerTurn] ?? 0) + 1;
          }
          print(playerScores);
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(data.playerTurn.toString()),
                Divider(),
                Column(
                  children: [
                    data.playerTurn == _zoneController.zoneDoc.value!.solutionFound?["rooms"]
                        ? Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(solutionRoom[0].img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(solutionRoom[0].name)
                      ],
                    )
                        : Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                        ),
                        Text("")
                      ],
                    ),
                    data.playerTurn == _zoneController.zoneDoc.value!.solutionFound?["weapons"]
                        ? Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(solutionWeapon[0].img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(solutionWeapon[0].name)
                      ],
                    )
                        : Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                        ),
                        Text("")
                      ],
                    ),
                    data.playerTurn == _zoneController.zoneDoc.value!.solutionFound?["persons"]
                        ? Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(solutionPerson[0].img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(solutionPerson[0].name)
                      ],
                    )
                        : Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                        ),
                        Text("")
                      ],
                    ),
                  ],
                ),

                Divider(),
                Text(playerScores[data.playerTurn].toString()),
                Divider(),
                playerScores[data.playerTurn] == 2 ? Text("Winner") : Text("")
              ],
            ),
          );
        }).toList(),
      ),),
    );
  }
}
