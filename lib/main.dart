import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/screens/data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/data_screen.dart';

//todo: make countup animations + animations + slow visable
//todo: make year selection + fix year select (if isnt working)
//todo: make a downarrow for every history section
//todo: fix screen sizing(learn responise app)
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
      title: 'אגד בקרה',
      home: DataScreen(),
      theme: MyTheme().theme(),
    );
  }
}
