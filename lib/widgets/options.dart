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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Color(0xFFD1FFBD),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onTap: () {
                Navigator.of(context).pop();
                _openAddTransaction(context, false);
              },
              title: Text(
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
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Color(0xFFD1FFBD),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onTap: () {
                Navigator.of(context).pop();
                _openAddTransaction(context, true);
              },
              title: Text(
                "הוסף מטרה חודשית",
                style: Theme.of(context).textTheme.headline4,
              ),
              leading: Icon(
                Icons.flag,
                color: Colors.black,
              ),
              tileColor: Colors.amberAccent.withOpacity(0.5),
            ),
          ),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Color(0xFFD1FFBD),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onTap: () {
                Navigator.of(context).pop();
                _showDialog(context);
              },
              title: Text(
                "מחק את ההישגים",
                style: Theme.of(context).textTheme.headline4,
              ),
              leading: Icon(
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
