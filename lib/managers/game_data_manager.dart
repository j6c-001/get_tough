import 'dart:convert';

import 'package:get_tough/managers/places_manager.dart';
import 'package:http/http.dart' as http;
import 'character_manager.dart';
import 'items_manager.dart';

class GameDataManager {
  static final GameDataManager _instance = GameDataManager._internal();

  factory GameDataManager() {
    return _instance;
  }

  GameDataManager._internal();

  final devServiceUrl = Uri.parse('http://localhost:8080');
  final serviceUrl = Uri.parse('https://topaz-ss-service-itgz7nbaxa-nn.a.run.app');
  final sourceId = '164uGdxvwAcfLTA26joxzkzLPPVZ8UF3yqTqFxxId1CY';

  Future load() async {
    final response = await http.post(serviceUrl,
      body: jsonEncode({
        'sourceId': sourceId,
        'sheets': ['Places', 'Characters', 'Items']
      })
    );

    final responseJson  = jsonDecode(response.body);
    CharacterManager().load(responseJson['Characters']);
    PlacesManager().load(responseJson['Places']);
    ItemsManager().load(responseJson['Items']);


  }
}
