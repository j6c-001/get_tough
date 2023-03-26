
import 'package:get_tough/managers/items_manager.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/managers/places_manager.dart';
import 'package:get_tough/utils/hash.dart';
import '../utils/directions.dart';
import 'item.dart';



class Place {
  const Place({
    required this.id,
    required this.shortDescription,
    required this.longDescription,
    required this.exits,
    required this.parentId
  });

  final int id;
  final int parentId;
  final String shortDescription;
  final String longDescription;
  final List<int> exits;

  @override
  String toString() =>
      'Place{id: $id, shortDescription: $shortDescription, longDescription: $longDescription, N: ${exits[N]}, S: ${exits[S]}, E: ${exits[E]}, W: ${exits[W]}';

  static fromJson(Map<String, dynamic> json) {
    final exits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    exits[N] = idHash(json['Exit North']);
    exits[S] = idHash(json['Exit South']);
    exits[E] = idHash(json['Exit East']);
    exits[W] =  idHash(json['Exit West']);

    return Place(
      id: idHash(json['Id']),
      shortDescription: json['Short Description'] ,
      longDescription: json['Long Description'],
      exits: exits,
      parentId: idHash(json['Within Id'])
    );

  }

  String get pathName => PlacesManager().getPath(id).map((e) => PlacesManager().places[e]!.shortDescription).join(', ');
  List<Item> get visibleItems => ItemsManager().items.values.where((item)=> LocationManager().locations[item.id]!.locationId == id ).toList();


}