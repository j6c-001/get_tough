import 'package:get_tough/classes/condition.dart';
import 'package:get_tough/managers/conditions_manager.dart';

import '../utils/hash.dart';

class ActionRule {
  final int fromId;
  final int toId;
  final int conditionId;

  final String passText;
  final String failText;

  ActionRule({
    required this.fromId,
    required this.toId,
    required this.conditionId,
    required this.passText,
    required this.failText
  });

  static ActionRule fromJson(Map<String, dynamic> json) {
    return ActionRule(
        fromId: idHash(json['From Id']),
        toId: idHash(json['To Id']),
        conditionId: idHash(json['Condition Id']),
        passText: json['Pass Text'],
        failText: json['Fail Text']
    );
  }

  Condition get condition => ConditionsManager().conditions[conditionId]!;
}