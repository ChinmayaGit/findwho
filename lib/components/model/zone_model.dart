import 'package:cloud_firestore/cloud_firestore.dart';


class ZoneModel {
  final Map<String, dynamic>? colors;
  final DateTime date;
  final String invitationCode;
  final int maxPlayers;
  final bool roomCreated;
  final int page;
  final int turn;
  final Map<String, dynamic>? solutionFound;

  ZoneModel({
    required this.colors,
    required this.date,
    required this.invitationCode,
    required this.maxPlayers,
    required this.roomCreated,
    required this.turn,
    required this.solutionFound,
    required this.page,
  });

  factory ZoneModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return ZoneModel(
      colors: (data['Colors'] as Map<String, dynamic>?),
      date: (data['Date'] as Timestamp).toDate(),
      invitationCode: data['InvitationCode'] ?? '',
      maxPlayers: (data['maxPlayers'] ?? 0),
      roomCreated: data['RoomCreated'] ?? false,
      turn: (data['Turn'] ?? 0),
      solutionFound: (data['solutionFound'] as Map<String, dynamic>?),
      page: (data['page'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Colors': colors,
      'Date': date,
      'InvitationCode': invitationCode,
      'maxPlayers': maxPlayers,
      'RoomCreated': roomCreated,
      'Turn': turn,
      'solutionFound': solutionFound,
      'page':page,
    };
  }
  // Map<String, dynamic> colorsToMap() {
  //   return {
  //     'Colors': colors,
  //   };
  // }
}

