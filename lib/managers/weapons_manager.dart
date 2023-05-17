import 'package:get_tough/classes/weapon.dart';

class WeaponsManager {
  static final WeaponsManager _instance = WeaponsManager._internal();

  factory WeaponsManager() {
    return _instance;
  }

  WeaponsManager._internal();

  Map<int, Weapon> weapons = {};

  Future load(rows) async {
    rows.map<Weapon>((json) => Weapon.fromJson(json)).forEach((w) =>
        weapons[w.id] = w
    );
  }

}