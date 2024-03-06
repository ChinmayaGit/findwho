import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/database/Global.dart';

// class AssetInfo {
//   final String path;
//   final String name;
//   bool gray;
//
//   AssetInfo(this.path, this.name, this.gray);
// }
//
// List<AssetInfo> listRoom = [
//   AssetInfo('assets/room/Basement.jpg', 'Basement',false),
//   AssetInfo('assets/room/BathRoom.jpg', 'BathRoom',false),
//   AssetInfo('assets/room/Dining.jpg', 'Dining',false),
//   AssetInfo('assets/room/Kitchen.jpg', 'Kitchen',false),
//   AssetInfo('assets/room/Library.jpg', 'Library',false),
//   AssetInfo('assets/room/Pool.jpg', 'Pool',false),
//   AssetInfo('assets/room/Study.jpg', 'Study',false),
//   AssetInfo('assets/room/Garden.jpg', 'Garden',false),
//   AssetInfo('assets/room/Lounge.jpg', 'Lounge',false),
//   AssetInfo('assets/room/Hall.jpg', 'Hall',false),
//   // 10
// ];
// final List<AssetInfo> listWeapon = [
//   AssetInfo('assets/weapon/Bat.png', 'Bat',false),
//   AssetInfo('assets/weapon/Book.png', 'Book',false),
//   AssetInfo('assets/weapon/Broken Glass.png', 'Broken Glass',false),
//   AssetInfo('assets/weapon/Candle Stick.png', 'Candle Stick',false),
//   AssetInfo('assets/weapon/Cannon.png', 'Cannon',false),
//   AssetInfo('assets/weapon/Electricity.png', 'Electricity',false),
//   AssetInfo('assets/weapon/Gun.png', 'Gun',false),
//   AssetInfo('assets/weapon/Knife.png', 'Knife',false),
//   AssetInfo('assets/weapon/Mop.png', 'Mop',false),
//   AssetInfo('assets/weapon/Niddle.png', 'Niddle',false),
//   AssetInfo('assets/weapon/Rope.png', 'Rope',false),
//   AssetInfo('assets/weapon/Watermelon.png', 'Watermelon',false),
//   AssetInfo('assets/weapon/Pencil.png', 'Pencil',false),
//   AssetInfo('assets/weapon/Wire.png', 'Wire',false),
//   // 14
// ];
// final List<AssetInfo> listPerson = [
//   AssetInfo('assets/person/Miss Boo.jpg', 'Miss Boo',false),
//   AssetInfo('assets/person/Miss Moon.jpg', 'Miss Moon',false),
//   AssetInfo('assets/person/Miss Red.jpg', 'Miss Red'),
//   AssetInfo('assets/person/Miss White.jpg', 'Miss White'),
//   AssetInfo('assets/person/Mr Black.jpg', 'Mr Black',false),
//   AssetInfo('assets/person/Mr Blue.jpg', 'Mr Blue',false),
//   AssetInfo('assets/person/Mr Green.jpg', 'Mr Green'),
//   AssetInfo('assets/person/Mrs Peach.jpg', 'Mrs Peach',false),
//   AssetInfo('assets/person/Mrs Peacock.jpg', 'Mrs Peacock',false),
//   AssetInfo('assets/person/Mrs Rose.jpg', 'Mrs Rose',false),
//   AssetInfo('assets/person/Sargent Gray.jpg', 'Sargent Gray',false),
//   AssetInfo('assets/person/Sargent Mustache.jpg', 'Sargent Mustache',false),
//   // 12
// ];

class AssetInfo {
  final String img;
  final String name;
  bool state;

  AssetInfo(this.img, this.name, this.state);
}

List<AssetInfo> listRoom = [];
List<AssetInfo> listWeapon = [];
List<AssetInfo> listPerson = [];
List<AssetInfo> tempListRoom = [];
List<AssetInfo> tempListWeapon = [];
List<AssetInfo> tempListPerson = [];

// Fetch data from Firestore collections and store
Future<void> fetchItemsData() async {
  // Fetch data from Firestore collections
  QuerySnapshot roomSnapshot =
      await FirebaseFirestore.instance.collection('room').get();
  QuerySnapshot weaponSnapshot =
      await FirebaseFirestore.instance.collection('weapon').get();
  QuerySnapshot personSnapshot =
      await FirebaseFirestore.instance.collection('person').get();

  // Clear existing data
  tempListRoom.clear();
  tempListWeapon.clear();
  tempListPerson.clear();

  // Parse data from snapshots into AssetInfo instances
  tempListRoom.addAll(roomSnapshot.docs
      .map((doc) => AssetInfo(doc['img'], doc['name'], doc['state'])));
  tempListWeapon.addAll(weaponSnapshot.docs
      .map((doc) => AssetInfo(doc['img'], doc['name'], doc['state'])));
  tempListPerson.addAll(personSnapshot.docs
      .map((doc) => AssetInfo(doc['img'], doc['name'], doc['state'])));
}

// End
makeEqual() async {
  await fetchItemsData();

  // Calculate size of each sublist
  int roomSize = (tempListRoom.length / noOfPlayer).floor();
  int weaponSize = (tempListWeapon.length / noOfPlayer).floor();
  int personSize = (tempListPerson.length / noOfPlayer).floor();

  // Adjust sublist size to ensure even distribution of remainders
  int roomRemainder = tempListRoom.length % noOfPlayer;
  int weaponRemainder = tempListWeapon.length % noOfPlayer;
  int personRemainder = tempListPerson.length % noOfPlayer;

  // Clear existing data in final lists
  listRoom.clear();
  listWeapon.clear();
  listPerson.clear();

  // Store sublist based on user input
  for (int i = 0; i < tempListRoom.length - roomRemainder;) {
    listRoom.addAll(tempListRoom.sublist(i, min(i + roomSize, tempListRoom.length)));
    i += roomSize;
  }

  for (int i = 0; i < tempListWeapon.length - weaponRemainder;) {
    listWeapon.addAll(tempListWeapon.sublist(i, min(i + weaponSize, tempListWeapon.length)));
    i += weaponSize;
  }

  for (int i = 0; i < tempListPerson.length - personRemainder;) {
    listPerson.addAll(tempListPerson.sublist(i, min(i + personSize, tempListPerson.length)));
    i += personSize;
  }

  // Print the stored data
  print("listRoom:");
  print(listRoom.length);
  // listRoom.forEach((asset) {
  //   print(asset.img);
  //   print(asset.name);
  //   print(asset.state);
  // });

  print("listWeapon:");
  print(listWeapon.length);
  // listWeapon.forEach((asset) {
  //   print(asset.img);
  //   print(asset.name);
  //   print(asset.state);
  // });

  print("listPerson:");
  print(listPerson.length);
  // listPerson.forEach((asset) {
  //   print(asset.img);
  //   print(asset.name);
  //   print(asset.state);
  // });
  getSolution();
}

List<AssetInfo> solutionRoom = [];
List<AssetInfo> solutionWeapon = [];
List<AssetInfo> solutionPerson = [];

void getSolution() async {
  // Randomly select one item from listRoom

  if (listRoom.isNotEmpty) {
    int randomIndex = Random().nextInt(listRoom.length);
    // Add and remove value from index
    // AssetInfo room = listRoom.removeAt(randomIndex);
    AssetInfo room = listRoom[randomIndex];
    // Add the selected item to the solutionRoom list
    solutionRoom.clear(); // Clear the list before adding the new item
    solutionRoom.add(room);
  }

  // Randomly select one item from listWeapon
  if (listWeapon.isNotEmpty) {
    int randomIndex = Random().nextInt(listWeapon.length);
    // Add and remove value from index
    // AssetInfo room = listRoom.removeAt(randomIndex);
    AssetInfo room = listWeapon[randomIndex];
    // Add the selected item to the solutionRoom list
    solutionWeapon.clear(); // Clear the list before adding the new item
    solutionWeapon.add(room);
  }

  // Randomly select one item from listPerson
  if (listPerson.isNotEmpty) {
    int randomIndex = Random().nextInt(listPerson.length);
    // Add and remove value from index
    // AssetInfo room = listRoom.removeAt(randomIndex);
    AssetInfo room = listPerson[randomIndex];
    // Add the selected item to the solutionRoom list
    solutionPerson.clear(); // Clear the list before adding the new item
    solutionPerson.add(room);
  }

  // Print the length of solutionRoom and listRoom
  // print("Length of solutionRoom: ${solutionRoom.length}");
  // print("Length of solutionRoom: ${solutionWeapon.length}");
  // print("Length of solutionRoom: ${solutionPerson.length}");
  // print("Length of listRoom: ${listRoom.length}");
  // print("Length of listRoom: ${listWeapon.length}");
  // print("Length of listRoom: ${listPerson.length}");
  // print("Length of solutionRoom: ${solutionRoom[0].name}");

  WriteBatch batch = FirebaseFirestore.instance.batch();

  batch.set(
    FirebaseFirestore.instance.collection("zone").doc(invitationCode).collection('solution').doc('room'),
    {
      "img": solutionRoom[0].img,
      "name": solutionRoom[0].name,
      "state": solutionRoom[0].state,
    },
  );

  batch.set(
    FirebaseFirestore.instance.collection("zone").doc(invitationCode).collection('solution').doc('weapon'),
    {
      "img": solutionWeapon[0].img,
      "name": solutionWeapon[0].name,
      "state": solutionWeapon[0].state,
    },
  );

  batch.set(
    FirebaseFirestore.instance.collection("zone").doc(invitationCode).collection('solution').doc('person'),
    {
      "img": solutionPerson[0].img,
      "name": solutionPerson[0].name,
      "state": solutionPerson[0].state,
    },
  );

  await batch.commit();

}

void distributeInPlayer() {

}
