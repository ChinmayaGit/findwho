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

bool globalState = false;
int noOfPlayer = 0;

String invitationCode = "";
List<List<String>> distributedNames = [];

List roomList = [];
int readyCount=0;
FirebaseAuth auth = FirebaseAuth.instance;
var authQuerySnapshot;

dynamic zone;
List<DocumentSnapshot> zoneData = [];
dynamic zoneUserData;


//TODO Offline Code
// int playerCountTime = 1;

String generateInvitationCode() {
  final random = Random();
  final characters =
      'ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghijklmnpqrstuvwxyz123456789';
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
    await getZoneData();

    Get.to(const Home());
  } else if (inGame == "waiting") {
    await getZone();
    await getZoneData();
    await getZoneUserData();
    Get.to(WaitingLobby());
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
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('zone')
      .doc(invitationCode)
      .collection("game")
      .doc(authQuerySnapshot.data()!["uid"])
      .get();

  zoneUserData = snapshot.data();
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
