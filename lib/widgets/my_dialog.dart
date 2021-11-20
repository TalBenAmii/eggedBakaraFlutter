import 'dart:ui';

import 'package:egged_bakara/models/my_flush_bar.dart';
import 'package:flutter/material.dart';

class BlurryDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: new Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontWeight: FontWeight.bold),
          ),
          content: new Text(
            content,
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              child: Text(
                "בטל",
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Color.fromRGBO(2, 122, 255, 1),
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "אפס",
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Color.fromRGBO(255, 59, 48, 1),
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                MyFlushBar('ההישגים אופסו בהצלחה!', Colors.red, Icons.delete,
                        context)
                    .buildFlushBar();
                continueCallBack();
              },
            ),
          ],
        ));
  }
}
