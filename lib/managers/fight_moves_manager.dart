import '../classes/fight_move.dart';

class FightMovesManager {
  static final FightMovesManager _instance = FightMovesManager._internal();

  factory FightMovesManager() {
    return _instance;
  }

  FightMovesManager._internal();

  Map<int, FightMove> moves = {};

  Future load(rows) async {
    rows.map<FightMove>((json) => FightMove.fromJson(json)).forEach((m)=>
    moves[m.id] = m
    );
  }

}