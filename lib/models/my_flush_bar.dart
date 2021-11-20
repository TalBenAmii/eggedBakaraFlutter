import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class MyFlushBar {
  final String text;
  final Color color;
  final IconData icon;
  final BuildContext context;

  MyFlushBar(
    this.text,
    this.color,
    this.icon,
    this.context,
  );

  Flushbar buildFlushBar() {
    return Flushbar(
      icon: Icon(
        icon,
        size: 28.0,
        color: color,
      ),
      leftBarIndicatorColor: color,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      message: text,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}
