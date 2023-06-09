import '../classes/place.dart';

class PlacesManager {
  static final PlacesManager _instance = PlacesManager._internal();

  factory PlacesManager() {
    return _instance;
  }

  PlacesManager._internal();

  Map<int,Place> places = {};

  Future load(placesRows) async {
    places.clear();
    placesRows?.map((json)=> Place.fromJson(json)).forEach((p) {
      places[p.id] = p;
    });

  }

  List<int> getPath(int id) {
    List<int> path= [];
    int currentId = id;
    while (true) {
      currentId = places[currentId]!.parentId;
      if(currentId != 0) {
        path.add(currentId);
      } else {
        break;
      }
    }
    return path;
  }


}