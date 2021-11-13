import 'package:flutter/material.dart';

class MyTheme {
  ThemeData theme() {
    return ThemeData(
      fontFamily: 'OpenSans',
      primarySwatch: Colors.green,
      // ignore: deprecated_member_use
      accentColor: Colors.green.shade800,
      canvasColor: Color(0xFFDEFFD3),
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            headline5: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            headline4: TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
            headline3: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            headline2: TextStyle(
              fontSize: 16,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
            headline1: TextStyle(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
