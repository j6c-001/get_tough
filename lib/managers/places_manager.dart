import 'package:gsheets/gsheets.dart';

import '../classes/place.dart';
import '../credentials.dart';

class PlacesManager {
  static final PlacesManager _instance = PlacesManager._internal();

  factory PlacesManager() {
    return _instance;
  }

  PlacesManager._internal();

  Map<int,Place> places = {};

  Future load() async {
    final gSheets = GSheets(gSheetCredentials);
    final ss = await gSheets.spreadsheet(ssSourceId);

    final placesSheet = ss.worksheetByTitle('Places');
    if (placesSheet == null) {
      return;
    }
    final placesRows = await placesSheet.values.map.allRows(fromRow: 2);
    places.clear();
    placesRows?.map((json)=> Place.fromJson(json)).forEach((p) {
      places[p.id] = p;
    });

  }
}