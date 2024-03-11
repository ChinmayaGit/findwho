import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/player/selectBoard.dart';
import 'package:findwho/player/waitingLobby.dart';
import 'package:findwho/room/HomePage.dart';
import 'package:flutter/material.dart';
import '../room/ListPage.dart';
import 'package:get/get.dart';
import "package:firebase_auth/firebase_auth.dart";

FirebaseAuth auth = FirebaseAuth.instance;

dynamic authQuerySnapshot;
dynamic zoneUserData;
dynamic zone;
List<List<String>> distributedNames = [];
List<DocumentSnapshot> zoneData = [];
List roomList = [];
int readyCount=0;
int noOfPlayer = 0;
bool globalState = false;
String invitationCode = "";

//TODO Offline Code
// int playerCountTime = 1;

String generateInvitationCode() {
  final random = Random();
  const characters =
      'ABCDEFGHJKMNPQRSTUVWXYZ123456789';
  final randomCharacters =
      List.generate(3, (_) => characters[random.nextInt(characters.length)]);
  final randomIntegers = List.generate(2, (_) => random.nextInt(10));
  final invitationCode =
      '${randomCharacters.join('')}${randomIntegers.join('')}';

  return invitationCode;
}

Future<void> checkPlace() async {
  String? inGame = authQuerySnapshot.data()!["inGame"];
  invitationCode = authQuerySnapshot.data()!["inviteId"];

  if (inGame == "true") {
    await getZone();
    noOfPlayer=zone['PlayerCount'];
    await getZoneData();
    await getZoneUserData();
    await fetchDataIfGameClosed();
    await fetchSolutionIfGameClosed();
    //create player turn
    // playersTurn.clear();
    // for(int i=0;i<zoneData.length;i++) {
    //   playersTurn.add(Player( name: zoneData[i]['player'],
    //       turnOrder: zoneData[i]['turn']));
    // }
    // for (var player in playersTurn) {
    //   print('Name: ${player.name}, FTurn Order: ${player.turnOrder}');
    // }
    Get.to(const Home());
  } else if (inGame == "waiting") {
    await getZone();
    noOfPlayer=zone['PlayerCount'];
    await getZoneData();
    await getZoneUserData();
    Get.to(const WaitingLobby());
  } else {
    Get.to(SelectBoard());
  }
}

Future<void> getZone() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('zone')
        .doc(invitationCode)
        .get();

    if (snapshot.exists) {
      zone = snapshot.data();
    } else {
      print("Document with invitation code $invitationCode does not exist.");
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
}

Future<void> getZoneData() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('zone')
      .doc(invitationCode)
      .collection("game")
      .get();
  zoneData = querySnapshot.docs;
}

Future<void> getZoneUserData() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('zone')
        .doc(invitationCode)
        .collection("game")
        .doc(authQuerySnapshot.data()!["uid"])
        .get();

    // Update zoneUserData directly with the retrieved data
    zoneUserData = snapshot.data();

    // Populate playersRoom, playersWeapon, and playersPerson lists
    playersRoom = (zoneUserData['room'] as List<dynamic>? ?? []).map((item) =>
        AssetInfo(item['img'], item['name'], item['state'])).toList();

    playersWeapon = (zoneUserData['weapon'] as List<dynamic>? ?? []).map((item) =>
        AssetInfo(item['img'], item['name'], item['state'])).toList();

    playersPerson = (zoneUserData['person'] as List<dynamic>? ?? []).map((item) =>
        AssetInfo(item['img'], item['name'], item['state'])).toList();

  } catch (e) {
    print("Error getting zone user data: $e");
  }
}

Future<void> updateZoneUserData(Map<String, dynamic> newData) async {
  await FirebaseFirestore.instance
      .collection('zone')
      .doc(invitationCode)
      .collection("game")
      .doc(authQuerySnapshot.data()!["uid"]) // Assuming zoneUserData is a DocumentSnapshot
      .update(newData);
}

class ColorItem {
  final Color color;
  final String col;
  bool show;

  ColorItem({required this.color, required this.show, required this.col});
}

List<ColorItem> colorItems = [
  ColorItem(color: Colors.red, show: true, col: "Red"),
  ColorItem(color: Colors.green, show: true, col: "Green"),
  ColorItem(color: Colors.blue, show: true, col: "Blue"),
  ColorItem(color: Colors.yellow, show: true, col: "Yellow"),
  ColorItem(color: Colors.orange, show: true, col: "Orange"),
  ColorItem(color: Colors.purple, show: true, col: "Purple"),
];

Color stringToColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    default:
      return Colors.transparent; // Default color if not found
  }
}


class Player {
  String name;
  int turnOrder; // Turn order determined by dice roll
  bool isTurnOver;

  Player({required this.name, required this.turnOrder, this.isTurnOver = false});
}
List<Player> playersTurn = [];

int currentPlayerIndex = 1; // Index of the current player

// Function to find the next player whose turn is not over
int getNextPlayerIndex() {
  int nextPlayerIndex = (currentPlayerIndex + 1) % playersTurn.length;
  while (playersTurn[nextPlayerIndex].isTurnOver) {
    nextPlayerIndex = (nextPlayerIndex + 1) % playersTurn.length;
  }
  return nextPlayerIndex;
}

// Function to transfer the turn to the next player
void transferTurn() {
  playersTurn[currentPlayerIndex].isTurnOver = true; // Mark current player's turn as over
  currentPlayerIndex = getNextPlayerIndex(); // Find the index of the next player
  playersTurn[currentPlayerIndex].isTurnOver = false; // Set the next player's turn as active
}


RxBool createWait=false.obs;