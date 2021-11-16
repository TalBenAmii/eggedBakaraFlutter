import 'package:date_util/date_util.dart';
import 'package:egged_bakara/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Stats extends StatelessWidget {
  const Stats({Key key}) : super(key: key);

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
              .headline2
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
        padding: const EdgeInsets.only(right: 130),
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

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context, listen: false);

    final dateUtility = DateUtil();

    int daysLeft =
        dateUtility.daysInMonth(DateTime.now().month, DateTime.now().year) -
            DateTime.now().day +
            1;
    final bakarotDarush =
        (_userData.bakarotGoal - _userData.monthlyBakarot) / daysLeft;
    final tikufimDarush =
        (_userData.tikufimGoal - _userData.monthlyTikufim) / daysLeft;
    final knasotDarush =
        (_userData.knasotGoal - _userData.monthlyKnasot) / daysLeft;
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
      ],
    );
  }
}
