import 'dart:ui' as ui;

import 'package:egged_bakara/widgets/calender_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    1,
    1,
  );

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  void _showData(int monthlyBakarot, int monthlyTikufim, int monthlyKnasot,
      String chosen) {
    bool isHistory = true;

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
                        Text(
                          'אין הסטוריה',
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ]
                    : [
                        Text(
                          chosen + ':',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 50,
                              decoration: TextDecoration.underline),
                        ),
                        Text(
                          'בקרות: ' + monthlyBakarot.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'תיקופים: ' + monthlyTikufim.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'קנסות: ' + monthlyKnasot.toString(),
                          style: Theme.of(context).textTheme.headline4,
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

  Widget _generateRow() {
    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: generateRowOfMonths(1, 12),
      ),
    );
  }

  List<Widget> generateRowOfMonths(from, to) {
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

    List<Widget> months = [
      SizedBox(
        width: 10,
      )
    ];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(DateTime.now().year, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Colors.redAccent[200]
          : Colors.transparent;
      final textColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Colors.white
          : Theme.of(context).primaryColor;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              setState(() {
                _selectedMonth = dateTime;
                int monthlyBakarot = 0, monthlyTikufim = 0, monthlyKnasot = 0;
                if (widget.userData.history[DateFormat.yMMMd().format(DateTime(
                        _selectedMonth.year, _selectedMonth.month, 1))] !=
                    null) {
                  monthlyBakarot = widget.userData.history[DateFormat.yMMMd()
                          .format(DateTime(
                              _selectedMonth.year, _selectedMonth.month, 1))]
                      ['monthlyBakarot'];
                  monthlyTikufim = widget.userData.history[DateFormat.yMMMd()
                          .format(DateTime(
                              _selectedMonth.year, _selectedMonth.month, 1))]
                      ['monthlyTikufim'];
                  monthlyKnasot = widget.userData.history[DateFormat.yMMMd()
                          .format(DateTime(
                              _selectedMonth.year, _selectedMonth.month, 1))]
                      ['monthlyKnasot'];
                }
                _showData(monthlyBakarot, monthlyTikufim, monthlyKnasot,
                    monthsName[dateTime.month - 1]);
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: Text(
              monthsName[i - 1],
              style: TextStyle(fontSize: 26, color: textColor),
            ),
          ),
        ),
      );
    }
    return months.reversed.toList();
  }

  Widget _showDatePicker(MediaQueryData mediaQuery) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: CalendarTimeline(
        showYears: true,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(2021),
        lastDate: DateTime(DateTime.now().year + 1, 1, 0),
        onDateSelected: (date) {
          int monthlyBakarot = 0, monthlyTikufim = 0, monthlyKnasot = 0;
          if (widget.userData.history[DateFormat.yMd().format(date)] != null) {
            monthlyBakarot = widget.userData
                .history[DateFormat.yMd().format(date)]['monthlyBakarot'];
            monthlyTikufim = widget.userData
                .history[DateFormat.yMd().format(date)]['monthlyTikufim'];
            monthlyKnasot = widget.userData
                .history[DateFormat.yMd().format(date)]['monthlyKnasot'];
          }
          _showData(monthlyBakarot, monthlyTikufim, monthlyKnasot,
              DateFormat('dd/MM/yyyy').format(date));
        },
        leftMargin: 20,
        monthColor: Colors.green.shade700,
        dayColor: Theme.of(context).primaryColor,
        dayNameColor: Color(0xFF333A47),
        activeDayColor: Colors.white,
        activeBackgroundDayColor: Colors.redAccent[200],
        dotsColor: Color(0xFF333A47),
        locale: 'en_ISO',
      ),
    );
  }

  Widget _progressBar(MediaQueryData mediaQuery, double per) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      LinearPercentIndicator(
        width: mediaQuery.size.width - 50,
        animation: true,
        lineHeight: 30.0,
        animationDuration: 1500,
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

  Widget _sizedBox(double heightMultiplayer) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      height: mediaQuery.size.height * heightMultiplayer,
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
            title: Text(
              'בקרות: ${widget.userData.monthlyBakarot}/${widget.userData.bakarotGoal}',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              'נותרו: ${widget.userData.bakarotGoal - widget.userData.monthlyBakarot}',
              style: TextStyle(fontSize: 20),
            )),
        _progressBar(mediaQuery, bakarotPer),
        ListTile(
            title: Text(
              'תיקופים: ${widget.userData.monthlyTikufim}/${widget.userData.tikufimGoal}',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              'נותרו: ${widget.userData.tikufimGoal - widget.userData.monthlyTikufim}',
              style: TextStyle(fontSize: 20),
            )),
        _progressBar(mediaQuery, tikufimPer),
        ListTile(
            title: Text(
              'קנסות: ${widget.userData.monthlyKnasot}/${widget.userData.knasotGoal}',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
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
