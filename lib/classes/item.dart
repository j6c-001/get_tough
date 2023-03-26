import 'package:get_tough/classes/item_or_character.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/utils/hash.dart';

class Item {
   Item( {
    required this.id,
    required this.name,
    required this.longDescription,
    required this.defaultPlaceId
  }) {
    LocationManager().locations[id] = ItemOrCharacterLocation(id, defaultPlaceId);
  }

  final int id;
  final String name;
  final String longDescription;
  final int defaultPlaceId;

  @override
  String toString() => 'Item(id: $id, name: $name)';

  static fromJson(Map<String, dynamic> json) {
    return Item(
      id: idHash(json['Id']),
      name: json['Name'] ,
      longDescription: json['Long Description'],
      defaultPlaceId: idHash(json['Starting Place Id'])
    );
  }
}