import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/components/LobbyComponents.dart';
import 'package:findwho/database/FetchAuth.dart';
import 'package:findwho/room/GameClose.dart';
import 'package:findwho/lobby/SelectBoard.dart';
import 'package:findwho/lobby/WaitingLobby.dart';
import 'package:findwho/room/HomePage.dart';
import 'package:flutter/material.dart';
import 'FetchData.dart';
import 'package:get/get.dart';
import "package:firebase_auth/firebase_auth.dart";

dynamic zoneUserData;
dynamic zone;

List<DocumentSnapshot> zoneData = [];

int readyCount=0;
int noOfPlayer = 0;

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
        .doc(authId)
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

Future<void> updateZone(Map<String, dynamic> newData) async {
  await FirebaseFirestore.instance
      .collection('zone')
      .doc(invitationCode)
      .update(newData);
}

Future<void> updateZoneUserData(Map<String, dynamic> newData) async {
  await FirebaseFirestore.instance
      .collection('zone')
      .doc(invitationCode)
      .collection("game")
      .doc(authId) // Assuming zoneUserData is a DocumentSnapshot
      .update(newData);
}