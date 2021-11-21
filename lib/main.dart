import 'dart:ui';

import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/screens/data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/data_screen.dart';

//todo: arrange code
//todo: make a dragable stats, make airplane animation in stats
//todo: make a more detailed history and improve appearance (listtile with icons in bakarot..)
//todo: make plus icon with green labels in history + progressbar
//todo: make no history icon
//todo: add blurry effect in history
//todo: dont count up when adding data / count from previous data to the current data

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
