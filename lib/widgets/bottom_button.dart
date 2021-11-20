import 'package:egged_bakara/models/my_flush_bar.dart';
import 'package:egged_bakara/models/user_data.dart';
import 'package:egged_bakara/widgets/my_dialog.dart';
import 'package:egged_bakara/widgets/options.dart';
import 'package:flutter/material.dart';

import 'add_data.dart';

class BottomButton extends StatelessWidget {
  final Function _updateData;
  final UserData _userData;
  BottomButton(this._updateData, this._userData, {Key key}) : super(key: key);

  void _openAddTransaction(BuildContext ctx, bool addGoal) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return AddData(addGoal, _updateData);
        });
  }

  void _openOptions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Options(_openAddTransaction, _showDialog);
        });
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
    return Container(
      alignment: Alignment.center,
      height: 35,
      width: 70,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
          shadowColor: Colors.greenAccent,
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        onPressed: () {
          _openOptions(context);
        },
        child: Icon(
          Icons.arrow_drop_up_rounded,
          size: 40,
        ),
      ),
    );
  }
}
