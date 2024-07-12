// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
// import 'package:findwho/Pages/Auth/auth_check.dart';
// import 'package:flutter/material.dart';
// import 'fetch_data.dart';
// import 'package:get/get.dart';
// import "package:firebase_auth/firebase_auth.dart";

// int noOfPlayer = 0;

// dynamic zoneUserData;
// var zone = {}.obs;
// var isLoading = true.obs;
// List<DocumentSnapshot> zoneGame = [];
//

//
// getZone() {
//   FirebaseFirestore.instance
//       .collection('zone')
//       .doc(invitationCode)
//       .snapshots()
//       .listen((DocumentSnapshot snapshot) {
//     if (snapshot.exists) {
//       zone.value = snapshot.data() as Map<String, dynamic>;
//     }
//     isLoading.value = false;
//   });
// }
//
// Future<void> getZoneGame() async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('zone')
//       .doc(invitationCode)
//       .collection("game")
//       .get();
//   zoneGame = querySnapshot.docs;
// }
//
// Future<void> getZoneUserData() async {
//   try {
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//         .collection('zone')
//         .doc(invitationCode)
//         .collection("game")
//         .doc(authUid)
//         .get();
//
//     // Update zoneUserData directly with the retrieved data
//     zoneUserData = snapshot.data();
//
//     // Populate playersRoom, playersWeapon, and playersPerson lists
//     playersRoom = (zoneUserData['rooms'] as List<dynamic>? ?? []).map((item) =>
//         AssetInfo(item['img'], item['name'], item['state'])).toList();
//
//     playersWeapon = (zoneUserData['weapons'] as List<dynamic>? ?? []).map((item) =>
//         AssetInfo(item['img'], item['name'], item['state'])).toList();
//
//     playersPerson = (zoneUserData['persons'] as List<dynamic>? ?? []).map((item) =>
//         AssetInfo(item['img'], item['name'], item['state'])).toList();
//
//   } catch (e) {
//     print("Error getting zone user data: $e");
//   }
// }
//
// Future<void> updateZone(Map<String, dynamic> newData) async {
//   await FirebaseFirestore.instance
//       .collection('zone')
//       .doc(invitationCode)
//       .update(newData);
// }
//
// Future<void> updateZoneUserData(Map<String, dynamic> newData) async {
//   await FirebaseFirestore.instance
//       .collection('zone')
//       .doc(invitationCode)
//       .collection("game")
//       .doc(authUid) // Assuming zoneUserData is a DocumentSnapshot
//       .update(newData);
// }
//
// void setupTurnListener() {
//   FirebaseFirestore.instance
//       .collection('zone')
//       .doc(invitationCode)
//       .snapshots()
//       .listen((DocumentSnapshot snapshot) {
//     if (snapshot.exists) {
//       var data = snapshot.data() as Map<String, dynamic>;
//       now.value = data['Turn'];
//     }
//   });
// }