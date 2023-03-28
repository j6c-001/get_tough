import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_tough/classes/character_controller.dart';
import 'package:get_tough/commands.dart';
import 'package:get_tough/managers/character_manager.dart';
import 'package:get_tough/widgets/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

List<String> tape = ['Welcome to Get Tough, a Topaz adventure in the Fairbairn Sykes Universe', '>'];
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Tough',
      scrollBehavior: MyCustomScrollBehavior() ,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    home: const SplashFuturePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CharacterController get cc => cmdStack.characterController;
  List<CommandBase> get commands => cmdStack.commands;
  final CommandStack cmdStack  = CommandStack(CharacterController(character: CharacterManager().you));

  final _scrollController = ScrollController();
  scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),

      ),
    body:   ListView.builder(
      reverse: true,

       controller: _scrollController,
       itemCount: tape.length+1,
        itemBuilder:
          (context, index) {
            if(index > 0) {
              return Text(tape[tape.length - index]);
            } else {
              return Container(
                height: 50,
                decoration: const BoxDecoration(color: Color.fromARGB(255, 127, 134, 107), borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight:  Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.only(left:10, right: 10),
                  child: ListView(

                    scrollDirection: Axis.horizontal,
                      children: [
                        Visibility(visible: cmdStack.depth > 1, child:IconButton( icon: const Icon(Icons.backspace), onPressed: () {
                          setState(() {
                            cmdStack.pop();
                          });
                        }, )),
                        ...commands.map((it)=> ActionChip(
                        onPressed: () {
                          setState(() {
                            tape.last = '>${it.text}';
                            if(it.isBuilt) {
                              cc.process(it);
                              cmdStack.reset();
                            } else {
                              final sc = it.getSubCommands(cc, nounId: it.nounId);
                              if (sc.isEmpty) {
                                tape.add('>${it.verb} the void.');
                                tape.add('The void is too abstract to ${it.label}. ');
                              } else {
                                cmdStack.push(sc);
                              }
                            }
                            scrollToBottom();
                          });
                        },
                        backgroundColor: const Color.fromARGB(255, 113, 134, 107),
                        shadowColor: Colors.grey[60],
                        avatar: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 127, 134, 107),
                          child: Text(it.verb[0].toUpperCase()),
                        ),
                        label: Text(it.label),)
                      ).toList()]
                  ),
                ),
              );
            }
          }
    )
    );
  }
}
