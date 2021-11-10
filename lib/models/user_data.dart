import 'package:date_util/date_util.dart';
import 'package:intl/intl.dart';

class UserData {
  int monthlyBakarot = 0,
      monthlyTikufim = 0,
      monthlyKnasot = 0,
      bakarotGoal = 0,
      tikufimGoal = 0,
      knasotGoal = 0;
  Map<String, Map<String, dynamic>> history = new Map();
  Map<String, dynamic> data = {
    'monthlyBakarot': 0,
    'monthlyTikufim': 0,
    'monthlyKnasot': 0,
    'bakarotGoal': 0,
    'tikufimGoal': 0,
    'knasotGoal': 0
  };

  UserData();

  void add(int monthlyBakarot, int monthlyTikufim, int monthlyKnasot) {
    this.monthlyBakarot += monthlyBakarot;
    this.monthlyTikufim += monthlyTikufim;
    this.monthlyKnasot += monthlyKnasot;
    this.history[DateFormat.yMd().format(DateTime.now())] = {
      'monthlyBakarot': this.monthlyBakarot,
      'monthlyTikufim': this.monthlyTikufim,
      'monthlyKnasot': this.monthlyKnasot
    };
    this.history[DateFormat.yMMMd()
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1))] = {
      'monthlyBakarot': this.monthlyBakarot,
      'monthlyTikufim': this.monthlyTikufim,
      'monthlyKnasot': this.monthlyKnasot
    };
  }

  void addGoal(int bakarotGoal, int tikufimGoal, int knasotGoal) {
    this.bakarotGoal = bakarotGoal;
    this.tikufimGoal = tikufimGoal;
    this.knasotGoal = knasotGoal;
  }

  void reset() {
    var dateUtility = DateUtil();
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    for (int i = 1; i <= dateUtility.daysInMonth(month, year); i++) {
      if (history[DateFormat.yMd().format(DateTime(year, month, i))] != null) {
        history[DateFormat.yMd().format(DateTime(year, month, i))] = {
          'monthlyBakarot': 0,
          'monthlyTikufim': 0,
          'monthlyKnasot': 0
        };
      }
    }

    history[DateFormat.yMMMd()
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1))] = {
      'monthlyBakarot': 0,
      'monthlyTikufim': 0,
      'monthlyKnasot': 0
    };
    monthlyBakarot = 0;
    monthlyTikufim = 0;
    monthlyKnasot = 0;
  }

  void saveData() {
    data['monthlyBakarot'] = monthlyBakarot;
    data['monthlyTikufim'] = monthlyTikufim;
    data['monthlyKnasot'] = monthlyKnasot;
    data['bakarotGoal'] = bakarotGoal;
    data['tikufimGoal'] = tikufimGoal;
    data['knasotGoal'] = knasotGoal;
  }

  UserData.fromJson(Map<String, dynamic> json, Map<String, dynamic> data) {
    json.forEach((key, value) {
      history.putIfAbsent(key, () => value);
    });
    monthlyBakarot = data['monthlyBakarot'];
    monthlyTikufim = data['monthlyTikufim'];
    monthlyKnasot = data['monthlyKnasot'];
    bakarotGoal = data['bakarotGoal'];
    tikufimGoal = data['tikufimGoal'];
    knasotGoal = data['knasotGoal'];
  }
}
