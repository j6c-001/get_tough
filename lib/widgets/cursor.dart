import 'package:flutter/widgets.dart';

class Cursor extends StatefulWidget {
  const Cursor({super.key});



  @override
  State<Cursor> createState() => CursorState();
}

class CursorState extends State<Cursor> {
  double opacityLevel = 1.0;

  void changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => changeOpacity());
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedOpacity(
          opacity: opacityLevel,
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 250),
          onEnd: ()=>changeOpacity(),
          child: const Text('|')

        ),
      ],
    );
  }
}