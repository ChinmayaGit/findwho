import 'dart:math';
import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_controller.dart';
import 'package:findwho/Pages/lobby/waiting_lobby.dart';
import 'package:findwho/components/game_status.dart';
import 'package:findwho/components/colors.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/toast.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:findwho/Pages/Auth/auth_check.dart';

class ColorDicePicker extends StatefulWidget {
  final int maxPlayer;

  const ColorDicePicker({required this.maxPlayer});

  @override
  State<ColorDicePicker> createState() => _ColorDicePickerState();
}

class _ColorDicePickerState extends State<ColorDicePicker> {
  final randomNum = Random();
  int diceNumber = 0;
  bool nextPage = false;
  bool nextPlayer = false;
  bool rollDice = false;
  int playerNo = 0;
  String playerColor = "";
  List<bool> colorBoxSelections = List.generate(6, (_) => false);

  final UserController _userController = Get.put(UserController());
  final ZoneController _zoneController = Get.put(ZoneController());
  final ZoneGameController _zoneGameController = Get.put(ZoneGameController());
  bool localLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeZone();
  }

  void _initializeZone() async {
    await _zoneController
        .fetchZoneDocument(); // Wait for the data fetch to complete

    if (widget.maxPlayer == 0) {
      if (_zoneController.zoneDoc.value != null) {
        Map<String, dynamic>? colorsMap = _zoneController.zoneDoc.value?.colors;
        List<String> trueColors = [];
        colorsMap?.forEach((color, value) {
          if (value == true) {
            trueColors.add(color);
          }
        });
        colorItems.forEach((item) {
          if (trueColors.contains(item.col)) {
            item.show = false;
          }
        });
        // Navigate to the next screen
      } else {
        customToast(msg: "Invalid code", context: context);
      }
      await _zoneGameController.createZoneGameDocument();
    } else {
      await _zoneController.createZoneDocument(maxPlayer: widget.maxPlayer);
      await _zoneGameController.createZoneGameDocument();
    }
    setState(() {
      localLoading = true;
    });
  }

  void selectColor(int index, Color col) {
    setState(() {
      rollDice = true;
      playerColor = colorItems[index].col;
      GFToast.showToast(
        '$playerColor Selected',
        context,
        toastPosition: GFToastPosition.BOTTOM,
        textStyle: TextStyle(fontSize: 16, color: GFColors.WHITE),
        backgroundColor: GFColors.DARK,
        trailing: Icon(
          Icons.close,
          color: GFColors.SUCCESS,
        ),
      );
      // Update the selection state of the color box
      colorBoxSelections = List.generate(6, (i) => i == index);
    });
  }

  Widget colorBox({required Color col, required int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (!colorBoxSelections[index]) {
            selectColor(index, col);
          }
        },
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
            ),
            color: colorBoxSelections[index]
                ? Colors.transparent
                : col, // Disable color if selected
          ),
          height: 100,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
        centerTitle: true,
      ),
      body: localLoading == true
          ? Column(
              children: [
                selectColorWidget(),
                diceWidget(),
                rollDice == true
                    ? nextPage == false
                        ? GestureDetector(
                            onTap: () async {
                              setState(() {
                                diceNumber = randomNum.nextInt(6) + 1;
                              });
                              //TODO Here we will deside if the game is online or offline
                              await _zoneGameController.updateZoneGameDocument({
                                "color": playerColor,
                                "dice":
                                    diceNumber, // Update with actual data if available
                                "playerTurn": 0,
                              });
                              //ToDo:Turn decide
                              if (_zoneController
                                  .zoneDoc.value!.maxPlayers ==
                                  (_zoneGameController
                                      .zoneGameCollection.length)) {
                                await decideTurn();
                              }
                              setState(() {
                                nextPage = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black54,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text("Roll Dice"),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              _zoneController.updateZoneDocument(
                                  {'Colors.$playerColor': true});
                              _userController.updateUserDocument({
                                "inGame": GameStatusManager.waiting,
                                "inviteId": invitationCode,
                              });
                              Get.to(const WaitingLobby());
                            },
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.blue),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text("Next",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )
                    : Container(),
                const SizedBox(
                  height: 90,
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget selectColorWidget() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns in the grid
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      itemCount: colorItems.length,
      itemBuilder: (context, index) {
        ColorItem item = colorItems[index];
        if (item.show) {
          // print(item.color);
          return colorBox(col: item.color, index: index);
        } else {
          return SizedBox(); // Empty SizedBox if color should not be shown
        }
      },
    );
  }

  Widget diceWidget() {
    return rollDice == true
        ? Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  image: DecorationImage(
                    image: const AssetImage('assets/diceBoard.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Icon(
                  diceNumber == 0
                      ? DiceIcons.dice0
                      : diceNumber == 1
                          ? DiceIcons.dice1
                          : diceNumber == 2
                              ? DiceIcons.dice2
                              : diceNumber == 3
                                  ? DiceIcons.dice3
                                  : diceNumber == 4
                                      ? DiceIcons.dice4
                                      : diceNumber == 5
                                          ? DiceIcons.dice5
                                          : DiceIcons.dice6,
                  size: 120,
                ),
              ),
            ),
          )
        : Container();
  }
  decideTurn() async {
    List<Map<String, dynamic>> resultsList = [];
    for (int i = 0; i < _zoneGameController.zoneGameCollection.length; i++) {
      // Create a temporary map to store values for this iteration
      Map<String, dynamic> tempMap = {
        "dice": _zoneGameController.zoneGameCollection[i].dice,
        "uid": _zoneGameController.zoneGameCollection[i].uid,
      };
      resultsList.add(tempMap);
    }

    resultsList.sort((a, b) => b["dice"].compareTo(a["dice"]));

    for (int i = 0; i < resultsList.length; i++) {
      await _zoneGameController
          .updateZoneGameCollection(resultsList[i]["uid"], {
        "playerTurn": i + 1,
      });
    }
  }
}


