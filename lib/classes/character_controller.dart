import 'package:get_tough/classes/character.dart';
import 'package:get_tough/classes/item_or_character.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/managers/places_manager.dart';

import 'place.dart';

class CharacterController {
  Character character;

  CharacterController({required this.character});

  int get currentPlaceId => LocationManager().locations[character.id]!.locationId;
  Place get currentPlace => PlacesManager().places[currentPlaceId]!;
  bool moveTo(int placeId) {
    if (currentPlace.exits.contains(placeId)) {
      LocationManager().locations[character.id] = ItemOrCharacterLocation(character.id, placeId);
      return true;
    }
    return false;
  }

}