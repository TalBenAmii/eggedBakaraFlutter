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

class _HistoryState extends State<History> with TickerProviderStateMixin {
  UserData userData;
  bool dayExpanded = false, monthExpanded = false;
  AnimationController _monthController, _dayContoller;

  @override
  void initState() {
    _monthController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _dayContoller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
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
                          '$append בקרות: ' + monthlyBakarot.toString(),
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

  void expandUnexpand(bool monthCalender) {
    setState(() {
      if (monthCalender) {
        monthExpanded = !monthExpanded;
        if (dayExpanded && monthExpanded) {
          dayExpanded = !dayExpanded;
          _dayContoller.reverse();
        }
        if (monthExpanded)
          _monthController.forward();
        else {
          _monthController.reverse();
        }
        ;
      } else {
        dayExpanded = !dayExpanded;
        if (dayExpanded && monthExpanded) {
          monthExpanded = !monthExpanded;
          _monthController.reverse();
        }
        if (dayExpanded)
          _dayContoller.forward();
        else {
          _dayContoller.reverse();
        }
      }
    });
  }

  Widget build(BuildContext context) {
    final _monthCalender = HistorySection(_generateMonthCalender,
        'היסטורית חודשים', 50, expandUnexpand, monthExpanded, _monthController);
    final _dayCalender = HistorySection(_generateDayCalender, 'היסטורית ימים',
        115, expandUnexpand, dayExpanded, _dayContoller);

    return Column(children: [_monthCalender, _dayCalender]);
  }
}

class HistorySection extends StatelessWidget {
  HistorySection(this.historySection, this.text, this.height,
      this.expandedUnexpended, this.expanded, this.controller,
      {Key key})
      : super(key: key);
  final Function historySection;
  final String text;
  final double height;
  final Function expandedUnexpended;
  final bool expanded;
  final controller;
  Animation<double> _opacityAnimation;

  @override
  Widget build(BuildContext context) {
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade800.withAlpha(170)),
            borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          splashColor: Colors.green,
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (text == 'היסטורית חודשים')
              expandedUnexpended(true);
            else {
              expandedUnexpended(false);
            }
          },
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.headline2,
            ),
            trailing: IconButton(
              color: Colors.green.shade800,
              iconSize: 40,
              splashColor: Colors.green,
              splashRadius: 25,
              icon:
                  expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                if (text == 'היסטורית חודשים')
                  expandedUnexpended(true);
                else {
                  expandedUnexpended(false);
                }
              },
            ),
          ),
        ),
      ),
      AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: expanded ? height : 0,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: FadeTransition(
              opacity: _opacityAnimation, child: historySection())),
    ]);
  }
}
