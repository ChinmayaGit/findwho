import 'dart:math';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/player/waitingLobby.dart';
import 'package:findwho/database/Global.dart';

class OnlinePlayers extends StatefulWidget {
  const OnlinePlayers({super.key});

  @override
  State<OnlinePlayers> createState() => _OnlinePlayersState();
}

class _OnlinePlayersState extends State<OnlinePlayers> {
  final randomNum = Random();
  int num = 0;
  bool nextPage = false;
  bool nextPlayer = false;
  bool rollDice = false;
  String playerNo = "";
  String playerColor = "";
  List<bool> colorBoxSelections = List.generate(6, (_) => false);

  void selectColor(int index, Color col) {
    setState(() {
      rollDice = true;
      playerColor = colorItems[index].col;
      playerNo = 'Player';
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
      body: Column(
        children: [
          GridView.builder(
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
                return colorBox(col: item.color, index: index);
              } else {
                return SizedBox(); // Empty SizedBox if color should not be shown
              }
            },
          ),
          rollDice == true
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
                  num == 0
                      ? DiceIcons.dice0
                      : num == 1
                      ? DiceIcons.dice1
                      : num == 2
                      ? DiceIcons.dice2
                      : num == 3
                      ? DiceIcons.dice3
                      : num == 4
                      ? DiceIcons.dice4
                      : num == 5
                      ? DiceIcons.dice5
                      : DiceIcons.dice6,
                  size: 120,
                ),
              ),
            ),
          )
              : Container(),
          rollDice == true
              ? nextPage == false
              ? GestureDetector(
            onTap: () {
              setState(() {
                num = randomNum.nextInt(6) + 1;
              });

              //TODO Here we will deside if the game is online or offline
              FirebaseFirestore.instance
                  .collection("zone")
                  .doc(invitationCode)
                  .collection("game")
                  .doc(authQuerySnapshot.data()!["uid"])
                  .update({
                'player': playerNo,
                'color': playerColor,
                'dice': num,
              });
              nextPage = true;
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
            onTap: () async{
              // selectChance();
              FirebaseFirestore.instance
                  .collection("zone")
                  .doc(invitationCode)
                  .update({
                'Colors.$playerColor': true
              });
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(authQuerySnapshot.data()!["uid"])
                  .update({
                "inGame": "waiting",
                "inviteId":invitationCode,
              });
              await getZone();
              await getZoneUserData();
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
      ),
    );
  }
}




