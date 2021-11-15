import 'dart:async';
import 'dart:ui' as ui;

import 'package:countup/countup.dart';
import 'package:egged_bakara/widgets/calender_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/user_data.dart';

class Data extends StatefulWidget {
  final UserData userData;

  Data(this.userData);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  bool init = true;
  bool initLoadData = true;
  bool initDay = true;
  int loadTime = 1500;
  bool animate;

  void _showData(int monthlyBakarot, int monthlyTikufim, int monthlyKnasot,
      String chosen, bool monthGoal) {
    bool isHistory = true;
    String append = monthGoal ? 'סה"כ' : '';
    if (monthlyBakarot == 0 && monthlyTikufim == 0 && monthlyKnasot == 0) {
      isHistory = false;
    }
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: isHistory == false
                    ? [
                        Text(
                          chosen + ':',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 50,
                              decoration: TextDecoration.underline),
                        ),
                        Text('אין הסטוריה',
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontSize: 45,
                                    ))
                      ]
                    : [
                        Text(
                          chosen + ':',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 50,
                              decoration: TextDecoration.underline),
                        ),
                        Text(
                          '$append ביקורים: ' + monthlyBakarot.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 35),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '$append תיקופים: ' + monthlyTikufim.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 35),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '$append קנסות: ' + monthlyKnasot.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 35),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
              ),
            ),
          );
        });
  }

  Widget buildCalender(bool monthGoal) {
    List<String> monthsName = [
      'ינואר',
      'פברואר',
      'מרץ',
      'אפריל',
      'מאי',
      'יוני',
      'יולי',
      'אוגוסט',
      'ספטמבר',
      'אוקטובר',
      'נובמבר',
      'דצמבר'
    ];
    return CalendarTimeline(
      monthGoal: monthGoal,
      history: widget.userData.history,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
      onDateSelected: (date) {
        int monthlyBakarot = 0, monthlyTikufim = 0, monthlyKnasot = 0;

        if (monthGoal) {
          if (widget.userData.history[DateFormat.yMMMd()
                  .format(DateTime(date.year, date.month, 1))] !=
              null) {
            monthlyBakarot = widget.userData.history[DateFormat.yMMMd()
                .format(DateTime(date.year, date.month, 1))]['monthlyBakarot'];
            monthlyTikufim = widget.userData.history[DateFormat.yMMMd()
                .format(DateTime(date.year, date.month, 1))]['monthlyTikufim'];
            monthlyKnasot = widget.userData.history[DateFormat.yMMMd()
                .format(DateTime(date.year, date.month, 1))]['monthlyKnasot'];
          }
          _showData(monthlyBakarot, monthlyTikufim, monthlyKnasot,
              monthsName[date.month - 1], true);
        } else {
          if (widget.userData.history[DateFormat.yMd().format(date)] != null) {
            monthlyBakarot = widget.userData
                .history[DateFormat.yMd().format(date)]['monthlyBakarot'];
            monthlyTikufim = widget.userData
                .history[DateFormat.yMd().format(date)]['monthlyTikufim'];
            monthlyKnasot = widget.userData
                .history[DateFormat.yMd().format(date)]['monthlyKnasot'];
          }
          _showData(monthlyBakarot, monthlyTikufim, monthlyKnasot,
              DateFormat('dd/MM/yyyy').format(date), false);
        }
      },
      leftMargin: 20,
      monthColor: Colors.green.shade700,
      dayColor: Colors.green,
      dayNameColor: Color(0xFF333A47),
      activeDayColor: Colors.white,
      activeBackgroundDayColor: Colors.redAccent[200],
      dotsColor: Color(0xFF333A47),
      locale: 'en_ISO',
    );
  }

  Widget _generateRow() {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: buildCalender(true),
    );
  }

  Widget _showDatePicker(MediaQueryData mediaQuery) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: buildCalender(false),
    );
  }

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

    double bakarotPer = widget.userData.bakarotGoal != 0
        ? widget.userData.monthlyBakarot / widget.userData.bakarotGoal
        : 0;
    double tikufimPer = widget.userData.tikufimGoal != 0
        ? widget.userData.monthlyTikufim / widget.userData.tikufimGoal
        : 0;
    double knasotPer = widget.userData.knasotGoal != 0
        ? widget.userData.monthlyKnasot / widget.userData.knasotGoal
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
            title: countUpAnimation(widget.userData.monthlyBakarot.toDouble(),
                'בקרות: ', '/${widget.userData.bakarotGoal}'),
            subtitle: Text(
              'נותרו: ${widget.userData.bakarotGoal - widget.userData.monthlyBakarot}',
              style: TextStyle(fontSize: 20),
            )),
        _progressBar(mediaQuery, bakarotPer),
        ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.confirmation_num),
            ),
            title: countUpAnimation(widget.userData.monthlyTikufim.toDouble(),
                'בקרות: ', '/${widget.userData.tikufimGoal}'),
            subtitle: Text(
              'נותרו: ${widget.userData.tikufimGoal - widget.userData.monthlyTikufim}',
              style: TextStyle(fontSize: 20),
            )),
        _progressBar(mediaQuery, tikufimPer),
        ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.my_location),
            ),
            title: countUpAnimation(widget.userData.monthlyKnasot.toDouble(),
                'בקרות: ', '/${widget.userData.knasotGoal}'),
            subtitle: Text(
              'נותרו: ${widget.userData.knasotGoal - widget.userData.monthlyKnasot}',
              style: TextStyle(fontSize: 20),
            )),
        _progressBar(mediaQuery, knasotPer),
        Text('הישגים חודשיים',
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(decoration: TextDecoration.underline, fontSize: 30)),
        _generateRow(),
        Text('הישגים יומיים',
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(decoration: TextDecoration.underline, fontSize: 30)),
        _showDatePicker(mediaQuery),
      ],
    );
  }
}
