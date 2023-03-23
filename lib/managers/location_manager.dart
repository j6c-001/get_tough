import '../classes/item_or_character.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._internal();

  factory LocationManager() {
    return _instance;
  }

  LocationManager._internal();

  Map<int, ItemOrCharacterLocation> locations = {};


  void modeTo(int id, int locationid) {
    locations[id] = ItemOrCharacterLocation(id, locationid);
  }


}
