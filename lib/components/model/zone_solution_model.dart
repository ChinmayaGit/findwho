import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/components/model/game_item_model.dart';
class ZoneSolutionModel {
  final Map<String, dynamic>? persons;
  final Map<String, dynamic>? rooms;
  final Map<String, dynamic>? weapons;

  ZoneSolutionModel({
    required this.persons,
    required this.rooms,
    required this.weapons,
  });

  factory ZoneSolutionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return ZoneSolutionModel(
      persons: data['persons'] as Map<String, dynamic>?,
      rooms: data['rooms'] as Map<String, dynamic>?,
      weapons: data['weapons'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'persons': persons,
      'rooms': rooms,
      'weapons': weapons,
    };
  }
}
