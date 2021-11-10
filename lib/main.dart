import 'dart:convert';

import 'package:egged_bakara/my_theme.dart';
import 'package:egged_bakara/widgets/my_appbar.dart';
import 'package:egged_bakara/widgets/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_data.dart';
import 'widgets/add_data.dart';
import 'widgets/data.dart';
import 'widgets/my_dialog.dart';
import 'widgets/my_appbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
      title: 'My Expenses',
      home: MyHomePage(),
      theme: MyTheme().theme(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  UserData _userData = UserData();

  @override
  void initState() {
    _loadData();
    super.initState();
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
    try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> history = jsonDecode(prefs.getString("history"));
    Map<String, dynamic> data = jsonDecode(prefs.getString("data"));
    _userData = UserData.fromJson(history, data);
    setState(() {});
    }
    catch(exception){}
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
    final _mediaQuery = MediaQuery.of(context);
    final padding = MediaQuery.of(context).padding;
    SystemChrome.setPreferredOrientations;
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(_mediaQuery),
      body: SingleChildScrollView(
        child: Container(
          height: (_mediaQuery.size.height -
              padding.top -
              AppBar().preferredSize.height),
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
    );
  }
}
