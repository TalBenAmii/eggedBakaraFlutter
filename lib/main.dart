import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/screens/data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/data_screen.dart';

//todo: make countup animations + animations
//todo: make stats screen
//todo: make bolder month and year selection
//todo: fix bottom button gap (navigator bar maybe)
//todo: make a downarrow for every history section
//todo: change stats screen icon
//todo: make a listtile with icon in tikufim...
//todo: make a nicer history that displays more details
//todo: fix screen sizing
//todo: make a swipe down for the stats

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
      title: 'My Expenses',
      home: DataScreen(),
      theme: MyTheme().theme(),
    );
  }
}
