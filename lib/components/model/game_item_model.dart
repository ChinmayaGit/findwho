// class GameItem {
//   final String img;
//   final String name;
//   final bool state;
//
//   GameItem({required this.img, required this.name, required this.state});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'img': img,
//       'name': name,
//       'state': state,
//     };
//   }
// }
//
//
// class Person extends GameItem {
//   Person({required String img, required String name, required bool state})
//       : super(img: img, name: name, state: state);
//
//   factory Person.fromMap(Map<String, dynamic> data) {
//     return Person(
//       img: data['img'] ?? '',
//       name: data['name'] ?? '',
//       state: data['state'] ?? false,
//     );
//   }
// }
//
// class Room extends GameItem {
//   Room({required String img, required String name, required bool state})
//       : super(img: img, name: name, state: state);
//
//   factory Room.fromMap(Map<String, dynamic> data) {
//     return Room(
//       img: data['img'] ?? '',
//       name: data['name'] ?? '',
//       state: data['state'] ?? false,
//     );
//   }
// }
//
// class Weapon extends GameItem {
//   Weapon({required String img, required String name, required bool state})
//       : super(img: img, name: name, state: state);
//
//   factory Weapon.fromMap(Map<String, dynamic> data) {
//     return Weapon(
//       img: data['img'] ?? '',
//       name: data['name'] ?? '',
//       state: data['state'] ?? false,
//     );
//   }
// }
abstract class GameItem {
  final String img;
  final String name;
  final bool state;

  GameItem({
    required this.img,
    required this.name,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'img': img,
      'name': name,
      'state': state,
    };
  }
}

class RoomModel extends GameItem {
  RoomModel({
    required String img,
    required String name,
    required bool state,
  }) : super(img: img, name: name, state: state);

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      img: map['img'] ?? '',
      name: map['name'] ?? '',
      state: map['state'] ?? false,
    );
  }
}

class WeaponModel extends GameItem {
  WeaponModel({
    required String img,
    required String name,
    required bool state,
  }) : super(img: img, name: name, state: state);

  factory WeaponModel.fromMap(Map<String, dynamic> map) {
    return WeaponModel(
      img: map['img'] ?? '',
      name: map['name'] ?? '',
      state: map['state'] ?? false,
    );
  }
}

class PersonModel extends GameItem {
  PersonModel({
    required String img,
    required String name,
    required bool state,
  }) : super(img: img, name: name, state: state);

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      img: map['img'] ?? '',
      name: map['name'] ?? '',
      state: map['state'] ?? false,
    );
  }
}