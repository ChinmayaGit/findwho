//Offline

// sortPlayers() {
//   //TODO here we are only doing two playes compare in future to have to do 4 player
//   // authQuerySnapshot
//   //     .data()!["dice"]
//   //     .sort((a, b) => a['dice'].compareTo(b['dice']));
// }
// void distributeNames(List<AssetInfo> list1, List<AssetInfo> list2,
//     List<AssetInfo> list3, int groups) {
//   distributedNames = List.generate(groups, (_) => []);
//   List<List<AssetInfo>> allLists = [list1, list2, list3];
//
//   for (int i = 0; i < allLists.length; i++) {
//     int groupIndex = i % groups;
//     for (var assetInfo in allLists[i]) {
//       distributedNames[groupIndex].add(assetInfo.name);
//       groupIndex = (groupIndex + 1) % groups;
//     }
//   }
// }

// Future<void> fetchSolution() async {
//   try {
//     DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//         .instance
//         .collection("zone")
//         .doc("Solution")
//         .get();
//
//     Map<String, dynamic>? data = snapshot.data();
//
//     if (data != null) {
//       solution['rooms'] = data['rooms'] ?? "";
//       solution['weapons'] = data['weapons'] ?? "";
//       solution['persons'] = data['persons'] ?? "";
//     }
//
//     print(solution);
//   } catch (e) {
//     print("Error fetching solution: $e");
//     // Handle the error as needed
//   }
// }
// Map<String, String> solution = {
//   "rooms": "",
//   "weapons": "",
//   "persons": "",
// };
// void getAndDistributeOffline(List<AssetInfo> list1, List<AssetInfo> list2,
//     List<AssetInfo> list3, int groups) {
//   List<String> selectedRoomNames = [];
//   List<String> selectedWeaponNames = [];
//   List<String> selectedPersonNames = [];
//   List<Map<String, String>> selectedSolutions = [];
//   List<List<AssetInfo>> allLists = [list1, list2, list3];
//
//   distributeNames(list1, list2, list3, groups);
//
//   for (var listIndex = 0; listIndex < allLists.length; listIndex++) {
//     for (var assetInfo in allLists[listIndex]) {
//       switch (listIndex) {
//         case 0:
//           selectedRoomNames.add(assetInfo.name);
//           break;
//         case 1:
//           selectedWeaponNames.add(assetInfo.name);
//           break;
//         case 2:
//           selectedPersonNames.add(assetInfo.name);
//           break;
//       }
//     }
//   }
//
//   for (int i = 0; i < 1; i++) {
//     final random = Random();
//     final roomIndex = random.nextInt(selectedRoomNames.length);
//     final weaponIndex = random.nextInt(selectedWeaponNames.length);
//     final personIndex = random.nextInt(selectedPersonNames.length);
//
//     selectedSolutions.add({
//       "rooms": selectedRoomNames[roomIndex],
//       "weapons": selectedWeaponNames[weaponIndex],
//       "persons": selectedPersonNames[personIndex],
//     });
//
//     selectedRoomNames.removeAt(roomIndex);
//     selectedWeaponNames.removeAt(weaponIndex);
//     selectedPersonNames.removeAt(personIndex);
//   }
//
// // Assuming selectedSolutions is a List<Map<String, String>>
//   if (selectedSolutions.isNotEmpty) {
//     FirebaseFirestore.instance.collection("zone").doc("Solution").set({
//       "rooms": selectedSolutions[0]['rooms'],
//       "weapons": selectedSolutions[0]['weapons'],
//       "persons": selectedSolutions[0]['persons'],
//     });
//   }
//
//   // print('Selected Room names: $selectedRoomNames');
//   // print('Selected Weapon names: $selectedWeaponNames');
//   // print('Selected Person names: $selectedPersonNames');
//   // print('Selected Solutions: $selectedSolutions');
//
//   selectedRoomNames.shuffle();
//   selectedWeaponNames.shuffle();
//   selectedPersonNames.shuffle();
//
//   Map<String, List<String>> Player1 = {
//     "rooms": [],
//     "weapons": [],
//     "persons": [],
//   };
//
//   Map<String, List<String>> Player2 = {
//     "rooms": [],
//     "weapons": [],
//     "persons": [],
//   };
//
//   for (int i = 0; i < selectedRoomNames.length ~/ 2; i++) {
//     Player1["rooms"]?.add(selectedRoomNames[i]);
//     Player2["rooms"]?.add(selectedRoomNames[i + selectedRoomNames.length ~/ 2]);
//   }
//
//   for (int i = 0; i < selectedWeaponNames.length ~/ 2; i++) {
//     Player1["weapons"]?.add(selectedWeaponNames[i]);
//     Player2["weapons"]
//         ?.add(selectedWeaponNames[i + selectedWeaponNames.length ~/ 2]);
//   }
//
//   for (int i = 0; i < selectedPersonNames.length ~/ 2; i++) {
//     Player1["persons"]?.add(selectedPersonNames[i]);
//     Player2["persons"]
//         ?.add(selectedPersonNames[i + selectedPersonNames.length ~/ 2]);
//   }
//   FirebaseFirestore.instance.collection("zone").doc("Player1").set({
//     "rooms": Player1["rooms"],
//     "weapons": Player1["weapons"],
//     "persons": Player1["persons"],
//   });
//   FirebaseFirestore.instance.collection("zone").doc("Player2").set({
//     "rooms": Player2["rooms"],
//     "weapons": Player2["weapons"],
//     "persons": Player2["persons"],
//   });
//
//   fetchSolution();
// }