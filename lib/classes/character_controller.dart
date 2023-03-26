import 'package:get_tough/classes/character.dart';
import 'package:get_tough/classes/item_or_character.dart';
import 'package:get_tough/managers/location_manager.dart';
import 'package:get_tough/managers/places_manager.dart';

import '../commands.dart';
import '../main.dart';
import '../utils/directions.dart';
import 'place.dart';

class CharacterController {
  Character character;

  CharacterController({required this.character});

  int get currentPlaceId => LocationManager().locations[character.id]!.locationId;
  Place get currentPlace => PlacesManager().places[currentPlaceId]!;
  bool tryMoveTo(int placeId) {
    if (PlacesManager().places.containsKey(placeId)) {
      LocationManager().locations[character.id] = ItemOrCharacterLocation(character.id, placeId);
      return true;
    }
    return false;
  }


  process(Command cmd) {
    tape.last = '> ${cmd.verb}';
    final int placeId = currentPlaceId;
    switch(cmd.type) {
      case CommandType.MOVE:
        doMove(cmd);
        break;
      case CommandType.LOOK:
        doLook(cmd);
        break;

    }

    if(placeId != currentPlaceId) {
     tape.add(currentPlace.shortDescription);
    }

    tape.add('>');
  }

   void doMove(Command cmd) {
    final exits = currentPlace.exits;
    final i = getDirectionIndex(cmd.verb);
    final destId = exits[i];
    if (tryMoveTo(destId)) {
      tape.add( 'You walk ${cmd.verb}' );
    } else {
      tape.add('You can\'t go there');
    }
  }

  void doLook(Command cmd) {
      int i = 0;
      final validExits = currentPlace.exits.fold([], (pb, element) {
          if(element != 0) {
            pb.add(directionText[i]);
          }
          i++;
          return pb;
      }).join(', ');

      tape.add('The world is a vast place. You are in ${currentPlace.pathName}');
      tape.add('Here you can see:');
      tape.add(currentPlace.longDescription);
      tape.add('There are routes to the $validExits');
      tape.add('There can see ${currentPlace.visibleItems.map((item)=>item.name).join(', ')}');




  }


}

