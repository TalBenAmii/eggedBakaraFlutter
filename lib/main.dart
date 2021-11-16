import 'dart:ui';

import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/screens/data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/data_screen.dart';

//todo: arrange code
//todo: animations + slow visable on top
//todo: fix screen sizing(learn responise app)
//todo: make a swipe down for the stats
//todo: add dividers and borders in data screen
//todo: make a more detailed history
//todo: make stats calc improvments(working days)
//todo: fix renderflex when animatedContainer
//todo: make double icon (stats and down arrow) in top of screen

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
    return ChangeNotifierProvider(
      create: (ctx) => UserData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child,
            );
          },
          title: 'אגד בקרה',
          home: DataScreen(),
          theme: MyTheme().theme()),
    );
  }
}
