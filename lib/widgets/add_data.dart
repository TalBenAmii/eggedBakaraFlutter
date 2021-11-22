import 'package:egged_bakara/models/my_flush_bar.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';
import 'package:flutter/services.dart';

UserData _userData;

class AddData extends StatefulWidget {
  final bool addGoal;
  final Function updateData;
  AddData(this.addGoal, this.updateData);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final TextEditingController monthlyBakarot = new TextEditingController();

  final TextEditingController monthlyTikufim = new TextEditingController();

  final TextEditingController monthlyKnasot = new TextEditingController();

  void _submit() {
    if (monthlyBakarot.text.isEmpty ||
        monthlyTikufim.text.isEmpty ||
        monthlyKnasot.text.isEmpty) {
      MyFlushBar('אנא מלא את כל השדות', Theme.of(context).errorColor,
              Icons.error, context)
          .buildFlushBar();
      return;
    }
    ;

    final int bakarotTransf = int.parse(monthlyBakarot.text);
    final int tikufimTransf = int.parse(monthlyTikufim.text);
    final int knasotTransf = int.parse(monthlyKnasot.text);
    Navigator.of(context).pop();

    if (widget.addGoal) {
      MyFlushBar('מטרה חודשית נוספה בהצלחה!', Colors.amberAccent, Icons.flag,
              context)
          .buildFlushBar();

      _userData.addGoal(bakarotTransf, tikufimTransf, knasotTransf);
    } else {
      MyFlushBar('הישג יומי נוסף בהצלחה!', Theme.of(context).accentColor,
              Icons.add, context)
          .buildFlushBar();

      _userData.add(bakarotTransf, tikufimTransf, knasotTransf);
    }
    widget.updateData();
  }

  Widget _textField(String text, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
          hintText: text,
          hintStyle: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.grey.shade700),
          hintTextDirection: TextDirection.rtl,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userData = Provider.of<UserData>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 10,
            right: 10,
            left: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _textField('בקרות', monthlyBakarot),
            SizedBox(
              height: HEIGHT * 0.01,
            ),
            _textField('תיקופים', monthlyTikufim),
            SizedBox(
              height: HEIGHT * 0.01,
            ),
            _textField('קנסות', monthlyKnasot),
            SizedBox(
              height: HEIGHT * 0.01,
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              onPressed: () {
                _submit();
              },
              child: Text(
                'בצע',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.white),
              ),
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
