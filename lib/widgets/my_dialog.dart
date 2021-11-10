import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback continueCallBack;
  final TextStyle textStyle = TextStyle(color: Colors.black);

  BlurryDialog(this.title, this.content, this.continueCallBack);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: new Text(
            title,
            style: textStyle,
          ),
          content: new Text(
            content,
            style: textStyle,
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              child: Text(
                "בטל",
                style: Theme.of(context).textTheme.headline2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "אשר",
                style: Theme.of(context).textTheme.headline2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                continueCallBack();
              },
            ),
          ],
        ));
  }
}
