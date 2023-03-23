import 'package:get_tough/classes/item_or_character.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/utils/hash.dart';

class Character {
   Character({
    required this.id,
    required this.name,
    required this.longName,
    required this.longDescription,
    required this.defaultPlaceId
  }) {
    LocationManager().locations[id] = ItemOrCharacterLocation(id, defaultPlaceId);
  }

  final int id;
  final String name;
  final String longName;
  final String longDescription;
  final int defaultPlaceId;

  @override
  String toString() => 'Character(id: $id, name: $name)';

  static fromJson(Map<String, dynamic> json) {
    return Character(
      id: idHash(json['Id']),
      name: json['Name'] ,
      longName: json['Long Name'],
      longDescription: json['Long Description'],
      defaultPlaceId: idHash(json['Starting Place Id'])
    );
  }
}