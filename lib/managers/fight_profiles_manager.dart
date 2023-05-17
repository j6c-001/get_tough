import '../classes/fight_profile.dart';

class FightProfilesManager {
  static final FightProfilesManager _instance = FightProfilesManager._internal();

  factory FightProfilesManager() {
    return _instance;
  }

  FightProfilesManager._internal();

  Map<int, FightProfile> profiles = {};

  Future load(rows) async {
  rows.map<FightProfile>((json) => FightProfile.fromJson(json)).forEach((fp)=>
      profiles[fp.id] = fp);
  }


  // Add the move ids from the predefined profileId to the target
  void addProfile(Set<int> targetMoves, int id) {
    if (profiles.containsKey(id)) {
      final fp = profiles[id];
      targetMoves.addAll(fp!.moveIds);
    }
  }

}