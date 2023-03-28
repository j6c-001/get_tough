import '../classes/condition.dart';

class ConditionsManager {
  static final ConditionsManager _instance = ConditionsManager._internal();

  factory ConditionsManager() {
    return _instance;
  }

  ConditionsManager._internal();

  Map<int,Condition> conditions = {};

  Future load(rows) async {
    conditions.clear();
    rows.map((json)=> Condition.fromJson(json)).forEach((p) {
      conditions[p.id] = p;
    });
    

  }

}