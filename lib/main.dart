import 'dart:ui';

import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/screens/data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/data_screen.dart';

//todo: arrange code, performance testing and docs
//todo: make a dragable stats, make airplane animation in stats
//todo: make plus icon with green label - progressbar

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
