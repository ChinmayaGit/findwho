import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/database/Global.dart';
import 'package:findwho/database/GameMap.dart';
import 'package:flutter/material.dart';


final CollectionReference collectionRef =
FirebaseFirestore.instance.collection("room");

Future getData() async {
  try {
    await collectionRef.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        roomList.add(result.data());
      }
    });
    return roomList;
  } catch (e) {
    debugPrint("Error - $e");
    return null;
  }
}

sortPlayers() {
  //TODO here we are only doing two playes compare in future to have to do 4 player
  // authQuerySnapshot
  //     .data()!["dice"]
  //     .sort((a, b) => a['dice'].compareTo(b['dice']));
}

void distributeNames(List<AssetInfo> list1, List<AssetInfo> list2,
    List<AssetInfo> list3, int groups) {
  distributedNames = List.generate(groups, (_) => []);
  List<List<AssetInfo>> allLists = [list1, list2, list3];

  for (int i = 0; i < allLists.length; i++) {
    int groupIndex = i % groups;
    for (var assetInfo in allLists[i]) {
      distributedNames[groupIndex].add(assetInfo.name);
      groupIndex = (groupIndex + 1) % groups;
    }
  }
}

void getAndDistributeOffline(List<AssetInfo> list1, List<AssetInfo> list2,
    List<AssetInfo> list3, int groups) {
  List<String> selectedRoomNames = [];
  List<String> selectedWeaponNames = [];
  List<String> selectedPersonNames = [];
  List<Map<String, String>> selectedSolutions = [];
  List<List<AssetInfo>> allLists = [list1, list2, list3];

  distributeNames(list1, list2, list3, groups);

  for (var listIndex = 0; listIndex < allLists.length; listIndex++) {
    for (var assetInfo in allLists[listIndex]) {
      switch (listIndex) {
        case 0:
          selectedRoomNames.add(assetInfo.name);
          break;
        case 1:
          selectedWeaponNames.add(assetInfo.name);
          break;
        case 2:
          selectedPersonNames.add(assetInfo.name);
          break;
      }
    }
  }

  for (int i = 0; i < 1; i++) {
    final random = Random();
    final roomIndex = random.nextInt(selectedRoomNames.length);
    final weaponIndex = random.nextInt(selectedWeaponNames.length);
    final personIndex = random.nextInt(selectedPersonNames.length);

    selectedSolutions.add({
      "room": selectedRoomNames[roomIndex],
      "weapon": selectedWeaponNames[weaponIndex],
      "person": selectedPersonNames[personIndex],
    });

    selectedRoomNames.removeAt(roomIndex);
    selectedWeaponNames.removeAt(weaponIndex);
    selectedPersonNames.removeAt(personIndex);
  }

// Assuming selectedSolutions is a List<Map<String, String>>
  if (selectedSolutions.isNotEmpty) {
    FirebaseFirestore.instance.collection("zone").doc("Solution").set({
      "room": selectedSolutions[0]['room'],
      "weapon": selectedSolutions[0]['weapon'],
      "person": selectedSolutions[0]['person'],
    });
  }

  // print('Selected Room names: $selectedRoomNames');
  // print('Selected Weapon names: $selectedWeaponNames');
  // print('Selected Person names: $selectedPersonNames');
  // print('Selected Solutions: $selectedSolutions');

  selectedRoomNames.shuffle();
  selectedWeaponNames.shuffle();
  selectedPersonNames.shuffle();

  Map<String, List<String>> Player1 = {
    "room": [],
    "weapon": [],
    "person": [],
  };

  Map<String, List<String>> Player2 = {
    "room": [],
    "weapon": [],
    "person": [],
  };

  for (int i = 0; i < selectedRoomNames.length ~/ 2; i++) {
    Player1["room"]?.add(selectedRoomNames[i]);
    Player2["room"]?.add(selectedRoomNames[i + selectedRoomNames.length ~/ 2]);
  }

  for (int i = 0; i < selectedWeaponNames.length ~/ 2; i++) {
    Player1["weapon"]?.add(selectedWeaponNames[i]);
    Player2["weapon"]
        ?.add(selectedWeaponNames[i + selectedWeaponNames.length ~/ 2]);
  }

  for (int i = 0; i < selectedPersonNames.length ~/ 2; i++) {
    Player1["person"]?.add(selectedPersonNames[i]);
    Player2["person"]
        ?.add(selectedPersonNames[i + selectedPersonNames.length ~/ 2]);
  }
  FirebaseFirestore.instance.collection("zone").doc("Player1").set({
    "room": Player1["room"],
    "weapon": Player1["weapon"],
    "person": Player1["person"],
  });
  FirebaseFirestore.instance.collection("zone").doc("Player2").set({
    "room": Player2["room"],
    "weapon": Player2["weapon"],
    "person": Player2["person"],
  });

  fetchSolution();
}

Map<String, String> solution = {
  "room": "",
  "weapon": "",
  "person": "",
};

Future<void> fetchSolution() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("zone")
        .doc("Solution")
        .get();

    Map<String, dynamic>? data = snapshot.data();

    if (data != null) {
      solution['room'] = data['room'] ?? "";
      solution['weapon'] = data['weapon'] ?? "";
      solution['person'] = data['person'] ?? "";
    }

    print(solution);
  } catch (e) {
    print("Error fetching solution: $e");
    // Handle the error as needed
  }
}