import 'dart:ui';

import 'package:flutter/material.dart';

import 'utils/constants.dart';

class MyTheme {
  ThemeData theme() {
    return ThemeData(
      fontFamily: "VarelaRound",
      primarySwatch: Colors.green,
      // ignore: deprecated_member_use
      accentColor: Colors.green.shade800,
      canvasColor: Color(0xFFD1FFBD),
      iconTheme: IconThemeData(color: Colors.white),
      textTheme:
          WIDTH < 400 && HEIGHT < 700 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
