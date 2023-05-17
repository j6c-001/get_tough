

import '../managers/fight_moves_manager.dart';
import '../utils/hash.dart';
import 'fight_move.dart';

class FightProfile {
  final int id;
  final String name;
  final Set<int> moveIds = {};

  FightProfile({required this.id, required this.name, required Iterable<int> moves_}) {
    moveIds.addAll(moves_);
  }


  static FightProfile fromJson(json) {

    List<int> ids = [];
    for(final e in json.entries) {
      if (e.key != 'Name') {
        int id = idHash(e.value);
        if(id != 0) {
          ids.add(id);
        }
      }
    }

    return FightProfile(
      id: idHash(json['Name']),
      name: json['Name'],
      moves_: ids
    );

  }

  Set<FightMove> get moves => moveIds.map<FightMove>((id)=>FightMovesManager().moves[id]!).toSet();


}