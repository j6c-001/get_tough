import 'package:gsheets/gsheets.dart';

import '../classes/character.dart';
import '../credentials.dart';

class CharacterManager {
  static final CharacterManager _instance = CharacterManager._internal();

  factory CharacterManager() {
    return _instance;
  }

  CharacterManager._internal();

  Map<int, Character> characters = {};

  Character get you => characters.entries.first.value;

  Future load() async {
    final gSheets = GSheets(gSheetCredentials);
    final ss = await gSheets.spreadsheet(ssSourceId);

    final charactersSheet = ss.worksheetByTitle('Characters');
    if (charactersSheet == null) {
      return;
    }

    final placesRows = await charactersSheet.values.map.allRows(fromRow: 2);
    characters.clear();
    placesRows?.map((json)=> Character.fromJson(json)).forEach((p) {
      characters[p.id] = p;
    });

  }
}

