import 'package:flutter/material.dart';
import 'package:get_tough/classes/character_controller.dart';
import 'package:get_tough/managers/character_manager.dart';
import 'package:get_tough/managers/places_manager.dart';
import 'package:get_tough/utils/directions.dart';
import 'package:get_tough/widgets/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  CharacterController cc = CharacterController(character: CharacterManager().you);


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),

      ),
      body:  Center(
        child: Column(
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: SingleChildScrollView(
              child:Text(cc.currentPlace.longDescription)
            )),
            ButtonBar(
            children: [
            PopupMenuButton<int>(
                onSelected: (int placeId ){
                setState(() {
                  cc.moveTo(placeId);
                });
                },
                itemBuilder: (BuildContext ctx) {
                final exits = cc.currentPlace.exits;
                int i = 0;
                return exits.map<PopupMenuItem<int>>((int placeId) {
                    var pi = const PopupMenuItem<int>(value: null, child: Text('None') );
                    if (PlacesManager().places.containsKey(placeId)) {
                      pi = PopupMenuItem<int>(value: placeId, child: Text(directionText[i]));
                    }
                    i++;
                    return pi;
                  }).where((it)=>it.value != null).toList();
                },

                tooltip: 'Navigate',
                child: const Icon(Icons.directions_walk),
                ),
            ],
            )
          ],
        ),
      ),
    );
  }
}
