// import 'dart:math';
// import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
// import 'package:findwho/Pages/Lobby/select_board.dart';
// import 'package:findwho/components/controller/zone_controller.dart';
// import 'package:findwho/Pages/lobby/waiting_lobby.dart';
// import 'package:findwho/components/game_status.dart';
// import 'package:findwho/components/colors.dart';
// import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
// import 'package:findwho/components/controller/zone_game_contoller.dart';
// import 'package:findwho/components/toast.dart';
// import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:dice_icons/dice_icons.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:findwho/database/fetch_zone.dart';
// import 'package:findwho/Pages/Auth/auth_check.dart';
//
// class ColorDicePicker extends StatefulWidget {
//   final int maxPlayer;
//
//   const ColorDicePicker({required this.maxPlayer});
//
//   @override
//   State<ColorDicePicker> createState() => _ColorDicePickerState();
// }
//
// class _ColorDicePickerState extends State<ColorDicePicker> {
//   final randomNum = Random();
//   int diceNumber = 0;
//   bool nextPage = false;
//   bool nextPlayer = false;
//   bool rollDice = false;
//   int playerNo = 0;
//   String playerColor = "";
//   List<bool> colorBoxSelections = List.generate(6, (_) => false);
//
//   final UserController _userController = Get.put(UserController());
//   final ZoneController _zoneController = Get.put(ZoneController());
//   final ZoneGameController _zoneGameController = Get.put(ZoneGameController());
//   bool localLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeZone();
//   }
//
//   void _initializeZone() async {
//     if (widget.maxPlayer == 0) {
//       await _zoneController.fetchZoneDocument();
//       if (_zoneController.zoneDoc.value != null) {
//         // Current code to set up color selections, etc.
//       } else {
//         customToast(msg: "Invalid code", context: context);
//       }
//       await _zoneGameController.createZoneGameDocument();
//     } else {
//       await _zoneController.createZoneDocument(maxPlayer: widget.maxPlayer);
//       await _zoneGameController.createZoneGameDocument();
//     }
//
//     // **Add an exit handler here**: Update Firestore if the player wants to leave.
//     setState(() {
//       localLoading = false;
//     });
//   }
//
//
//   void selectColor(int index, Color col) {
//     setState(() {
//       rollDice = true;
//       playerColor = colorItems[index].col;
//       GFToast.showToast(
//         '$playerColor Selected',
//         context,
//         toastPosition: GFToastPosition.BOTTOM,
//         textStyle: TextStyle(fontSize: 16, color: GFColors.WHITE),
//         backgroundColor: GFColors.DARK,
//         trailing: Icon(
//           Icons.close,
//           color: GFColors.SUCCESS,
//         ),
//       );
//       // Update the selection state of the color box
//       colorBoxSelections = List.generate(6, (i) => i == index);
//     });
//   }
//
//   Widget colorBox({required Color col, required int index}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GestureDetector(
//         onTap: () {
//           if (!colorBoxSelections[index]) {
//             selectColor(index, col);
//           }
//         },
//         child: Container(
//           decoration: ShapeDecoration(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(9.0),
//             ),
//             color: colorBoxSelections[index]
//                 ? Colors.transparent
//                 : col, // Disable color if selected
//           ),
//           height: 100,
//         ),
//       ),
//     );
//   }
//   handlePlayerExit() async {
//     await _zoneController.updateZoneDocument({
//       "players.${_userController.userDocument.id}.inGame": false,
//     });
//     setState(() {
//       nextPage = false;
//       rollDice = false;
//       playerColor = ""; // Reset the color if desired
//       colorBoxSelections = List.generate(6, (_) => false); // Reset color selections
//     });
//     // Navigate back to main screen or exit lobby
//     Get.offAll(SelectBoard());
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Player"),
//         centerTitle: true,
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               await handlePlayerExit(); // Call your custom exit handler
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Icon(Icons.exit_to_app, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: localLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           selectColorWidget(),
//           diceWidget(),
//           if (rollDice && !nextPage)
//             GestureDetector(
//               onTap: () async {
//                 setState(() {
//                   diceNumber = randomNum.nextInt(6) + 1;
//                 });
//                 await _zoneGameController.updateZoneGameDocument({
//                   "color": playerColor,
//                   "dice": diceNumber,
//                   "playerTurn": 0,
//                 });
//                 if (_zoneController.zoneDoc.value!.maxPlayers ==
//                     _zoneGameController.zoneGameCollection.length) {
//                   await decideTurn();
//                 }
//                 setState(() {
//                   nextPage = true;
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black54),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(18.0),
//                   child: Text("Roll Dice"),
//                 ),
//               ),
//             ),
//           if (nextPage)
//             GestureDetector(
//               onTap: () async {
//                 _zoneController.updateZoneDocument(
//                     {'Colors.$playerColor': true});
//                 _userController.updateUserDocument({
//                   "inGame": GameStatusManager.waiting,
//                   "inviteId": invitationCode,
//                 });
//                 Get.to(const WaitingLobby());
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(18.0),
//                   child: Text(
//                     "Next",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           // Adding the Exit button at the bottom
//           Spacer(),
//           GestureDetector(
//             onTap: () async {
//               await handlePlayerExit(); // Call your custom exit handler
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(18.0),
//                 child: Text(
//                   "Exit Game",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//
//   Widget selectColorWidget() {
//     return GridView.builder(
//       shrinkWrap: true,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3, // Number of columns in the grid
//         crossAxisSpacing: 8.0, // Spacing between columns
//         mainAxisSpacing: 8.0, // Spacing between rows
//       ),
//       itemCount: colorItems.length,
//       itemBuilder: (context, index) {
//         ColorItem item = colorItems[index];
//         if (item.show) {
//           // print(item.color);
//           return colorBox(col: item.color, index: index);
//         } else {
//           return SizedBox(); // Empty SizedBox if color should not be shown
//         }
//       },
//     );
//   }
//
//   Widget diceWidget() {
//     return rollDice == true
//         ? Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: Get.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(18.0),
//                   image: DecorationImage(
//                     image: const AssetImage('assets/diceBoard.jpg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Icon(
//                   diceNumber == 0
//                       ? DiceIcons.dice0
//                       : diceNumber == 1
//                           ? DiceIcons.dice1
//                           : diceNumber == 2
//                               ? DiceIcons.dice2
//                               : diceNumber == 3
//                                   ? DiceIcons.dice3
//                                   : diceNumber == 4
//                                       ? DiceIcons.dice4
//                                       : diceNumber == 5
//                                           ? DiceIcons.dice5
//                                           : DiceIcons.dice6,
//                   size: 120,
//                 ),
//               ),
//             ),
//           )
//         : Container();
//   }
//   decideTurn() async {
//     List<Map<String, dynamic>> resultsList = [];
//     for (int i = 0; i < _zoneGameController.zoneGameCollection.length; i++) {
//       // Create a temporary map to store values for this iteration
//       Map<String, dynamic> tempMap = {
//         "dice": _zoneGameController.zoneGameCollection[i].dice,
//         "uid": _zoneGameController.zoneGameCollection[i].uid,
//       };
//       resultsList.add(tempMap);
//     }
//
//     resultsList.sort((a, b) => b["dice"].compareTo(a["dice"]));
//
//     for (int i = 0; i < resultsList.length; i++) {
//       await _zoneGameController
//           .updateZoneGameCollection(resultsList[i]["uid"], {
//         "playerTurn": i + 1,
//       });
//     }
//   }
//
//
// }

import 'dart:math';
import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Lobby/select_board.dart';
import 'package:findwho/components/controller/zone_controller.dart';
import 'package:findwho/Pages/lobby/waiting_lobby.dart';
import 'package:findwho/components/game_status.dart';
import 'package:findwho/components/colors.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/toast.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool rollDice = false;
  String playerColor = "";
  List<bool> colorBoxSelections = List.generate(6, (_) => false);
  List<String> selectedColors = [];

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
    if (widget.maxPlayer == 0) {
      await _zoneController.fetchZoneDocument();
      if (_zoneController.zoneDoc.value != null) {
        // Fetch selected colors from Firestore
        Map<String, dynamic> colors = _zoneController.zoneDoc.value!.colors ?? {};
        selectedColors = colors.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key)
            .toList();
      } else {
        customToast(msg: "Invalid code", context: context);
      }
      await _zoneGameController.createZoneGameDocument();
    } else {
      await _zoneController.createZoneDocument(maxPlayer: widget.maxPlayer);
      await _zoneGameController.createZoneGameDocument();
    }

    setState(() {
      localLoading = false;
    });
  }

  void selectColor(int index, Color col) {
    setState(() {
      rollDice = true;
      playerColor = colorItems[index].col;

      // Mark color as selected
      selectedColors.add(playerColor);

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

      // Update Firestore
      _zoneController.updateZoneDocument({
        "Colors.$playerColor": true,
      });

      // Update colorBoxSelections to reflect the current selection
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

  Widget selectColorWidget() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: colorItems.length,
      itemBuilder: (context, index) {
        ColorItem item = colorItems[index];
        if (item.show && !selectedColors.contains(item.col)) {
          return colorBox(col: item.color, index: index);
        } else {
          return SizedBox(); // Hide already selected colors
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

  void handlePlayerExit() async {
    await _zoneController.updateZoneDocument({
      "players.${_userController.userDocument.id}.inGame": false,
    });
    setState(() {
      nextPage = false;
      rollDice = false;
      playerColor = "";
      colorBoxSelections = List.generate(6, (_) => false);
    });
    Get.offAll(SelectBoard());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              // await handlePlayerExit();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ),
        ],
      ),
      body: localLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                selectColorWidget(),
                diceWidget(),
                if (rollDice && !nextPage)
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        diceNumber = randomNum.nextInt(6) + 1;
                      });
                      await _zoneGameController.updateZoneGameDocument({
                        "color": playerColor,
                        "dice": diceNumber,
                        "playerTurn": 0,
                      });
                      if (_zoneController.zoneDoc.value!.maxPlayers ==
                          _zoneGameController.zoneGameCollection.length) {
                        await decideTurn();
                      }
                      setState(() {
                        nextPage = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Roll Dice"),
                      ),
                    ),
                  ),
                if (nextPage)
                  GestureDetector(
                    onTap: () async {
                      _zoneController
                          .updateZoneDocument({'Colors.$playerColor': true});
                      _userController.updateUserDocument({
                        "inGame": GameStatusManager.waiting,
                        "inviteId": invitationCode,
                      });
                      Get.to(const WaitingLobby());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Adding the Exit button at the bottom
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    // await handlePlayerExit(); // Call your custom exit handler
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        "Exit Game",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
