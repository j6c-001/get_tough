import '../utils/hash.dart';

class Weapon {
  final int id;
  final String name;

  Weapon({required this.id, required this.name});

  static Weapon fromJson(json) {
    return Weapon(id: idHash(json['Name']), name: json['Name']);
  }
}