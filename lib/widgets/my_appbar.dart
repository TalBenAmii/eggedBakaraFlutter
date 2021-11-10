import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final _mediaQuery;

  const MyAppBar(this._mediaQuery, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
          width: _mediaQuery.size.width,
          child: Text(
            'אגד בקרה',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
