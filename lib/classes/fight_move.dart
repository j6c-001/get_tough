
import 'package:get_tough/classes/fighter.dart';
import 'package:get_tough/enumerations/pose.dart';
import 'package:get_tough/managers/weapons_manager.dart';

import '../enumerations/fight_range.dart';
import '../enumerations/target.dart';
import '../utils/enums.dart';
import '../utils/hash.dart';
import 'range_modifier.dart';


class FightMove {
  final int id;
  final String name;
  final int weaponId;
  final ETarget target;
  final EPose pose;
  final EPose newPose;
  final EPose targetPose;
  final EPose newTargetPose;


  final double hitCost;
  final double missCost;

  final double standardDamage;
  final RangeModifier damageMod = RangeModifier();

  final double standardSuccess;
  final RangeModifier successMod = RangeModifier();

  final String hitDescription;
  final String missDescription;


  get weaponName => WeaponsManager().weapons[weaponId]!.name;


  double damage(EFightRange range, Fighter fighter) => standardDamage * damageMod.value(range) * fighter.damageMod.value(range);
  double success(EFightRange range, Fighter fighter) => standardSuccess * successMod.value(range) * fighter.successMod.value(range);
  double expectedDamage(EFightRange range, fighter) => damage(range, fighter) * success(range, fighter);
  double costBalancedDamage(EFightRange range, fighter) => damage(range, fighter) * (success(range, fighter) * hitCost + (1.0 - success(range, fighter)) * missCost) / 100.0;


  FightMove({
   required this.id,
   required this.name,
   required this.weaponId,
   required this.target,
   required this.pose,
   required this.newPose,
   required this.targetPose,
   required this.newTargetPose,
   required this.hitCost,
   required this.missCost,
   required this.standardDamage,
   required this.standardSuccess,
   required this.hitDescription,
   required this.missDescription
  });



  static FightMove fromJson(Map<String, dynamic> json) {

    final fm = FightMove(
        id: idHash(json['Name']),
        name: json['Name'] ,
        weaponId: idHash(json['Weapon']),
        target: getEnum<ETarget>(ETarget.values, json['Target']),
        pose : getEnum<EPose>(EPose.values, json['Pose']),
        newPose : getEnum<EPose>(EPose.values, json['New Pose']),
        targetPose : getEnum<EPose>(EPose.values, json['Target Pose']),
        newTargetPose  : getEnum<EPose>(EPose.values, json['New Target Pose']),
        hitCost: double.tryParse(json['Cost Hit']) ?? 0,
        missCost: double.tryParse(json['Cost Miss']) ?? 0,
        standardDamage: double.tryParse(json['Standard Damage']) ?? 0,
        standardSuccess: double.tryParse(json['Standard Success']) ?? 0,
        hitDescription : json['Hit Description'],
        missDescription : json['Miss Description']
    );


    fm.damageMod.inside = double.tryParse(json['Inside Range Modifier Damage']) ?? 0;
    fm.damageMod.short = double.tryParse(json['Short Range Modifier Damage']) ?? 0;
    fm.damageMod.mid = double.tryParse(json['Mid Range Modifier Damage']) ?? 0;

    fm.successMod.inside = double.tryParse(json['Inside Range Modifier Success']) ?? 0;
    fm.successMod.short = double.tryParse(json['Short Range Modifier Success']) ?? 0;
    fm.successMod.mid = double.tryParse(json['Inside Range Modifier Success']) ?? 0;

    return fm;
  }


}

