import 'dart:ui';

import 'package:flutter/material.dart';

import 'utils/constants.dart';

double screenWidth = window.physicalSize.width;

class MyTheme {
  ThemeData theme() {
    return ThemeData(
      fontFamily: "VarelaRound",
      primarySwatch: Colors.green,
      // ignore: deprecated_member_use
      accentColor: Colors.green.shade800,
      canvasColor: Color(0xFFDEFFD3),
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: screenWidth < 500 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
