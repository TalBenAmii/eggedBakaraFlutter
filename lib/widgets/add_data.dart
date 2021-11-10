import 'package:flutter/material.dart';
import '../models/user_data.dart';

class AddData extends StatefulWidget {
  final UserData userData;
  final bool addGoal;
  final Function updateData;

  AddData(this.userData, this.addGoal,this.updateData);

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
        monthlyKnasot.text.isEmpty) return;

    final int bakarotTransf = int.parse(monthlyBakarot.text);
    final int tikufimTransf = int.parse(monthlyTikufim.text);
    final int knasotTransf = int.parse(monthlyKnasot.text);
    if (bakarotTransf < 0 ||
        tikufimTransf < 0 ||
        knasotTransf < 0) return;

    if (widget.addGoal) {
      widget.userData.addGoal(bakarotTransf, tikufimTransf, knasotTransf);
    } else {
      widget.userData.add(bakarotTransf, tikufimTransf, knasotTransf);
    }
    widget.updateData();
    Navigator.of(context).pop();
  }

  Widget _textField(String text, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
          hintText: text,
          hintTextDirection: TextDirection.rtl,
          border: OutlineInputBorder()),
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
                height: mediaQuery.size.height * 0.01,
              ),
              _textField('תיקופים', monthlyTikufim),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              _textField('קנסות', monthlyKnasot),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: _submit,
                child: Text(
                  'בצע',
                  style: Theme.of(context).textTheme.headline6,
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
