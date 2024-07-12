import "package:cloud_firestore/cloud_firestore.dart";
import "package:findwho/Pages/Lobby/components/model/game_item_model.dart";

class ZoneGameModel {
  final String color;
  final int dice;
  final Map<String, PersonModel> persons;
  final int playerTurn;
  final bool ready;
  final Map<String, RoomModel> rooms;
  final String uid;
  final Map<String, WeaponModel> weapons;

  ZoneGameModel({
    required this.color,
    required this.dice,
    required this.persons,
    required this.playerTurn,
    required this.ready,
    required this.rooms,
    required this.uid,
    required this.weapons,
  });

  factory ZoneGameModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;

    Map<String, PersonModel> personsMap = {};
    if (data['persons'] != null) {
      for (var item in data['persons']) {
        if (item['name'] != null) {
          personsMap[item['name']] = PersonModel.fromMap(item);
        }
      }
    }

    Map<String, RoomModel> roomsMap = {};
    if (data['rooms'] != null) {
      for (var item in data['rooms']) {
        if (item['name'] != null) {
          roomsMap[item['name']] = RoomModel.fromMap(item);
        }
      }
    }

    Map<String, WeaponModel> weaponsMap = {};
    if (data['weapons'] != null) {
      for (var item in data['weapons']) {
        if (item['name'] != null) {
          weaponsMap[item['name']] = WeaponModel.fromMap(item);
        }
      }
    }

    return ZoneGameModel(
      color: data['color'] ?? '',
      dice: data['dice'] ?? 0,
      persons: personsMap,
      playerTurn: data['playerTurn'] ?? 0,
      ready: data['ready'] ?? false,
      rooms: roomsMap,
      uid: data['uid'] ?? '',
      weapons: weaponsMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'dice': dice,
      'persons': persons.map((key, value) => MapEntry(key, value.toMap())),
      'playerTurn': playerTurn,
      'ready': ready,
      'rooms': rooms.map((key, value) => MapEntry(key, value.toMap())),
      'uid': uid,
      'weapons': weapons.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  List<RoomModel> getRoomsList() {
    return rooms.values.toList();
  }

  List<WeaponModel> getWeaponsList() {
    return weapons.values.toList();
  }

  List<PersonModel> getPersonsList() {
    return persons.values.toList();
  }
}
