import 'package:get_tough/classes/character.dart';
import 'package:get_tough/classes/item_or_character.dart';
import 'package:get_tough/classes/trigger.dart';
import 'package:get_tough/managers/action_rule_manager.dart';
import 'package:get_tough/managers/character_manager.dart';
import 'package:get_tough/managers/fight_profiles_manager.dart';
import 'package:get_tough/managers/items_manager.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/managers/places_manager.dart';
import 'package:get_tough/managers/trigger_manager.dart';

import '../commands.dart';
import '../main.dart';
import '../utils/directions.dart';
import 'fight.dart';
import 'item.dart';
import 'place.dart';

class CharacterController {
  Character character;

  CharacterController({required this.character});

  int get currentPlaceId => LocationManager().locations[character.id]!.locationId;
  Place get currentPlace => PlacesManager().places[currentPlaceId]!;
  bool tryMoveTo(int placeId) {



    if (PlacesManager().places.containsKey(placeId)) {
      final moveRules =  ActionRuleManager().findMoveRules(currentPlaceId, placeId);

      List<String> passes = [];
      List<String> fails = [];
      for (var r in moveRules) {
        if (r.condition.test) {
          passes.add(r.passText);
        } else {
          fails.add(r.failText);
        }
      }

      tape.addAllResponses(passes);
      if (fails.isEmpty) {
        LocationManager().locations[character.id] = ItemOrCharacterLocation(character.id, placeId);
        return true;
      } else {
        tape.addAllResponses(fails);
      }
    }
    return false;
  }


  process(CommandBase cmd) {

    final int placeId = currentPlaceId;
    switch(cmd.type) {
      case CommandType.MOVE:
        doMove(cmd);
        break;
      case CommandType.LOOK:
        doLook(cmd);
        break;
      case CommandType.EXAMINE:
        doExamine(cmd);
        break;
      case CommandType.GET:
        doGet(cmd);
        break;
      case CommandType.DROP:
        doDrop(cmd);
        break;
      case CommandType.READ:
        doRead(cmd);
        break;
      case CommandType.INVENTORY:
        doInventory(cmd);
        break;
      case CommandType.UNLOCK:
      case CommandType.LOCK:
        doUnLockAndLock(cmd);

        break;
      case CommandType.GIVE:
        doGive(cmd);
        break;
      case CommandType.THROW:
        // TODO: Handle this case.
        break;
      case CommandType.DRINK:
        // TODO: Handle this case.
        break;
      case CommandType.EAT:
        // TODO: Handle this case.
        break;
      case CommandType.NONE:
        // TODO: Handle this case.
        break;
      case CommandType.FIGHT:
        doFight(cmd);
        break;
    }

    doTriggers(cmd);

    if(placeId != currentPlaceId) {
     tape.addResponse(currentPlace.shortDescription);
    }


    tape.addCmdPrompt();
  }

   void doMove(CommandBase cmd) {


    final exits = currentPlace.exits;
    final i = getDirectionIndex(cmd.verb);
    final destId = exits[i];
    if (tryMoveTo(destId)) {
      tape.addResponse( 'You walk ${cmd.verb}.' );
    } else {
      tape.addResponse('You can\'t go there.');
    }
  }

  void doLook(CommandBase cmd) {
      int i = 0;
      final validExits = currentPlace.exits.fold([], (pb, element) {
          if(element != 0) {
            pb.add(directionText[i]);
          }
          i++;
          return pb;
      }).join(', ');

      tape.addResponse('The world is a vast place. You are in ${currentPlace.pathName}.');
      tape.addResponse(currentPlace.longDescription);
      tape.addResponse('There are routes to the $validExits');
      final vi = currentPlace.itemsHere;
      if (vi.isNotEmpty) {
        final fixedItems = currentPlace.itemsHere.where((it) => it.isImmovable);
        final sd = currentPlace.surfaceDescription.isNotEmpty ? currentPlace.surfaceDescription.toLowerCase() : 'ground';
        tape.addResponse('On the $sd you can see ${currentPlace.itemsHere.where((it) => !it.isImmovable).map((item) => item.nameWithArticle).join(', ')}.');
        tape.addAllResponses(fixedItems.map((it)=>it.name).toList());
      }

      final vp  = currentPlace.charactersHere.where((it) => it != character);
      if(vp.isNotEmpty) {
        tape.addAllResponses(vp.map((it)=>it.name).toList());
      }
  }

  void doExamine(CommandBase cmd) {
    int id = cmd.nounId!;
    if (ItemsManager().items.containsKey(id)) {
      Item item = ItemsManager().items[id]!;
      tape.buildCommand( ' ${item.name}' );
      if (character.inventory.contains(item)) {
        tape.addResponse('You carefully examine the ${item.name}');
        tape.addResponse(item.descriptionWhenInInventory);
      } else {
        tape.addResponse('You inspect the ${item.name} from a distance. ${item
            .longDescription}');
      }
    } else if ( CharacterManager().characters.containsKey(id)) {
      Character character = CharacterManager().characters[id]!;
      tape.buildCommand(' ${character.name}');
      tape.addResponse(character.longDescription);
    }
  }

  void doGet(CommandBase cmd) {
    int id = cmd.nounId!;
    Item item = ItemsManager().items[id]!;
    if(item.isImmovable) {
      tape.addResponse('You can\'t pick up the ${item.name}.');
    } else {
      //tape.buildCommand(' ${item.name}.');
      tape.addResponse('You pick up the ${item.name}.');
      LocationManager().moveTo(id, character.id);
    }
  }

  void doDrop(CommandBase cmd) {
    int id = cmd.nounId!;
    Item item = ItemsManager().items[id]!;
    //tape.buildCommand(' ${item.name}');
    tape.addResponse('You drop the ${item.name}.');
    LocationManager().moveTo(id, currentPlaceId);
  }

  void doInventory(CommandBase cmd) {
    final inv = character.inventory;
    if(inv.isEmpty) {
      tape.addResponse('There is nothing in inventory.');
    } else {
      tape.addResponse('You are carrying ${inv.map((it)=>it.nameWithArticle).join(', ')}.');
    }
  }

  void doRead(CommandBase cmd) {
    int id = cmd.nounId!;
    Item item = ItemsManager().items[id]!;
    tape.buildCommand(' ${item.name}');
    tape.addResponse('You begin reading... but it\'s not interesting.');
  }


  void doGive(CommandBase cmd) {
    final id1 = cmd.nounId ?? 0;
    final id2 = cmd.noun2Id ?? 0;

    final triggers = TriggerManager().find(cmd.type, id1, id2);
    if (triggers.isEmpty) {
      tape.addResponse('It\'s not wanted');
    } else {
      LocationManager().moveTo(id2, id1);
    }

  }

  doUnLockAndLock(CommandBase cmd) {
    final id1 = cmd.nounId ?? 0;
    final id2 = cmd.noun2Id ?? 0;

    final triggers = TriggerManager().find(cmd.type, id1, id2);
    if (triggers.isEmpty) {
      tape.addResponse('It\'s not not going to happen.');
    }
  }

  void doTriggers(CommandBase cmd) {
    final id1 = cmd.nounId ?? 0;
    final id2 = cmd.noun2Id ?? 0;
    final triggers = TriggerManager().find(cmd.type, id1, id2 == 0 ? id1 : id2);

    for (var t in triggers) {
      if(t.doWhat == ETriggerDoWhat.SET_STATE) {
        if (t.condition.value != t.newValue) {
          t.condition.value = t.newValue;
          tape.addResponse(t.description.isNotEmpty ? t.description : 'That did the trick.');
        } else {
          tape.addResponse(t.noChangeDescription.isNotEmpty ? t.noChangeDescription : 'Not much happened.');
        }
      } else if (t.doWhat == ETriggerDoWhat.ADD_FIGHT_PROFILE) {
        character.addFightProfile(t.doWhatThingId);
        if(t.description.isNotEmpty) {
          tape.addResponse( t.description );
          FightProfilesManager().profiles[t.doWhatThingId]!.moves.forEach((move) {
            tape.addResponse(' ${move.name} was added to fighting skills!' );
          });
        }


      }
    }
  }

  void doFight(CommandBase cmd) {
    final target = CharacterManager().characters[cmd.nounId!]!;

    final fight = Fight(character, target);

    fight.fight();

  }





}

