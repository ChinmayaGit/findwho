import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String inGame;
  final String inviteId;
  final String pass;
  final DateTime time;
  final String uid;
  final String userName;

  UserDataModel({
    required this.inGame,
    required this.inviteId,
    required this.pass,
    required this.time,
    required this.uid,
    required this.userName,
  });

  factory UserDataModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return UserDataModel(
      inGame: data['inGame'] ?? '',
      inviteId: data['inviteId'] ?? '',
      pass: data['pass'] ?? '',
      time: (data['time'] as Timestamp).toDate(),
      uid: data['uid'] ?? '',
      userName: data['userName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inGame': inGame,
      'inviteId': inviteId,
      'pass': pass,
      'time': time,
      'uid': uid,
      'userName': userName,
    };
  }
}