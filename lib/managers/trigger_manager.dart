import '../classes/trigger.dart';
import '../commands.dart';

class TriggerManager {
  static final TriggerManager _instance = TriggerManager._internal();

  factory TriggerManager() {
    return _instance;
  }

  TriggerManager._internal();

  List<Trigger> triggers = [];

  Future load(rows) async {
    triggers = rows.map<Trigger>((json)=>Trigger.fromJson(json)).toList();
  }

  List<Trigger> find(CommandType action, int itemOrCharacterId, int targetId ){
      return triggers.where((it)=>it.action == action && (it.targetItemId == itemOrCharacterId || it.targetCharacterId == itemOrCharacterId) && it.toolItemId == targetId).toList();
  }

}