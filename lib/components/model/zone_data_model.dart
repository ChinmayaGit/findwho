import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/components/model/game_item_model.dart';

class ZoneDataModel {
  final List<PersonModel>? persons;
  final List<RoomModel>? rooms;
  final List<WeaponModel>? weapons;

  ZoneDataModel({
    required this.persons,
    required this.rooms,
    required this.weapons,
  });

  factory ZoneDataModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return ZoneDataModel(
      persons: (data['persons'] as List<dynamic>?)
          ?.map((item) => PersonModel.fromMap(item))
          .toList(),
      rooms: (data['rooms'] as List<dynamic>?)
          ?.map((item) => RoomModel.fromMap(item))
          .toList(),
      weapons: (data['weapons'] as List<dynamic>?)
          ?.map((item) => WeaponModel.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'persons': persons?.map((item) => item.toMap()).toList(),
      'rooms': rooms?.map((item) => item.toMap()).toList(),
      'weapons': weapons?.map((item) => item.toMap()).toList(),
    };
  }
}
