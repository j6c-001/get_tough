import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

enum EntryType {
  NONE,
  RESPONSE,
  COMMAND,
  COMMAND_COMMIT,
}


class Input {
  final EntryType type;
  final List<int> charCodes;

  Input(this.type, this.charCodes);
}

class Output {
  final EntryType type;
  final String text;
  bool pending = true;
  Output(this.type, this.text);
}

class Tape extends TickerProvider {

  final List<Output> _tape = [Output(EntryType.RESPONSE, "")];
  final List<Input> _inputQueue = [];

  late final AnimationController _textUpdater;

  var state;

  int get length => _tape.length;
  
  Tape(List<String> initialTape) {
    _textUpdater = AnimationController(vsync: this, duration: const Duration(minutes: 1));
    addAllResponses(initialTape);
    addCmdPrompt();
  }

  String get last => _tape.last.text;


  add(EntryType type, String s) {
    if(!_textUpdater.isAnimating) {
      _textUpdater.repeat();
    }
    _inputQueue.insert(0,Input(type, s.codeUnits.reversed.toList()));
  }

  undoCommand(String s) {
    Output currentOut = _tape.last;
    final isCmdPending  = _inputQueue.indexWhere((it) => it.type == EntryType.COMMAND_COMMIT ) == -1;
      final charDiff =  s.length - currentOut.text.length;
      if(isCmdPending && charDiff < 0) {
        add(EntryType.COMMAND, '\b' * (charDiff).abs());
      }
  }

  addCmdPrompt() {
    commitCommand();
    add(EntryType.COMMAND, '');
  }

  addResponse(String text) {
    add(EntryType.RESPONSE, text);
  }

  addAllResponses(List<String> v) {
    for (var s in v) {
      addResponse(s);
    }
  }


  buildCommand(String s) {
    Output currentOut = _tape.last;
    final isCmdPending  = _inputQueue.indexWhere((it) => it.type == EntryType.COMMAND_COMMIT ) == -1;
    final currCmdLength = currentOut.text.length;
    final charDiff =  s.length - currCmdLength;
    if (isCmdPending  && charDiff >= 0 && currCmdLength >= 0) {
      s = s.substring(currCmdLength);
      add(EntryType.COMMAND, s);
    }
  }

  void commitCommand() {
    add(EntryType.COMMAND_COMMIT, '');
  }



  update(t) {
    if (_inputQueue.isEmpty) {
      return;
    }

    final input = _inputQueue.last;

    final List<int> h = input.charCodes;
    var out = _tape.last;

    final currentOut = _tape.last;


    if(input.type != EntryType.COMMAND_COMMIT) {

      if (currentOut.type != input.type || !currentOut.pending) {
        _tape.add(Output(input.type, ""));
      }

      final c = h.isNotEmpty ? String.fromCharCode(h.last) : '';
      out = (c == '\b') ? Output(_tape.last.type,
          _tape.last.text.substring(0, _tape.last.text.length - 1)) :
      Output(_tape.last.type, _tape.last.text + c);

      _tape.last = out;

      if(h.isNotEmpty) {
        h.removeLast();
      }
    }

    if (h.isEmpty) {
       out.pending = out.type == EntryType.COMMAND;
      _inputQueue.removeLast();
    }

}

  Output at(int index){
    return _tape[_tape.length - index];
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
     return Ticker((elapsed) {
      if(_inputQueue.isEmpty) {
        _textUpdater.stop();
      }
       for (int _ in [0, 1, 3, 4,3]) {
         state?.setState(() => update(elapsed));
       }
     });
  }


}