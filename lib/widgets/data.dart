import 'package:countup/countup.dart';
import 'package:egged_bakara/widgets/history.dart';
import 'package:flutter/material.dart';
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
  MediaQueryData mediaQuery;

  Widget _progressBar(double per) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      LinearPercentIndicator(
        width: mediaQuery.size.width - 50,
        animation: true,
        lineHeight: 30.0,
        animationDuration: loadTime,
        percent: per,
        center: Text(
          (per * 100).toStringAsFixed(2) + '%',
          style: Theme.of(context).textTheme.headline3,
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
        style: Theme.of(context).textTheme.headline1);
  }

  Widget buildDataTile(
      IconData icon, String data, int current, int goal, double per) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        children: [
          ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  icon,
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: countUpAnimation(current.toDouble(), '$data ', '/${goal}'),
              subtitle: Text(
                'נותרו: ${goal - current}',
                style: TextStyle(fontSize: 24),
              )),
          _progressBar(per),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
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
        buildDataTile(Icons.directions_bus, 'בקרות:', userData.monthlyBakarot,
            userData.bakarotGoal, bakarotPer),
        buildDataTile(Icons.confirmation_num_rounded, 'תיקופים:',
            userData.monthlyTikufim, userData.tikufimGoal, tikufimPer),
        buildDataTile(Icons.my_location, 'קנסות:', userData.monthlyKnasot,
            userData.knasotGoal, knasotPer),
        History()
      ],
    );
  }
}
