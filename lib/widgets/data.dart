import 'package:countup/countup.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:egged_bakara/widgets/history.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';

class Data extends StatelessWidget {
  int loadTime = 1500;
  bool history;
  UserData userData;
  Data({this.history = false});

  Widget _progressBar(double per, BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      LinearPercentIndicator(
        width: WIDTH - 50,
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

  Countup countUpAnimation(
      double end, String prefix, String suffix, BuildContext context) {
    return Countup(
        begin: 0,
        prefix: prefix,
        suffix: suffix,
        end: end,
        duration: Duration(seconds: loadTime ~/ 1000),
        separator: ',',
        style: Theme.of(context).textTheme.headline1);
  }

  Widget buildDataTile(IconData icon, String data, int current, int goal,
      double per, BuildContext context) {
    int left = goal - current < 0 ? 0 : goal - current;
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
              title: countUpAnimation(
                  current.toDouble(), '$data ', '/${goal}', context),
              subtitle: Text(
                'נותרו: ${left}',
                style: TextStyle(fontSize: 24),
              )),
          _progressBar(per, context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserData>(context);
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
            userData.bakarotGoal, bakarotPer, context),
        buildDataTile(Icons.confirmation_num_rounded, 'תיקופים:',
            userData.monthlyTikufim, userData.tikufimGoal, tikufimPer, context),
        buildDataTile(Icons.my_location, 'קנסות:', userData.monthlyKnasot,
            userData.knasotGoal, knasotPer, context),
      ],
    );
  }
}
