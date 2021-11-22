import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stats extends StatefulWidget {
  Stats({Key key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool friday = false, saturday = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    friday = prefs.getBool("friday") ?? false;
    saturday = prefs.getBool("saturday") ?? false;
  }

  void _updateData(bool value, bool isFriday) async {
    setState(() {
      if (isFriday) {
        friday = value;
      } else {
        saturday = value;
      }
    });
    saveData();
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("friday", friday);
    prefs.setBool("saturday", saturday);
  }

  Widget buildStatsText(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '• $text',
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }

  Column buildColumn(String text, double bakarot, double tikufim, double knasot,
      BuildContext context) {
    List<Widget> data = [];
    data.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
    List<String> words = [
      'בקרות: ${bakarot.toStringAsFixed(2)}',
      'תיקופים: ${tikufim.toStringAsFixed(2)}',
      'קנסות: ${knasot.toStringAsFixed(2)}'
    ];
    for (int i = 0; i < 3; i++) {
      data.add(buildStatsText(words[i], context));
    }
    data.add(
      Padding(
        padding: EdgeInsets.only(right: WIDTH * 0.3),
        child: Text(
          'ליום',
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data,
    );
  }

  Widget buildStats(
      BuildContext context,
      double bakarotDarush,
      double tikufimDarush,
      double knasotDarush,
      double bakarotYesh,
      double tikufimYesh,
      double knasotYesh) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFDEFFD3),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildColumn('קצב דרוש', bakarotDarush, tikufimDarush, knasotDarush,
                context),
            Container(
                height: 120,
                child: VerticalDivider(
                  thickness: 3,
                )),
            buildColumn(
                'קצב נוכחי', bakarotYesh, tikufimYesh, knasotYesh, context)
          ],
        ),
      ),
    );
  }

  Widget buildDaysLeft(BuildContext context, int daysLeft) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'נותרו ',
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontSize: 30, fontWeight: FontWeight.w400)),
        TextSpan(
            text: daysLeft.toString(),
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontSize: 30, fontWeight: FontWeight.bold)),
        TextSpan(
            text: ' ימים לסוף החודש',
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontSize: 30, fontWeight: FontWeight.w400))
      ])),
    );
  }

  Widget buildCheckBox(String text, bool isFriday) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.headline3,
        ),
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            checkColor: Theme.of(context).accentColor,
            activeColor: Colors.white,
            value: isFriday ? friday : saturday,
            onChanged: (bool value) {
              _updateData(value, isFriday);
            },
          ),
        ),
      ],
    );
  }

  Widget buildCheckBoxes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCheckBox('עובד בשישי?', true),
          buildCheckBox('עובד בשבת?', false),
        ],
      ),
    );
  }

  int getWorkingDays(DateTime from, DateTime to, bool friday, bool satuarday) {
    int days = 0, daysFrom = from.day, daysTo = to.day;
    for (int i = daysFrom; i < daysTo; i++) {
      if ((DateTime(DateTime.now().year, DateTime.now().month, i).weekday !=
                  DateTime.friday ||
              friday) &&
          (DateTime(DateTime.now().year, DateTime.now().month, i).weekday !=
                  DateTime.saturday ||
              saturday)) days++;
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    int daysLeft = getWorkingDays(
            DateTime.now(),
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
            friday,
            saturday) +
        1;
    final bakarotLeft = _userData.bakarotGoal - _userData.monthlyBakarot < 0
        ? 0
        : _userData.bakarotGoal - _userData.monthlyBakarot;
    final tikufimLeft = _userData.tikufimGoal - _userData.monthlyTikufim < 0
        ? 0
        : _userData.tikufimGoal - _userData.monthlyTikufim;
    final knasotLeft = _userData.knasotGoal - _userData.monthlyKnasot < 0
        ? 0
        : _userData.knasotGoal - _userData.monthlyKnasot;
    final bakarotDarush = bakarotLeft / daysLeft;
    final tikufimDarush = tikufimLeft / daysLeft;
    final knasotDarush = knasotLeft / daysLeft;
    final bakarotYesh = _userData.monthlyBakarot / DateTime.now().day;
    final tikufimYesh = _userData.monthlyTikufim / DateTime.now().day;
    final knasotYesh = _userData.monthlyKnasot / DateTime.now().day;
    return Column(
      children: [
        buildDaysLeft(context, daysLeft),
        SizedBox(
          height: 7,
        ),
        buildStats(context, bakarotDarush, tikufimDarush, knasotDarush,
            bakarotYesh, tikufimYesh, knasotYesh),
        buildCheckBoxes(),
      ],
    );
  }
}
