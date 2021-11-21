import 'package:countup/countup.dart';
import 'package:egged_bakara/models/history_data.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:egged_bakara/widgets/history.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';

class Data extends StatelessWidget {
  int loadTime = 1500;
  bool history, isMonthHistory;
  UserData userData;
  HistoryData dayHistory, monthHistory;

  int monthlyBakarot,
      monthlyTikufim,
      monthlyKnasot,
      bakarotGoal,
      tikufimGoal,
      knasotGoal,
      bakarotAdded,
      tikufimAdded,
      knasotAdded;
  Data(
      {this.history = false,
      this.dayHistory,
      this.monthHistory,
      this.isMonthHistory});

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
      int added, double per, BuildContext context) {
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
              trailing: history && added != 0 && added != null
                  ? Text(
                      '+' + added.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: Colors.green),
                    )
                  : Text(''),
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
    if (history) {
      if (isMonthHistory) {
        monthlyBakarot = monthHistory.monthlyBakarot;
        monthlyTikufim = monthHistory.monthlyTikufim;
        monthlyKnasot = monthHistory.monthlyKnasot;
      } else {
        monthlyBakarot = dayHistory.monthlyBakarot;
        monthlyTikufim = dayHistory.monthlyTikufim;
        monthlyKnasot = dayHistory.monthlyKnasot;
        bakarotAdded = dayHistory.bakarotAdded;
        tikufimAdded = dayHistory.tikufimAdded;
        knasotAdded = dayHistory.knasotAdded;
      }

      bakarotGoal = monthHistory.bakarotGoal;
      tikufimGoal = monthHistory.tikufimGoal;
      knasotGoal = monthHistory.knasotGoal;
    } else {
      monthlyBakarot = userData.monthlyBakarot;
      monthlyTikufim = userData.monthlyTikufim;
      monthlyKnasot = userData.monthlyKnasot;
      bakarotGoal = userData.bakarotGoal;
      tikufimGoal = userData.tikufimGoal;
      knasotGoal = userData.knasotGoal;
    }
    double bakarotPer = bakarotGoal != 0 ? monthlyBakarot / bakarotGoal : 0;
    double tikufimPer = tikufimGoal != 0 ? monthlyTikufim / tikufimGoal : 0;
    double knasotPer = knasotGoal != 0 ? monthlyKnasot / knasotGoal : 0;
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
        buildDataTile(Icons.directions_bus, 'בקרות:', monthlyBakarot,
            bakarotGoal, bakarotAdded, bakarotPer, context),
        buildDataTile(Icons.confirmation_num_rounded, 'תיקופים:',
            monthlyTikufim, tikufimGoal, tikufimAdded, tikufimPer, context),
        buildDataTile(Icons.my_location, 'קנסות:', monthlyKnasot, knasotGoal,
            knasotAdded, knasotPer, context),
      ],
    );
  }
}
