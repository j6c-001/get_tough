import 'dart:math';

import 'package:get_tough/classes/character.dart';
import 'package:get_tough/classes/fight_move.dart';
import 'package:get_tough/enumerations/fight_move_selector_type.dart';

import '../enumerations/pose.dart';
import '../main.dart';
import 'fight.dart';

class Fighter {
  final Character character;
  EPose pose = EPose.STANDING;

  final EFightMoveSelectorType selectorType;

  Set<FightMove> history = {};

  Fighter(this.character, {this.selectorType = EFightMoveSelectorType.RANDOM});


  Iterable<FightMove> get moves => character.fightMoves;

  FightMoveSelector get moveSelector => FMS[selectorType]!;

  get damageMod => character.fightMoveDamageModifier;
  get successMod => character.fightMoveSuccessModifier;



  FightMove? getMove(Fight fight, Fighter target ) {

    return moveSelector.getMove(fight, this, target);

  }

  void applyHit(Fighter attacker, FightMove move, double damage) {
    character.health -= damage;
    attacker.character.energy -= move.hitCost;

    final attackerName = attacker.character.name;
    final targetName = character.name;

    final hitText =  getTextForMove(move.hitDescription, attacker, this);

    // if move is strike

    tape.addResponse('${character.name} ${character.isYou ? 'attack' :'attacks'} with a ${move.name}: $hitText');
    tape.addResponse('$targetName takes $damage damage, so heath is now ${character.health} and energy is ${character.energy}.');


    if (attacker.pose == EPose.STANDING && (move.newPose == EPose.PRONE || move.newPose == EPose.SUPINE)) {
      pose = move.targetPose;
      tape.addResponse('It\'s a sacrifice and $attackerName hits the deck too.');
    }

  }
    //... or hold
  void applyMiss(FightMove move, Fighter defender) {
    character.energy -= move.missCost;

    final missText =  getTextForMove(move.missDescription, this, defender);
    tape.addResponse('${character.name} ${character.isYou ? 'attack' :'attacks'} with a ${move.name}: $missText');

  }

  String getTextForMove(String t, Fighter attacker, Fighter target) {

    t = t.replaceAll('[A_PRONOUN]', attacker.character.pronoun);
    t = t.replaceAll('[A_POSSESSIVE_PRONOUN]', attacker.character.possessivePronoun);
    t= t.replaceAll('[A_PRONOUN_COLOUR_VERB]', '${attacker.character.pronoun} ${attacker.character.colourVerb}');

    t= t.replaceAll('[T_PRONOUN]', target.character.pronoun);
    t= t.replaceAll('[T_POSSESSIVE_PRONOUN]', target.character.possessivePronoun);
    t= t.replaceAll('[T_PRONOUN_COLOUR_VERB]', '${target.character.pronoun} ${attacker.character.colourVerb}');


    return t;
  }


}

final Map<EFightMoveSelectorType, FightMoveSelector> FMS = {
  EFightMoveSelectorType.RANDOM : RandomFightMoveSelector(),
  EFightMoveSelectorType.DAMAGE : MaxDamageFightMoveSelector(),
  EFightMoveSelectorType.SUCCESS : MaxSuccessFightMoveSelector(),
  EFightMoveSelectorType.EXPECTED_DAMAGE: MaxExpectedDamageFightMoveSelector(),
  EFightMoveSelectorType.COST_BALANCED: MaxCostBalancedDamageFightMoveSelector()
};


class FightMoveSelector {
  FightMove? getMove(Fight fight, Fighter forFighter, Fighter targetFighter) {
    throw Exception();
  }
}

class RandomFightMoveSelector extends FightMoveSelector {

  @override
  FightMove? getMove(Fight fight, Fighter forFighter, Fighter targetFighter) {
    final validMoves = forFighter.moves.where( (m)=> forFighter.pose == m.pose && targetFighter.pose == m.targetPose).toList();
    final int moveIndex = (Random().nextDouble() * validMoves.length).toInt();
    return validMoves.isNotEmpty ? validMoves[moveIndex] : null;
  }
}


// Pick best looking only at damage
class MaxDamageFightMoveSelector extends FightMoveSelector {

  @override
  FightMove? getMove(Fight fight, Fighter forFighter, Fighter targetFighter) {
    final validMoves = forFighter.moves.where( (m)=> forFighter.pose == m.pose && targetFighter.pose == m.targetPose).toList();

    validMoves.sort((m0, m1)=> m0.damage(fight.range, forFighter) > m1.damage(fight.range, forFighter) ? -1 : 1);

    return validMoves.isNotEmpty ? validMoves.first : null;
  }

}


// Pick best looking only at expected success
class MaxSuccessFightMoveSelector extends FightMoveSelector {

  @override
  FightMove? getMove(Fight fight, Fighter forFighter, Fighter targetFighter) {
    final validMoves = forFighter.moves.where( (m)=> forFighter.pose == m.pose && targetFighter.pose == m.targetPose).toList();

    validMoves.sort((m0, m1)=> m0.success(fight.range, forFighter) > m1.success(fight.range, forFighter) ? -1 : 1);

    return validMoves.isNotEmpty ? validMoves.first : null;
  }

}



class MaxExpectedDamageFightMoveSelector extends FightMoveSelector {

  @override
  FightMove? getMove(Fight fight, Fighter forFighter, Fighter targetFighter) {
    final validMoves = forFighter.moves.where( (m)=> forFighter.pose == m.pose && targetFighter.pose == m.targetPose).toList();

    validMoves.sort((m0, m1)=> m0.expectedDamage(fight.range, forFighter) > m1.expectedDamage(fight.range, forFighter) ? -1 : 1);

    return validMoves.isNotEmpty ? validMoves.first : null;

  }
}

class MaxCostBalancedDamageFightMoveSelector extends FightMoveSelector {

  @override
  FightMove? getMove(Fight fight, Fighter forFighter, Fighter targetFighter) {
    final validMoves = forFighter.moves.where( (m)=> forFighter.pose == m.pose && targetFighter.pose == m.targetPose).toList();

    validMoves.sort((m0, m1)=> m0.costBalancedDamage(fight.range, forFighter) > m1.costBalancedDamage(fight.range, forFighter) ? -1 : 1);

    return validMoves.isNotEmpty ? validMoves.first : null;

  }
}
