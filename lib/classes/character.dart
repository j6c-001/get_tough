import 'dart:core';
import 'dart:math';

import 'package:get_tough/classes/fight_move.dart';
import 'package:get_tough/classes/item_or_character.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/utils/hash.dart';

import '../managers/fight_moves_manager.dart';
import '../managers/fight_profiles_manager.dart';
import '../managers/items_manager.dart';
import 'item.dart';
import 'range_modifier.dart';

enum ESex {MALE, FEMALE}

class Character {

   Character({
    required this.id,
    required this.name,
    required this.longName,
    required this.longDescription,
    required this.defaultPlaceId,
    required this.defaultFightProfileId,
    required this.defaultHealth,
    required this.defaultEnergy,
    required this.defaultSpeed,
     required this.sex,
  }) : speed  = defaultSpeed,
       health = defaultHealth,
       energy = defaultEnergy,
       isYou = name == 'You',
       pronouns = name == 'You' ? ['You', 'Your'] : (sex == ESex.MALE ? ['He', 'His'] : ['She','Her'] )
  {
    LocationManager().locations[id] = ItemOrCharacterLocation(id, defaultPlaceId);
  }

  final bool isYou;
  final List pronouns;

  final int id;
  final String name;
  final String longName;
  final String longDescription;
  final ESex sex;
  final int defaultPlaceId;
  final int defaultFightProfileId;

  final double defaultEnergy;
  final double defaultHealth;
  final double defaultSpeed;

  double energy;
  double health;
  double speed;
  int level = 1;

  final RangeModifier fightMoveSuccessModifier = RangeModifier();
  final RangeModifier fightMoveDamageModifier = RangeModifier();

  final Set<int> _fightMoveIds = {};

  @override
  String toString() => 'Character(id: $id, name: $name)';

  static Character fromJson(Map<String, dynamic> json) {
    final c = Character(
      id: idHash(json['Id']),
      name: json['Name'],
      longName: json['Long Name'],
      longDescription: json['Long Description'],
      defaultPlaceId: idHash(json['Starting Place Id']),
      defaultFightProfileId: idHash(json['Fight Profile']),
      defaultEnergy: double.tryParse(json['Default Energy']) ?? 100,
      defaultHealth: double.tryParse(json['Default Health']) ?? 100,
      defaultSpeed: double.tryParse(json['Default Speed']) ?? 50,
      sex: ESex.MALE
    );

    c.fightMoveDamageModifier.inside = double.tryParse(json['Inside Range Modifier Damage']) ?? 1;
    c.fightMoveDamageModifier.short = double.tryParse(json['Short Range Modifier Damage']) ?? 1;
    c.fightMoveDamageModifier.mid = double.tryParse(json['Mid Range Modifier Damage']) ?? 1;

    c.fightMoveDamageModifier.inside = double.tryParse(json['Inside Range Modifier Success']) ?? 1;
    c.fightMoveSuccessModifier.short = double.tryParse(json['Short Range Modifier Success']) ?? 1;
    c.fightMoveSuccessModifier.mid = double.tryParse(json['Inside Range Modifier Success']) ?? 1;

    return c;
  }

  String get pronoun => pronouns[0];
  String get possessivePronoun => pronouns[1];
  String get colourVerb => isYou ? youColourVerbs[Random().nextInt(youColourVerbs.length)] : p3ColourVerbs[Random().nextInt(p3ColourVerbs.length)];

  List<Item> get inventory => ItemsManager().items.values.where((item) => LocationManager().locations[item.id]!.locationId == id ).toList();

  Iterable<FightMove> get fightMoves => _fightMoveIds.isEmpty ? addFightProfile(defaultFightProfileId) : getFightMoves();


  Iterable<FightMove> addFightProfile(int profileId) {
    FightProfilesManager().addProfile(_fightMoveIds, profileId);
    return  getFightMoves();
  }

   Iterable<FightMove> getFightMoves() {
     return _fightMoveIds.map<FightMove>((id)=>FightMovesManager().moves[id]!);
   }

}

final youColourVerbs = ['break', 'smash'];
final p3ColourVerbs =  ['smashes', 'breaks'];