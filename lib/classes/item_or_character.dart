// ignore_for_file: constant_identifier_names

import '../managers/character_manager.dart';
import '../managers/places_manager.dart';

enum IdType {
  NONE,
  PLACE,
  ITEM,
  CHARACTER
}

class ItemOrCharacterLocation {
  final int id;
  final int locationId;

  IdType get type  => getIdType(id);
  IdType get locationType => getIdType(locationId);

  ItemOrCharacterLocation(this.id, this.locationId);
}


IdType getIdType(int id) {
  if(PlacesManager().places.containsKey(id)) {
    return IdType.PLACE;
  }

  if(CharacterManager().characters.containsKey(id)) {
    return IdType.CHARACTER;
  }


  return IdType.NONE;
}