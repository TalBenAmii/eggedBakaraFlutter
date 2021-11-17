import 'package:flutter/material.dart';

final double WIDTH =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
final double HEIGHT =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
const COLOR_GREY = Color.fromRGBO(141, 141, 141, 1.0);

const COLOR_WHITE = Colors.white;
const COLOR_DARK_BLUE = Color.fromRGBO(20, 25, 45, 1.0);

const TextTheme TEXT_THEME_DEFAULT = TextTheme(
    headline1: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 32),
    headline2: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 28),
    headline3: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 22),
    headline4: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 20),
    headline5: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 16),
    headline6: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 14),
    subtitle1: TextStyle(
        color: COLOR_BLACK, fontSize: 12, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 12, fontWeight: FontWeight.w400));

const TextTheme TEXT_THEME_SMALL = TextTheme(
    headline1: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 26),
    headline2: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 22),
    headline3: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 20),
    headline4: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 18),
    headline5: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 12),
    headline6: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 10),
    subtitle1: TextStyle(
        color: COLOR_BLACK, fontSize: 10, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 10, fontWeight: FontWeight.w400));
