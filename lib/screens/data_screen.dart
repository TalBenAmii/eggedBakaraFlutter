import 'dart:convert';
import 'dart:ui';

import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:egged_bakara/widgets/add_data.dart';
import 'package:egged_bakara/widgets/bottom_button.dart';
import 'package:egged_bakara/widgets/data.dart';
import 'package:egged_bakara/widgets/my_dialog.dart';
import 'package:egged_bakara/widgets/options.dart';
import 'package:egged_bakara/widgets/stats.dart';
import 'package:flutter/material.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataScreen extends StatefulWidget {
  DataScreen({Key key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen>
    with SingleTickerProviderStateMixin {
  double _PANEL_HEADER_HEIGHT;
  UserData _userData;
  AnimationController _controller;
  double width, height;

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    _userData = Provider.of<UserData>(context, listen: false);
    _loadData();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      width: width,
      child: Stack(
        children: <Widget>[
          Stats(),
          PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0)),
              elevation: 12.0,
              child: Column(children: <Widget>[
                Data(),
                Spacer(),
                BottomButton(_openOptions),
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
      _userData.fromJson(history, data);
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
    _PANEL_HEADER_HEIGHT = HEIGHT * 0.55;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("אגד בקרה"),
        actions: [
          AnimatedIconButton(
            size: 30,
            onPressed: () {
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
            },
            duration: const Duration(milliseconds: 500),
            splashRadius: 25,
            splashColor: Colors.green,
            icons: const <AnimatedIconItem>[
              AnimatedIconItem(
                icon: Icon(Icons.assessment_outlined),
              ),
              AnimatedIconItem(
                icon: Icon(Icons.close),
              ),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
