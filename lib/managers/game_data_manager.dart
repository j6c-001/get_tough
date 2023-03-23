import 'package:get_tough/managers/places_manager.dart';

import 'character_manager.dart';

class GameDataManager {
  static final GameDataManager _instance = GameDataManager._internal();

  factory GameDataManager() {
    return _instance;
  }

  GameDataManager._internal();

  Future load() async {
   await Future.wait([
      CharacterManager().load(),
      PlacesManager().load()
   ]);
  }
}

