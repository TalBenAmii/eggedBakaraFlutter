import 'dart:convert';

import 'package:date_util/date_util.dart';
import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/widgets/add_data.dart';
import 'package:egged_bakara/widgets/data.dart';
import 'package:egged_bakara/widgets/my_dialog.dart';
import 'package:egged_bakara/widgets/options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataScreen extends StatefulWidget {
  DataScreen({Key key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen>
    with SingleTickerProviderStateMixin {
  static const _PANEL_HEADER_HEIGHT = 410.0;
  UserData _userData = UserData();
  AnimationController _controller;
  double width, height;
  var dateUtility;
  int daysLeft = 0;
  double bakarotDarush = 0,
      tikufimDarush = 0,
      knasotDarush = 0,
      bakarotYesh = 0,
      tikufimYesh = 0,
      knasotYesh = 0;

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    _loadData();
    dateUtility = DateUtil();
    daysLeft =
        dateUtility.daysInMonth(DateTime.now().month, DateTime.now().year) -
            DateTime.now().day +
            1;

    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  Widget buildTextBox(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline3
            .copyWith(fontWeight: FontWeight.w300),
      ),
    );
  }

  Card buildCard() {
    return Card(
      color: Color(0xFFDEFFD3),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildColumn('קצב דרוש', bakarotDarush, tikufimDarush, knasotDarush),
            Container(
                height: 120,
                child: VerticalDivider(
                  thickness: 3,
                )),
            buildColumn('קצב נוכחי', bakarotYesh, tikufimYesh, knasotYesh)
          ],
        ),
      ),
    );
  }

  Column buildColumn(
      String text, double bakarot, double tikufim, double knasot) {
    List<Widget> data = [];
    data.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline3.copyWith(
                decoration: TextDecoration.underline,
                fontSize: 30,
              ),
        ),
      ),
    );
    List<String> words = [
      'בקרות: ${bakarot.toStringAsFixed(2)}',
      'תיקופים: ${tikufim.toStringAsFixed(2)}',
      'קנסות: ${knasot.toStringAsFixed(2)}'
    ];
    for (int i = 0; i < 3; i++) {
      data.add(buildTextBox(words[i]));
    }
    data.add(
      Padding(
        padding: const EdgeInsets.only(right: 130),
        child: Text(
          'ליום',
          style: Theme.of(context).textTheme.headline3.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data,
    );
  }

  List<Widget> buildData() {
    List<Widget> data = [];
    data.add(
      Padding(
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
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 30)),
          TextSpan(
              text: ' ימים לסוף החודש',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(fontSize: 30, fontWeight: FontWeight.w400))
        ])),
      ),
    );
    data.add(SizedBox(
      height: 7,
    ));
    data.add(buildCard());

    return data;
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      width: width,
      child: Stack(
        children: <Widget>[
          Column(
            children: buildData(),
          ),
          PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0)),
              elevation: 12.0,
              child: Column(children: <Widget>[
                Expanded(
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Data(_userData),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            shadowColor: Colors.greenAccent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15))),
                            minimumSize: Size(1, 40), //////// HERE
                          ),
                          onPressed: () {
                            _openOptions(context);
                          },
                          child: Icon(
                            Icons.arrow_drop_up_rounded,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _openOptions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Options(_openAddTransaction, _showDialog);
        });
  }

  void _openAddTransaction(BuildContext ctx, bool addGoal) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return AddData(_userData, addGoal, _updateData);
        });
  }

  void _updateData() async {
    setState(() {});
    _userData.saveData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(_userData.history);
    String data = jsonEncode(_userData.data);
    prefs.setString("history", json);
    prefs.setString("data", data);
  }

  void _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> history = jsonDecode(prefs.getString("history"));
      Map<String, dynamic> data = jsonDecode(prefs.getString("data"));
      _userData = UserData.fromJson(history, data);
      setState(() {});
    } catch (exception) {}
  }

  void _showDialog(BuildContext context) {
    VoidCallback continueCallBack = () {
      _userData.reset();
      _updateData();
    };
    BlurryDialog alert = BlurryDialog("איפוס נתונים",
        "האם אתה בטוח שברצונך לאפס את הנתונים שלך?", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bakarotDarush =
        (_userData.bakarotGoal - _userData.monthlyBakarot) / daysLeft;
    tikufimDarush =
        (_userData.tikufimGoal - _userData.monthlyTikufim) / daysLeft;
    knasotDarush = (_userData.knasotGoal - _userData.monthlyKnasot) / daysLeft;
    bakarotYesh = _userData.monthlyBakarot / DateTime.now().day;
    tikufimYesh = _userData.monthlyTikufim / DateTime.now().day;
    knasotYesh = _userData.monthlyKnasot / DateTime.now().day;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("אגד בקרה"),
        leading: IconButton(
          onPressed: () {
            _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller.view,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
