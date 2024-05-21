import 'package:findwho/database/FetchZone.dart';
import 'package:findwho/database/FetchData.dart';
import 'package:findwho/room/GameClose.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Result extends StatelessWidget {
  Result({super.key});

  Map<String, int> playerScores = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Founded"),
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Get.to(GameCloser(text: "true"));
        },
        child: const Text("Exit"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Row(
        children: zoneData.map((data) {
          playerScores.clear();
          if (data["player"] == zone["solutionFound"]["room"]) {
            playerScores[data["player"]] =
                (playerScores[data["player"]] ?? 0) + 1;
          }

          // Increment player score if player matches the solution weapon
          if (data["player"] == zone["solutionFound"]["weapon"]) {
            playerScores[data["player"]] =
                (playerScores[data["player"]] ?? 0) + 1;
          }

          // Increment player score if player matches the solution person
          if (data["player"] == zone["solutionFound"]["person"]) {
            playerScores[data["player"]] =
                (playerScores[data["player"]] ?? 0) + 1;
          }
          print(playerScores);
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(data["player"]),
                Divider(),
                Column(
                  children: [
                    data["player"] == zone["solutionFound"]["room"]
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
                    data["player"] == zone["solutionFound"]["weapon"]
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
                    data["player"] == zone["solutionFound"]["person"]
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
                Text(playerScores[data["player"]].toString()),
                Divider(),
                playerScores[data["player"]].toString() == "2" ? Text("Winner") : Text("")
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
