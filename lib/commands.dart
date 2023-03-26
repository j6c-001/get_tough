
import 'utils/directions.dart';

enum CommandType {MOVE, GET, LOOK, EXAMINE, INVENTORY}

class  Command {

  final CommandType type;
  final String verb;
  final String? noun;
  final String? target;
  final String? preposition;

  const Command._internal(this.type, this.verb, this.noun, this.preposition, this.target);

   factory  Command(CommandType type, String cmd) {
     final tkns = cmd.split('|');
     final verb = tkns[0];
     final noun = tkns.length > 1 ? tkns[1] : null;
     final  preposition = tkns.length > 2 ? tkns[2] : null;
     final  target = tkns.length > 3 ? tkns[3] : null;
     return  Command._internal(type, verb, noun, preposition, target);
   }
}


final commands = [
  Command(CommandType.MOVE, directionText[N]),
  Command(CommandType.MOVE, directionText[S]),
  Command(CommandType.MOVE, directionText[E]),
  Command(CommandType.MOVE, directionText[W]),
  Command(CommandType.LOOK, 'Look'),
];


