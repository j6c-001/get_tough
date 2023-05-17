import 'dart:math';

import 'package:get_tough/classes/character.dart';

import '../enumerations/fight_range.dart';
import '../main.dart';
import 'fighter.dart';



class Fight {
  final List<Fighter> fighters = [];

  EFightRange range = EFightRange.MID;
  int round = 0;

  Fight(Character char1, Character char2) {
    fighters.addAll([
      Fighter(char1),
      Fighter(char2)
    ]);
  }


fight() {
    while (!finished()) {
      for (int i = 0; i < fighters.length; ++i) {
         final attacker = fighters[i];
         final target = fighters[(i+1) % fighters.length];
         final move = attacker.getMove(this, target);
         if(move != null) {
           final attackProb = move.success(range, target);
           final defensiveProbAdjustment = 0.5 * target.character.level / 10 *
               target.character.speed / 100; // (level ten can reduce by 50%)
           final testProp = attackProb - defensiveProbAdjustment;

           final hit = Random().nextDouble() <= testProp;

           if (hit) {
             final damage = move.damage(range, attacker);
             target.applyHit(attacker, move, damage);
           } else {
             attacker.applyMiss(move, target);
           }
         } else {
           tape.addResponse('No moves!');
         }
         range = EFightRange.values[(range.index+1) % EFightRange.values.length];
      }

      round++;
    }
  }

  bool finished() {
    return round >= 4;
  }

}