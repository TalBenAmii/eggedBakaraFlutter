import 'package:countup/countup.dart';
import 'package:egged_bakara/models/history_data.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:egged_bakara/widgets/history.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';

class Data extends StatelessWidget {
  int loadTime = 1500, lastBakarot = 0, lastTikufim = 0, lastKnasot = 0;

  bool history, isMonthHistory;
  UserData userData;
  HistoryData dayHistory, monthHistory;
  double bakarotPer, tikufimPer, knasotPer;

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
        width: history ? WIDTH - 80 : WIDTH - 50,
        animation: history ? false : true,
        animateFromLastPercent: true,
        lineHeight: history ? 25.0 : 30.0,
        animationDuration: loadTime,
        percent: per,
        center: Text(
          (per * 100).toStringAsFixed(2) + '%',
          style: history
              ? Theme.of(context).textTheme.headline4
              : Theme.of(context).textTheme.headline3,
        ),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.green,
      ),
    ]);
  }

  Widget countUpAnimation(double start, double end, String prefix,
      String suffix, BuildContext context) {
    if (history) {
      start = end;
    }
    return Countup(
      begin: start,
      maxLines: 1,
      softWrap: false,
      prefix: prefix,
      suffix: suffix,
      end: end,
      duration: Duration(seconds: loadTime ~/ 1000),
      separator: ',',
      style: history
          ? Theme.of(context).textTheme.headline3.copyWith(fontSize: 24)
          : Theme.of(context).textTheme.headline1,
    );
  }

  void updateLastData() {
    lastBakarot = monthlyBakarot;
    lastTikufim = monthlyTikufim;
    lastKnasot = monthlyKnasot;
  }

  Widget buildDataTile(IconData icon, String data, int start, int current,
      int goal, int added, double per, BuildContext context) {
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
                  size: history ? 20 : 30,
                  color: Theme.of(context).accentColor,
                ),
              ),
              trailing: history && added != 0 && added != null
                  ? Container(
                      width: 40,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          added.toString() + '+',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(color: Colors.green),
                        ),
                      ),
                    )
                  : Text(''),
              title: countUpAnimation(
                start.toDouble(),
                current.toDouble(),
                '$data ',
                '/${goal}',
                context,
              ),
              subtitle: Text(
                'נותרו: ${left}',
                style:
                    history ? TextStyle(fontSize: 18) : TextStyle(fontSize: 24),
              )),
          _progressBar(per, context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => updateLastData());

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
    bakarotPer = bakarotGoal != 0 ? monthlyBakarot / bakarotGoal : 0;
    tikufimPer = tikufimGoal != 0 ? monthlyTikufim / tikufimGoal : 0;
    knasotPer = knasotGoal != 0 ? monthlyKnasot / knasotGoal : 0;
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
        buildDataTile(Icons.directions_bus, 'בקרות:', lastBakarot,
            monthlyBakarot, bakarotGoal, bakarotAdded, bakarotPer, context),
        buildDataTile(Icons.confirmation_num_rounded, 'תיקופים:', lastTikufim,
            monthlyTikufim, tikufimGoal, tikufimAdded, tikufimPer, context),
        buildDataTile(Icons.my_location, 'קנסות:', lastKnasot, monthlyKnasot,
            knasotGoal, knasotAdded, knasotPer, context),
      ],
    );
  }
}
