// import 'dart:math';
// import 'package:findwho/login/AuthGlobal.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:findwho/database/Global.dart';
// import 'package:flutter/material.dart';
// import 'package:dice_icons/dice_icons.dart';
// import 'package:get/get.dart';
// import '../room/HomePage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class OfflinePlayers extends StatefulWidget {
//   const OfflinePlayers({super.key});
//
//   @override
//   State<OfflinePlayers> createState() => _OfflinePlayersState();
// }
//
// class _OfflinePlayersState extends State<OfflinePlayers> {
//   final randomNum = Random();
//   int num = 0;
//   bool nextPage = false;
//   bool nextPlayer = false;
//   bool rollDice = false;
//   String playerNo = "";
//   String playerColor = "";
//   List<bool> colorBoxSelections = List.generate(6, (_) => false);
//
//   void selectColor(int index, Color col) {
//     if (playerCountTime <= noOfPlayer) {
//       setState(() {
//         rollDice = true;
//         playerColor = getColorName(col);
//         playerNo = 'Player $playerCountTime';
//         GFToast.showToast(
//           '$playerColor Selected',
//           context,
//           toastPosition: GFToastPosition.BOTTOM,
//           textStyle: TextStyle(fontSize: 16, color: GFColors.WHITE),
//           backgroundColor: GFColors.DARK,
//           trailing: Icon(
//             Icons.close,
//             color: GFColors.SUCCESS,
//           ),
//         );
//         // Update the selection state of the color box
//         colorBoxSelections = List.generate(6, (i) => i == index);
//       });
//     } else {
//       setState(() {
//         nextPage = true;
//       });
//     }
//   }
//
//   Widget colorBox({required Color col, required int index}) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GestureDetector(
//           onTap: () {
//             if (!colorBoxSelections[index]) {
//               selectColor(index, col);
//             }
//           },
//           child: Container(
//             decoration: ShapeDecoration(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(9.0),
//               ),
//               color: colorBoxSelections[index]
//                   ? Colors.transparent
//                   : col, // Disable color if selected
//             ),
//             height: 100,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Player $playerCountTime"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               colorBox(col: Colors.red, index: 0),
//               colorBox(col: Colors.green, index: 1),
//               colorBox(col: Colors.blue, index: 2),
//             ],
//           ),
//           Row(
//             children: [
//               colorBox(col: Colors.yellow, index: 3),
//               colorBox(col: Colors.orange, index: 4),
//               colorBox(col: Colors.purple, index: 5),
//             ],
//           ),
//           rollDice == true
//               ? Expanded(
//                   flex: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       width: Get.width,
//                       decoration: ShapeDecoration(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18.0),
//                           ),color: Colors.brown
//                       ),
//                       child: Icon(
//                         num == 0
//                             ? DiceIcons.dice0
//                             : num == 1
//                                 ? DiceIcons.dice1
//                                 : num == 2
//                                     ? DiceIcons.dice2
//                                     : num == 3
//                                         ? DiceIcons.dice3
//                                         : num == 4
//                                             ? DiceIcons.dice4
//                                             : num == 5
//                                                 ? DiceIcons.dice5
//                                                 : DiceIcons.dice6,
//                         size: 120,
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(),
//           rollDice == true
//               ? nextPage == false
//                   ? nextPlayer == false
//                       ? GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               num = randomNum.nextInt(6) + 1;
//                             });
//                             // TODO In Game code here
//                             // FirebaseFirestore.instance
//                             //     .collection("users")
//                             //     .doc(authQuerySnapshot.data()!["uid"])
//                             //     .update({
//                             //   "inGame": true,
//                             // });
//                             //TODO Here we will deside if the game is online or offline
//                             FirebaseFirestore.instance
//                                 .collection("zone")
//                                 .doc(authQuerySnapshot.data()!["uid"])
//                                 .set({
//                               'player': playerNo,
//                               'color': playerColor,
//                               'dice': num,
//                               "room": "na",
//                               "weapon": "na",
//                               "person": "na",
//                               "uid": authQuerySnapshot.data()!["uid"],
//                               "turn": 0,
//                             });
//
//                             if (playerCountTime < noOfPlayer) {
//                               nextPlayer = true;
//                             } else {
//                               nextPage = true;
//                             }
//                             GFToast.showToast(
//                               'Pass to next Player',
//                               context,
//                               toastPosition: GFToastPosition.BOTTOM,
//                               textStyle: TextStyle(
//                                   fontSize: 16, color: GFColors.WHITE),
//                               backgroundColor: GFColors.DARK,
//                               trailing: const Icon(
//                                 Icons.close,
//                                 color: GFColors.SUCCESS,
//                               ),
//                             );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Colors.black54,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20))),
//                             child: const Padding(
//                               padding: EdgeInsets.all(18.0),
//                               child: Text("Roll Dice"),
//                             ),
//                           ),
//                         )
//                       : GestureDetector(
//                           onTap: () {
//                             Get.to(OfflinePlayers());
//                             setState(() {
//                               nextPlayer = false;
//                               playerCountTime++;
//                             });
//                           },
//                           child: Container(
//                             decoration: ShapeDecoration(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(18.0),
//                                 ),
//                                 color: Colors.blue),
//                             child: const Padding(
//                               padding: EdgeInsets.all(18.0),
//                               child: Text(
//                                 "Pass",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         )
//                   : GestureDetector(
//                       onTap: () {
//                         selectChance();
//                         Get.to(const Home());
//                       },
//                       child: Container(
//                         decoration: ShapeDecoration(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18.0),
//                             ),
//                             color: Colors.blue),
//                         child: const Padding(
//                           padding: EdgeInsets.all(18.0),
//                           child: Text("Next",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold)),
//                         ),
//                       ),
//                     )
//               : Container(),
//           const SizedBox(
//             height: 90,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// String getColorName(Color color) {
//   if (color == Colors.red) {
//     return "Red";
//   } else if (color == Colors.blue) {
//     return "Blue";
//   } else if (color == Colors.green) {
//     return "Green";
//   } else if (color == Colors.yellow) {
//     return "Yellow";
//   } else if (color == Colors.orange) {
//     return "Orange";
//   } else if (color == Colors.purple) {
//     return "Purple";
//   } else {
//     return "Unknown";
//   }
// }
