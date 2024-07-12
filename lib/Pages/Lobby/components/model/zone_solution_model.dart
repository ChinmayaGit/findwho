import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/Pages/Lobby/components/model/game_item_model.dart';

class ZoneSolutionModel {
  final List<dynamic>? persons;
  final List<dynamic>? rooms;
  final List<dynamic>? weapons;

  ZoneSolutionModel({
    required this.persons,
    required this.rooms,
    required this.weapons,
  });

  factory ZoneSolutionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return ZoneSolutionModel(
      persons: (data['persons'] as List<dynamic>?),
      rooms: (data['rooms'] as List<dynamic>?),
      weapons: (data['weapons'] as List<dynamic>?),
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
