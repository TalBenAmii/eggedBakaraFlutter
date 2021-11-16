import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  BottomButton(this._openOptions, {Key key}) : super(key: key);
  final Function _openOptions;
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
