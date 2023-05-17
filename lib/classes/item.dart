import 'package:get_tough/classes/item_or_character.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/utils/hash.dart';

class Item {
   Item( {
    required this.id,
    required this.name,
    required this.longDescription,
    required this.inventoryDescription,
    required this.defaultPlaceId,
    required this.indefiniteArticle,
    required this.isImmovable,
    required this.weaponId
  }) {
    LocationManager().locations[id] = ItemOrCharacterLocation(id, defaultPlaceId);
  }

  final int id;
  final String name;
  final String longDescription;
  final String inventoryDescription;
  final int defaultPlaceId;
  final String indefiniteArticle;
  final bool isImmovable;
  final int weaponId;

  String get descriptionWhenInInventory =>  inventoryDescription.isEmpty ? longDescription : inventoryDescription;

  @override
  String toString() => 'Item(id: $id, name: $name)';
  String get nameWithArticle => '$indefiniteArticle $name';

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      id: idHash(json['Id']),
      name: json['Name'] ,
      longDescription: json['Long Description'],
      inventoryDescription: json['Inventory Description'],
      indefiniteArticle: json['Indefinite Article'],
      defaultPlaceId: idHash(json['Starting Place Id']),
      isImmovable: json['Immovable'].toString().toLowerCase().startsWith('y'),
      weaponId: idHash(json['Weapon'])
    );
  }
}