import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/widgets/calender_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  UserData userData;
  bool _daysSectionexpanded = false, _monthSectionexpanded = false;

  @override
  void initState() {
    userData = Provider.of<UserData>(context, listen: false);
    super.initState();
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
      history: userData.history,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
      onDateSelected: (date) {
        int monthlyBakarot = 0, monthlyTikufim = 0, monthlyKnasot = 0;

        if (monthGoal) {
          if (userData.history[DateFormat.yMMMd()
                  .format(DateTime(date.year, date.month, 1))] !=
              null) {
            monthlyBakarot = userData.history[DateFormat.yMMMd()
                .format(DateTime(date.year, date.month, 1))]['monthlyBakarot'];
            monthlyTikufim = userData.history[DateFormat.yMMMd()
                .format(DateTime(date.year, date.month, 1))]['monthlyTikufim'];
            monthlyKnasot = userData.history[DateFormat.yMMMd()
                .format(DateTime(date.year, date.month, 1))]['monthlyKnasot'];
          }
          _showData(monthlyBakarot, monthlyTikufim, monthlyKnasot,
              monthsName[date.month - 1], true);
        } else {
          if (userData.history[DateFormat.yMd().format(date)] != null) {
            monthlyBakarot = userData.history[DateFormat.yMd().format(date)]
                ['monthlyBakarot'];
            monthlyTikufim = userData.history[DateFormat.yMd().format(date)]
                ['monthlyTikufim'];
            monthlyKnasot = userData.history[DateFormat.yMd().format(date)]
                ['monthlyKnasot'];
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

  Widget _generateMonthCalender() {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: buildCalender(true),
    );
  }

  Widget _generateDayCalender() {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: buildCalender(false),
    );
  }

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

  Widget build(BuildContext context) {
    return Column(
      children: [
        (HistorySection(_generateMonthCalender, 'היסטורית חודשים', 50)),
        HistorySection(_generateDayCalender, 'היסטורית ימים', 120)
      ],
    );
  }
}

class HistorySection extends StatefulWidget {
  const HistorySection(this.historySection, this.text, this.height, {Key key})
      : super(key: key);
  final Function historySection;
  final String text;
  final double height;
  @override
  _HistorySectionState createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: Text(
          widget.text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
          onPressed: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
        ),
      ),
      if (_expanded)
        Container(
            height: widget.height,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: widget.historySection())
    ]);
  }
}
