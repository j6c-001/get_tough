
import 'package:get_tough/commands.dart';
import 'package:get_tough/managers/conditions_manager.dart';
import 'package:get_tough/utils/hash.dart';

import 'condition.dart';


class Trigger {
  const Trigger({
    required this.action,
    required this.toolItemId,
    required this.targetItemId,
    required this.targetCharacterId,
    required this.conditionId,
    required this.newValue,
    required this.description,
    required this.noChangeDescription
  });

  final CommandType action;
  final int toolItemId;
  final int targetItemId;
  final int targetCharacterId;
  final int conditionId;
  final int newValue;
  final String description;
  final String noChangeDescription;

  @override
  String toString() => 'Trigger(action: $action  toolId: $toolItemId)';

  static Trigger fromJson(Map<String, dynamic> json) {
    return Trigger(
     action: getAction(json['Action']),
     toolItemId: idHash(json['Tool Item Id']),
     targetItemId: idHash(json['Target Item Id']),
     targetCharacterId: idHash(json['Target Character Id']),
     conditionId: idHash(json['Condition Id']),
     newValue: int.tryParse(json['New Value']) ?? 0,
     description: json['Description'],
     noChangeDescription: json['No Change Description']
    );

  }

  Condition get condition => ConditionsManager().conditions[conditionId]!;

}

CommandType getAction(String s) {
  final l = CommandType.values.where((ct)=>ct.name.toUpperCase() == s.toUpperCase());
  if (l.length == 1) {
    return l.first;
  }
  return CommandType.NONE;
}