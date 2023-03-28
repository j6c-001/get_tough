// ignore_for_file: constant_identifier_names

import 'package:get_tough/classes/character_controller.dart';
import 'package:get_tough/managers/character_manager.dart';
import 'package:get_tough/managers/items_manager.dart';

import 'classes/item.dart';
import 'utils/directions.dart';

enum CommandType {MOVE, GET, DROP, LOOK, EXAMINE, INVENTORY, UNLOCK, LOCK, GIVE, THROW, DRINK, EAT, NONE }

class  CommandBase {

  final CommandType type;
  final String verb;
  final int? nounId;
  final int? noun2Id;
  final String? preposition;

  const CommandBase(this.type, this.verb, this.nounId, this.noun2Id, this.preposition);

   bool get isBuilt => false;

  String get label => verb;

  List<CommandBase> getSubCommands(CharacterController cc, {int? nounId}) {
    return [];
  }

  String get text => verb + (nounId != null ? ' ${getLabel(nounId!)} ${preposition ?? ''}${noun2Id != null ? ' ${getLabel(noun2Id!)}' : ''}' : '');




}

class Command extends CommandBase {
  Command(CommandType type, String verb, {int? nounId, int? noun2Id, String? preposition}) : super(type,verb, nounId, noun2Id,  preposition);

  @override
  bool get isBuilt => true;
}

class CommandVisibleItems extends Command {
  CommandVisibleItems(CommandType type, String verb, {int? nounId, int? noun2Id, String? preposition}) :
        super(type,verb, nounId: nounId, noun2Id: noun2Id, preposition: preposition);

  @override
  bool get isBuilt => super.isBuilt && nounId != null && nounId != 0;

  @override
  List<CommandBase> getSubCommands(CharacterController cc, {int? nounId}) {
    final List<Item> items = cc.currentPlace.itemsHere;
    final ids = [];
    if(type==CommandType.EXAMINE) {
      items.addAll(cc.character.inventory);
      ids.addAll(cc.currentPlace.charactersHere.map((it)=>it.id));
    }
    ids.addAll(items.map<int>((Item it)=>it.id));
    return ids.map((id) =>CommandVisibleItems(type, verb, nounId: id) ).toList();
  }

  @override
  String get label => nounId != null  ? getLabel(nounId!) : super.label;

}
class CommandWithItems extends Command {
  CommandWithItems(CommandType type, String verb, {int? nounId, int? noun2Id, required preposition }) :
        super(type,verb, nounId: nounId, noun2Id: noun2Id, preposition: preposition);

  @override
  List<CommandBase> getSubCommands(CharacterController cc, {int? nounId}) {
      final List<Item> items = cc.currentPlace.itemsHere;
      final ids = [];
      if (nounId == null ) {
        ids.addAll(cc.currentPlace.charactersHere.where((it) => it.id !=
            cc.character.id).map((it) => it.id));
        ids.addAll(items.map<int>((Item it) => it.id));
      } else {
        ids.addAll(cc.character.inventory.map((it)=>it.id));
      }
      return ids.where((it)=> (nounId == null || it != nounId)).map((id) =>
          CommandWithItems(type, verb, nounId: nounId ?? id, noun2Id: nounId != null ? id : null, preposition: preposition)).toList();
  }

  @override
  bool get isBuilt => super.isBuilt && noun2Id != null && noun2Id != 0;
  @override
  String get label => noun2Id != null ? getLabel(noun2Id!)  : (nounId != null  ? getLabel(nounId!) : super.label);

}

String getLabel(int id) {

  if(ItemsManager().items.containsKey(id)) {
    return ItemsManager().items[id]!.name;
  }
  return CharacterManager().characters[id]!.name;
}


class CommandInventoryItems extends Command {
  CommandInventoryItems(CommandType type, String verb, {int? nounId})
      : super(type, verb, nounId: nounId);

  @override
  bool get isBuilt => super.isBuilt && nounId != null && nounId != 0;

  @override
  List<CommandBase> getSubCommands(CharacterController cc, {int? nounId}) {
    return cc.character.inventory.map<CommandVisibleItems>((Item it) =>
        CommandVisibleItems(type, verb, nounId: it.id)).toList();
  }

  @override
  String get label =>
      nounId != null ? ItemsManager().items[nounId]!.name : super.label;

}



  class CommandStack {
  final CharacterController characterController;
  CommandStack(this.characterController);
  List<List<CommandBase>> stack = [[
    Command(CommandType.MOVE, directionText[N]),
    Command(CommandType.MOVE, directionText[S]),
    Command(CommandType.MOVE, directionText[E]),
    Command(CommandType.MOVE, directionText[W]),
    Command(CommandType.LOOK, 'Look Around'),
    CommandWithItems(CommandType.UNLOCK, 'Unlock', preposition: 'with'),
    CommandWithItems(CommandType.LOCK, 'Lock', preposition: 'with'),
    CommandWithItems(CommandType.THROW, 'Throw', preposition: 'at'),
    CommandWithItems(CommandType.GIVE, 'Give', preposition: 'the'),
    CommandVisibleItems(CommandType.EXAMINE, 'Examine'),
    CommandVisibleItems(CommandType.GET, 'Get'),
    CommandInventoryItems(CommandType.DROP, 'Drop'),
    Command(CommandType.INVENTORY, 'Inventory'),
  ]];

  List<CommandBase> get commands => stack.last;

  get depth => stack.length;

  void push(List<CommandBase> commands) {
    stack.add(commands);
  }

  void pop() {
    stack.removeLast();
  }

  void reset() {
    while(stack.length > 1) {
      pop();
    }
  }
}


