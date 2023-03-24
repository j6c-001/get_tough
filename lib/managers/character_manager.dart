import '../classes/character.dart';

class CharacterManager {
  static final CharacterManager _instance = CharacterManager._internal();

  factory CharacterManager() {
    return _instance;
  }

  CharacterManager._internal();

  Map<int, Character> characters = {};

  Character get you => characters.entries.first.value;

  void load(placesRows) async {
    characters.clear();
    placesRows?.map((json)=> Character.fromJson(json)).forEach((p) {
      characters[p.id] = p;
    });

  }
}

