import 'dart:async';
import 'dart:ui' as ui;

import 'package:countup/countup.dart';
import 'package:egged_bakara/widgets/calender_timeline.dart';
import 'package:egged_bakara/widgets/history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';

class Data extends StatefulWidget {
  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  bool init = true;
  bool initLoadData = true;
  bool initDay = true;
  int loadTime = 1500;
  bool animate;
  UserData userData;

  Widget _progressBar(MediaQueryData mediaQuery, double per) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      LinearPercentIndicator(
        width: mediaQuery.size.width - 50,
        animation: true,
        lineHeight: 30.0,
        animationDuration: loadTime,
        percent: per,
        center: Text(
          (per * 100).toStringAsFixed(2) + '%',
          style: TextStyle(fontSize: 18),
        ),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.green,
      ),
    ]);
  }

  Countup countUpAnimation(double end, String prefix, String suffix) {
    return Countup(
      begin: 0,
      prefix: prefix,
      suffix: suffix,
      end: end,
      duration: Duration(seconds: loadTime ~/ 1000),
      separator: ',',
      style: TextStyle(
        fontSize: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    userData = Provider.of<UserData>(context, listen: false);
    double bakarotPer = userData.bakarotGoal != 0
        ? userData.monthlyBakarot / userData.bakarotGoal
        : 0;
    double tikufimPer = userData.tikufimGoal != 0
        ? userData.monthlyTikufim / userData.tikufimGoal
        : 0;
    double knasotPer = userData.knasotGoal != 0
        ? userData.monthlyKnasot / userData.knasotGoal
        : 0;
    if (bakarotPer > 1.0) {
      bakarotPer = 1.0;
    }
    if (tikufimPer > 1.0) {
      tikufimPer = 1.0;
    }
    if (bakarotPer > 1.0) {
      bakarotPer = 1.0;
    }
    if (knasotPer > 1.0) {
      knasotPer = 1.0;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.directions_bus),
            ),
            title: countUpAnimation(userData.monthlyBakarot.toDouble(),
                'בקרות: ', '/${userData.bakarotGoal}'),
            subtitle: Text(
              'נותרו: ${userData.bakarotGoal - userData.monthlyBakarot}',
              style: TextStyle(fontSize: 24),
            )),
        _progressBar(mediaQuery, bakarotPer),
        ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.confirmation_num),
            ),
            title: countUpAnimation(userData.monthlyTikufim.toDouble(),
                'בקרות: ', '/${userData.tikufimGoal}'),
            subtitle: Text(
              'נותרו: ${userData.tikufimGoal - userData.monthlyTikufim}',
              style: TextStyle(fontSize: 24),
            )),
        _progressBar(mediaQuery, tikufimPer),
        ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.my_location),
            ),
            title: countUpAnimation(userData.monthlyKnasot.toDouble(),
                'בקרות: ', '/${userData.knasotGoal}'),
            subtitle: Text(
              'נותרו: ${userData.knasotGoal - userData.monthlyKnasot}',
              style: TextStyle(fontSize: 24),
            )),
        _progressBar(mediaQuery, knasotPer),
        History()
      ],
    );
  }
}
