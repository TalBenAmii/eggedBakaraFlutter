import 'dart:async';

import 'package:egged_bakara/icons/no_history.dart';
import 'package:egged_bakara/models/history_data.dart';
import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:egged_bakara/widgets/calender_timeline.dart';
import 'package:egged_bakara/widgets/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

bool canBePressed = true;

class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with TickerProviderStateMixin {
  UserData _userData;
  bool dayExpanded = false, monthExpanded = false;
  AnimationController _monthController, _dayContoller;
  var _monthCalender, _dayCalender;
  bool init = true;
  @override
  void initState() {
    _loadData();

    _monthController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 250,
      ),
    );
    _dayContoller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 250,
      ),
    );

    super.initState();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dayExpanded = prefs.getBool("dayExpanded") ?? false;
    monthExpanded = prefs.getBool("monthExpanded") ?? false;
    if (dayExpanded) {
      dayExpanded = !dayExpanded;
      expandUnexpand(false);
    }
    if (monthExpanded) {
      monthExpanded = !monthExpanded;
      expandUnexpand(true);
    }
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("dayExpanded", dayExpanded);
    prefs.setBool("monthExpanded", monthExpanded);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayContoller.dispose();
    super.dispose();
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
      history: _userData.history,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
      onDateSelected: (date) {
        if (monthGoal) {
          _showData(
              _userData.history[DateFormat.yMMMd()
                  .format(DateTime(date.year, date.month, 1))],
              _userData.history[DateFormat.yMd().format(date)],
              monthsName[date.month - 1],
              true);
        } else {
          _showData(
              _userData.history[DateFormat.yMMMd()
                  .format(DateTime(date.year, date.month, 1))],
              _userData.history[DateFormat.yMd().format(date)],
              DateFormat('dd/MM/yyyy').format(date),
              false);
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

  void _showData(HistoryData monthHistory, HistoryData dayHistory,
      String chosen, bool isMonthHistory) {
    bool isHistory = true;
    if (dayHistory == null && !isMonthHistory ||
        (isMonthHistory && monthHistory == null)) {
      isHistory = false;
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xFFD1FFBD),
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5,
                          color: Colors.green.shade800.withAlpha(170)),
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                  child: ListTile(
                    dense: true,
                    title: Center(
                      child: Text(
                        chosen,
                        style: Theme.of(ctx)
                            .textTheme
                            .headline1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: Icon(
                      Icons.history,
                      color: Colors.transparent,
                      size: 30,
                    ),
                    leading: Icon(
                      Icons.history_rounded,
                      size: 30,
                      color: Theme.of(ctx).accentColor,
                    ),
                  ),
                ),
                if (!isHistory)
                  Container(
                    height: 300,
                    child: Center(
                      child: Icon(NoHistory.no_history,
                          size: 150, color: Colors.black),
                    ),
                  ),
                if (isHistory)
                  Data(
                    history: true,
                    monthHistory: monthHistory,
                    dayHistory: dayHistory,
                    isMonthHistory: isMonthHistory,
                  ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          );
        });
  }

  void toggle(AnimationController controller, bool expanded) {
    if (expanded) {
      controller.reverse();
    } else {
      Future.delayed(const Duration(milliseconds: 250), () {
        controller.forward();
      });
    }
  }

  Future<void> expandUnexpand(bool monthCalender) async {
    if (monthCalender) {
      if (!monthExpanded && dayExpanded) {
        Future.delayed(const Duration(milliseconds: 250), () {
          toggle(_monthController, monthExpanded);
          setState(() {
            monthExpanded = !monthExpanded;
          });
        });

        toggle(_dayContoller, dayExpanded);
        Future.delayed(const Duration(milliseconds: 250), () {
          setState(() {
            dayExpanded = !dayExpanded;
          });
        });
      } else if (monthExpanded) {
        toggle(_monthController, monthExpanded);
        Future.delayed(const Duration(milliseconds: 250), () {
          setState(() {
            monthExpanded = !monthExpanded;
          });
        });
      } else {
        toggle(_monthController, monthExpanded);
        setState(() {
          monthExpanded = !monthExpanded;
        });
      }
    } else {
      if (!dayExpanded && monthExpanded) {
        Future.delayed(const Duration(milliseconds: 250), () {
          toggle(_dayContoller, dayExpanded);
          setState(() {
            dayExpanded = !dayExpanded;
          });
        });
        toggle(_monthController, monthExpanded);
        Future.delayed(const Duration(milliseconds: 250), () {
          setState(() {
            monthExpanded = !monthExpanded;
          });
        });
      } else if (dayExpanded) {
        toggle(_dayContoller, dayExpanded);
        Future.delayed(const Duration(milliseconds: 250), () {
          setState(() {
            dayExpanded = !dayExpanded;
          });
        });
      } else {
        toggle(_dayContoller, dayExpanded);
        setState(() {
          dayExpanded = !dayExpanded;
        });
      }
    }
    saveData();
  }

  void toggleCanBePressed() {
    setState(() {});
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        canBePressed = true;
      });
    });
  }

  Widget build(BuildContext context) {
    Provider.of<UserData>(context).addListener(() {
      _monthCalender = _generateMonthCalender();
      _dayCalender = _generateDayCalender();
    });
    if (init) {
      init = false;
      _userData = Provider.of<UserData>(context);
      _monthCalender = _generateMonthCalender();
      _dayCalender = _generateDayCalender();
      return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              HistorySection(
                  _monthCalender,
                  'היסטורית חודשים',
                  expandUnexpand,
                  HEIGHT * 0.055,
                  monthExpanded,
                  _monthController,
                  toggleCanBePressed),
              HistorySection(
                  _dayCalender,
                  'היסטורית ימים',
                  expandUnexpand,
                  HEIGHT * 0.156,
                  dayExpanded,
                  _dayContoller,
                  toggleCanBePressed)
            ]);
          }
          return CircularProgressIndicator();
        },
      );
    } else {
      return Column(children: [
        HistorySection(
            _monthCalender,
            'היסטורית חודשים',
            expandUnexpand,
            HEIGHT * 0.055,
            monthExpanded,
            _monthController,
            toggleCanBePressed),
        HistorySection(_dayCalender, 'היסטורית ימים', expandUnexpand,
            HEIGHT * 0.156, dayExpanded, _dayContoller, toggleCanBePressed)
      ]);
    }
  }
}

class HistorySection extends StatelessWidget {
  HistorySection(this.calender, this.text, this.expandedUnexpended, this.height,
      this.expanded, this.controller, this.toggleCanBePressed,
      {Key key})
      : super(key: key);
  final calender;
  final String text;
  final Function expandedUnexpended;
  final bool expanded;
  final double height;
  final controller;
  final Function toggleCanBePressed;

  @override
  Widget build(BuildContext context) {
    Animation<double> _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
    return Column(children: [
      Container(
        margin: EdgeInsets.only(
            top: HEIGHT * 0.02, left: WIDTH * 0.025, right: WIDTH * 0.025),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.green.shade800.withAlpha(170), width: 1.5),
            borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          splashColor: Colors.green,
          borderRadius: BorderRadius.circular(20),
          onTap: canBePressed
              ? () {
                  canBePressed = false;
                  toggleCanBePressed();
                  if (text == 'היסטורית חודשים')
                    expandedUnexpended(true);
                  else {
                    expandedUnexpended(false);
                  }
                }
              : null,
          child: ListTile(
            leading: Icon(
              Icons.history,
              size: 35,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              text,
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 25),
            ),
            trailing: IconButton(
              color: Colors.green.shade800,
              iconSize: 40,
              splashColor: Colors.green,
              splashRadius: 25,
              icon:
                  expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: canBePressed
                  ? () {
                      canBePressed = false;
                      toggleCanBePressed();
                      if (text == 'היסטורית חודשים')
                        expandedUnexpended(true);
                      else {
                        expandedUnexpended(false);
                      }
                    }
                  : null,
            ),
          ),
        ),
      ),
      SizedBox(
        height: HEIGHT * 0.01,
      ),
      AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: expanded ? height : 0,
          child: FadeTransition(opacity: _opacityAnimation, child: calender))
    ]);
  }
}
