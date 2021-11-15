import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/screens/data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/data_screen.dart';

//todo: arrange code
//todo: animations + slow visable on top
//todo: make year selection + fix year select (if isnt working)
//todo: make a downarrow for every history section
//todo: fix screen sizing(learn responise app)
//todo: make a swipe down for the stats
//todo: add dividers and borders in data screen

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
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child,
          );
        },
        title: 'אגד בקרה',
        home: DataScreen(),
        theme: MyTheme().theme(),
      ),
    );
  }
}
