import '../classes/item.dart';

class ItemsManager {
  static final ItemsManager _instance = ItemsManager._internal();

  factory ItemsManager() {
    return _instance;
  }

  ItemsManager._internal();

  Map<int,Item> items = {};

  Future load(itemsRows) async {
    items.clear();
    itemsRows?.map((json)=> Item.fromJson(json)).forEach((p) {
      items[p.id] = p;
    });

  }




}