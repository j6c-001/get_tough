import '../classes/action_rule.dart';

class ActionRuleManager {
  static final ActionRuleManager _instance = ActionRuleManager._internal();

  factory ActionRuleManager() {
    return _instance;
  }

  ActionRuleManager._internal();

  List<ActionRule> rules = [];

  Future load(rows) async {
     rules = rows.map<ActionRule>((json)=> ActionRule.fromJson(json)).toList();
  }

  List<ActionRule> findMoveRules(int fromId, int toId) {
    return rules.where((r) => r.fromId == fromId && r.toId == toId).map((r)=>r).toList();
  }


}