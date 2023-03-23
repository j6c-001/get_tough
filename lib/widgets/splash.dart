import 'dart:async';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:get_tough/managers/game_data_manager.dart';
import '../main.dart';
import 'package:flutter/material.dart';

class SplashFuturePage extends StatefulWidget {
  const SplashFuturePage({Key? key}) : super(key: key);

  @override
  _SplashFuturePageState createState() => _SplashFuturePageState();
}

class _SplashFuturePageState extends State<SplashFuturePage> {

  Future<Widget> futureCall() async {
    await GameDataManager().load();
    return Future.value(const MyHomePage(title: 'Get Tough'));
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network('https://raw.githubusercontent.com/j6c-001/get_tough/master/title.png'),
      title: const Text(
        "Get Tough",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      loadingText: const Text("Loading..."),
      futureNavigator: futureCall(),
    );
  }
}