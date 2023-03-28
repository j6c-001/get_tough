// ignore_for_file: constant_identifier_names

import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/utils/hash.dart';
enum ConditionType {
  NONE,
  STATE,
  LOCATION
}

enum ConditionOperator {
  NONE,
  EQUAL,
  NOT_EQUAL
}

class Condition {
  Condition({
    required this.id,
    required this.type,
    required this.itemOrCharacterId,
    required this.operator,
    required this.locationIdValue,
    required this.testValue,
    required this.defaultValue
  }): value = defaultValue;

  final int id;
  final ConditionType type;
  final int itemOrCharacterId;
  final ConditionOperator operator;
  final int locationIdValue;
  final int testValue;
  final int defaultValue;
  int value;

  @override
  String toString() => 'Condition(id: $id)';

  static fromJson(Map<String, dynamic> json) {
    final  characterId = idHash(json['Character Id']);
    final  itemId = idHash(json['Item Id']);

    return Condition(
      id: idHash(json['Id']),
      type: getType(json['Type']),
      operator: getOperator(json['Operator']),
      itemOrCharacterId: itemId != 0 ? itemId : characterId,
      locationIdValue: idHash(json['Place Id Value']),
      testValue: int.tryParse(json['Test Value']) ?? 0,
      defaultValue: int.tryParse(json['Default Value']) ?? 0
    );
  }

  bool get test {
    switch (type) {

      case ConditionType.NONE:
        break;
      case ConditionType.STATE:
        bool test = testValue == value;
        return operator == ConditionOperator.EQUAL ? test : !test;
      case ConditionType.LOCATION:
        bool test1 = testValue == value;
        final test = test1 && LocationManager().locations[itemOrCharacterId]!.locationId == locationIdValue;
        return operator == ConditionOperator.EQUAL ? test : !test;
    }

    return false;
  }
}

ConditionType getType(String t) {
  if (t == 'LOCATION') {
    return ConditionType.LOCATION;
  }

  if (t == 'STATE') {
    return ConditionType.STATE;
  }

  return ConditionType.NONE;
}

ConditionOperator getOperator(String o) {
  if(o == 'EQUALS') {
    return ConditionOperator.EQUAL;
  }
  if(o == 'NOT_EQUALS') {
    return ConditionOperator.NOT_EQUAL;
  }

  return ConditionOperator.NONE;

}