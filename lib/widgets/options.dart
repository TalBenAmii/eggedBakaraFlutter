import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  final Function _openAddTransaction, _showDialog;

  const Options(this._openAddTransaction, this._showDialog, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                _openAddTransaction(context, false);
              },
              title: new Text(
                "הוסף הישג יומי",
                style: Theme.of(context).textTheme.headline4,
              ),
              leading: new Icon(
                Icons.add,
                color: Colors.black,
              ),
              tileColor: Theme.of(context).accentColor.withOpacity(0.5),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                _openAddTransaction(context, true);
              },
              title: new Text(
                "הוסף מטרה חודשית",
                style: Theme.of(context).textTheme.headline4,
              ),
              leading: new Icon(
                Icons.flag,
                color: Colors.black,
              ),
              tileColor: Colors.amberAccent.withOpacity(0.5),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                _showDialog(context);
              },
              title: new Text(
                "מחק את ההישגים",
                style: Theme.of(context).textTheme.headline4,
              ),
              leading: new Icon(
                Icons.delete,
                color: Colors.black,
              ),
              tileColor: Theme.of(context).errorColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
    );
  }
}
