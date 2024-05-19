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

  // Convert AssetInfo to a map
  Map<String, dynamic> toMap() {
    return {
      'img': img,
      'name': name,
      'state': state,
    };
  }
}

List<AssetInfo> listRoom = [];
List<AssetInfo> listWeapon = [];
List<AssetInfo> listPerson = [];

List<AssetInfo> tempListRoom = [];
List<AssetInfo> tempListWeapon = [];
List<AssetInfo> tempListPerson = [];

List<AssetInfo> playersRoom = [];
List<AssetInfo> playersWeapon = [];
List<AssetInfo> playersPerson = [];

List<AssetInfo> solutionRoom = [];
List<AssetInfo> solutionWeapon = [];
List<AssetInfo> solutionPerson = [];

// Fetch data from Firestore collections and store
Future<void> createItemsData() async {
  DocumentSnapshot<Map<String, dynamic>> dataSnapshot =
      await FirebaseFirestore.instance.collection('data').doc('rwp').get();

// Clear existing data
  tempListRoom.clear();
  tempListWeapon.clear();
  tempListPerson.clear();

// Parse data from snapshot into AssetInfo instances
  Map<String, dynamic> data = dataSnapshot.data()!;
  tempListRoom.addAll((data['rooms'] as List<dynamic>)
      .map((room) => AssetInfo(room['img'], room['name'], room['state'])));
  tempListWeapon.addAll((data['weapons'] as List<dynamic>).map(
      (weapon) => AssetInfo(weapon['img'], weapon['name'], weapon['state'])));
  tempListPerson.addAll((data['persons'] as List<dynamic>).map(
      (person) => AssetInfo(person['img'], person['name'], person['state'])));

  await createSolution();
  await makeEqual();
  await distributeInPlayer("room", tempListRoom, noOfPlayer);
  await distributeInPlayer("weapon", tempListWeapon, noOfPlayer);
  await distributeInPlayer("person", tempListPerson, noOfPlayer);
}

// End
//This will fetch the data for if game get close and start from where they left
Future<void> fetchDataIfGameClosed() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> combinedDataSnapshot =
        await FirebaseFirestore.instance
            .collection("zone")
            .doc(invitationCode)
            .collection("data")
            .doc('combinedData')
            .get();

    if (combinedDataSnapshot.exists) {
      Map<String, dynamic> combinedData = combinedDataSnapshot.data()!;
      List<Map<String, dynamic>> roomData =
          List<Map<String, dynamic>>.from(combinedData['rooms']);
      List<Map<String, dynamic>> weaponData =
          List<Map<String, dynamic>>.from(combinedData['weapons']);
      List<Map<String, dynamic>> personData =
          List<Map<String, dynamic>>.from(combinedData['persons']);

      listRoom.clear();
      listWeapon.clear();
      listPerson.clear();

      listRoom.addAll(roomData
          .map((room) => AssetInfo(room['img'], room['name'], room['state'])));
      listWeapon.addAll(weaponData.map((weapon) =>
          AssetInfo(weapon['img'], weapon['name'], weapon['state'])));
      listPerson.addAll(personData.map((person) =>
          AssetInfo(person['img'], person['name'], person['state'])));

      print('Data retrieved from Firestore and stored successfully.');
    } else {
      print('Combined document does not exist in Firestore.');
    }
  } catch (error) {
    print('Error fetching and storing data from Firestore: $error');
  }
}

createSolution() async {
  // Randomly select one item from listRoom

  if (tempListRoom.isNotEmpty) {
    int randomIndex = Random().nextInt(tempListRoom.length);
    // Add and remove value from index
    AssetInfo room = tempListRoom.removeAt(randomIndex);
    // AssetInfo room = listRoom[randomIndex];
    // Add the selected item to the solutionRoom list
    solutionRoom.clear(); // Clear the list before adding the new item
    solutionRoom.add(room);
  }

  // Randomly select one item from listWeapon
  if (tempListWeapon.isNotEmpty) {
    int randomIndex = Random().nextInt(tempListWeapon.length);
    // Add and remove value from index
    AssetInfo room = tempListWeapon.removeAt(randomIndex);
    // AssetInfo room = listWeapon[randomIndex];
    // Add the selected item to the solutionRoom list
    solutionWeapon.clear(); // Clear the list before adding the new item
    solutionWeapon.add(room);
  }

  // Randomly select one item from listPerson
  if (tempListPerson.isNotEmpty) {
    int randomIndex = Random().nextInt(tempListPerson.length);
    // Add and remove value from index
    AssetInfo room = tempListPerson.removeAt(randomIndex);
    // AssetInfo room = listPerson[randomIndex];
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

  FirebaseFirestore.instance
      .collection("zone")
      .doc(invitationCode)
      .collection('solution')
      .doc("combinedSolution").set(
    {
      "room": {
        "img": solutionRoom[0].img,
        "name": solutionRoom[0].name,
        "state": solutionRoom[0].state,
      },
      "weapon": {
        "img": solutionWeapon[0].img,
        "name": solutionWeapon[0].name,
        "state": solutionWeapon[0].state,
      },
      "person": {
        "img": solutionPerson[0].img,
        "name": solutionPerson[0].name,
        "state": solutionPerson[0].state,
      }
    },);

}
//as only
fetchSolutionIfGameClosed() async{
  try {
    DocumentSnapshot<Map<String, dynamic>> comboSolutionSnapshot =
        await FirebaseFirestore.instance
        .collection("zone")
        .doc(invitationCode)
        .collection('solution')
        .doc("combinedSolution")
        .get();

    if (comboSolutionSnapshot.exists) {
      Map<String, dynamic> comboSolutionData = comboSolutionSnapshot.data()!;
      Map<String, dynamic> roomData = comboSolutionData['room'];
      Map<String, dynamic> weaponData = comboSolutionData['weapon'];
      Map<String, dynamic> personData = comboSolutionData['person'];

      solutionRoom.add(AssetInfo(roomData['img'], roomData['name'], roomData['state']));
      solutionWeapon.add(AssetInfo(weaponData['img'], weaponData['name'], weaponData['state']));
      solutionPerson.add(AssetInfo(personData['img'], personData['name'], personData['state']));
      print("chinu");
      print(solutionWeapon[0].name);
    }

    print('Data retrieved from Firestore and stored successfully.');
  } catch (error) {
    print('Error fetching and storing data from Firestore: $error');
  }
}

makeEqual() async {
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
    listRoom.addAll(
        tempListRoom.sublist(i, min(i + roomSize, tempListRoom.length)));
    i += roomSize;
  }

  for (int i = 0; i < tempListWeapon.length - weaponRemainder;) {
    listWeapon.addAll(
        tempListWeapon.sublist(i, min(i + weaponSize, tempListWeapon.length)));
    i += weaponSize;
  }

  for (int i = 0; i < tempListPerson.length - personRemainder;) {
    listPerson.addAll(
        tempListPerson.sublist(i, min(i + personSize, tempListPerson.length)));
    i += personSize;
  }

  List<Map<String, dynamic>> roomData =
  listRoom.map((room) => room.toMap()).toList();
  List<Map<String, dynamic>> roomSolutionData =
  solutionRoom.map((room) => room.toMap()).toList();
  List<Map<String, dynamic>> weaponData =
  listWeapon.map((weapon) => weapon.toMap()).toList();
  List<Map<String, dynamic>> weaponSolutionData =
  solutionWeapon.map((weapon) => weapon.toMap()).toList();
  List<Map<String, dynamic>> personData =
  listPerson.map((person) => person.toMap()).toList();
  List<Map<String, dynamic>> personSolutionData =
  solutionPerson.map((person) => person.toMap()).toList();
  Random random = Random();

// Shuffle function to shuffle a list
  // Shuffle function to shuffle a list
  List<T> shuffleList<T>(List<T> list) {
    for (int i = list.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      T temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
    return list;
  }

// Function to merge and shuffle the original and solution lists
  List<Map<String, dynamic>> mergeAndShuffleLists(
      List<Map<String, dynamic>> originalData,
      List<Map<String, dynamic>> solutionData) {
    // Combine the original and solution lists
    List<Map<String, dynamic>> combinedData =
    List.from(originalData)..addAll(solutionData);

    // Shuffle the combined list
    return shuffleList(combinedData);
  }

// Shuffle the solution lists
  List<Map<String, dynamic>> shuffledRoomData =
  mergeAndShuffleLists(roomData, roomSolutionData);
  List<Map<String, dynamic>> shuffledWeaponData =
  mergeAndShuffleLists(weaponData, weaponSolutionData);
  List<Map<String, dynamic>> shuffledPersonData =
  mergeAndShuffleLists(personData, personSolutionData);

// Combine the shuffled lists into the combinedData map
  Map<String, dynamic> combinedData = {
    'rooms': shuffledRoomData,
    'weapons': shuffledWeaponData,
    'persons': shuffledPersonData,
  };

  try {
    // Save the combined data to Firestore
    await FirebaseFirestore.instance
        .collection("zone")
        .doc(invitationCode)
        .collection("data")
        .doc('combinedData')
        .set(combinedData);
    print('Data added to Firestore successfully.');
  } catch (error) {
    print('Error adding data to Firestore: $error');
  }

  // Print the stored data
  // print("listRoom:");
  // print(listRoom.length);
  // listRoom.forEach((asset) {
  //   print(asset.img);
  //   print(asset.name);
  //   print(asset.state);
  // });

  // print("listWeapon:");
  // print(listWeapon.length);
  // listWeapon.forEach((asset) {
  //   print(asset.img);
  //   print(asset.name);
  //   print(asset.state);
  // });

  // print("listPerson:");
  // print(listPerson.length);
  // listPerson.forEach((asset) {
  //   print(asset.img);
  //   print(asset.name);
  //   print(asset.state);
  // });
}

distributeInPlayer(
    String id, List<AssetInfo> assets, int numberOfHalves) async {
  // Calculate the size of each sublist
  int sublistSize = (assets.length / numberOfHalves).floor();

  // Shuffle the assets list randomly
  assets.shuffle();

  // Create a map to store player data
  Map<String, List<Map<String, dynamic>>> players = {};

  // Distribute assets to players
  for (int i = 0; i < numberOfHalves; i++) {
    String uid = zoneData[i]['uid']; // Get UID from zoneData

    List<Map<String, dynamic>> sublist = assets
        .sublist(i * sublistSize, (i + 1) * sublistSize)
        .map((asset) => {
              "img": asset.img,
              "name": asset.name,
              "state": asset.state,
            })
        .toList();

    // Assign sublist to player with UID as key
    players[uid] = sublist;
  }

  // Print player data (for demonstration)
  // players.forEach((key, value) {
  //   print('UID: $key:');
  //   value.forEach((asset) {
  //     print('"img": ${asset["img"]}, "name": ${asset["name"]}, "state": ${asset["state"]}');
  //   });
  // });

  // Store player data in Firestore
  storePlayerData(players, id);
}

storePlayerData(Map<String, List<Map<String, dynamic>>> players, String id) {
  // Iterate over each player
  players.forEach((uid, value) async {
    // Create a map to hold the field to update
    Map<String, dynamic> updateData = {};

    // Conditionally populate the updateData map based on the id
    if (id == 'room') {
      updateData['room'] = value;
    } else if (id == 'weapon') {
      updateData['weapon'] = value;
    } else if (id == 'person') {
      updateData['person'] = value;
    }

    // Update Firestore document with player data
    await FirebaseFirestore.instance
        .collection("zone")
        .doc(invitationCode)
        .collection("game")
        .doc(uid)
        .update(updateData);
  });
}
