import 'package:date_util/date_util.dart';
import 'package:egged_bakara/models/history_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserData with ChangeNotifier {
  int monthlyBakarot = 0,
      monthlyTikufim = 0,
      monthlyKnasot = 0,
      bakarotGoal = 0,
      tikufimGoal = 0,
      knasotGoal = 0;
  Map<String, HistoryData> history = new Map();
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
    this.history[DateFormat.yMd().format(DateTime.now())] = HistoryData(
      monthlyBakarot: this.monthlyBakarot,
      monthlyTikufim: this.monthlyTikufim,
      monthlyKnasot: this.monthlyKnasot,
    );
    this.history[DateFormat.yMMMd()
            .format(DateTime(DateTime.now().year, DateTime.now().month, 1))] =
        HistoryData(
      monthlyBakarot: this.monthlyBakarot,
      monthlyTikufim: this.monthlyTikufim,
      monthlyKnasot: this.monthlyKnasot,
      bakarotGoal: this.bakarotGoal,
      tikufimGoal: this.tikufimGoal,
      knasotGoal: this.knasotGoal,
    );
    notifyListeners();
  }

  void addGoal(int bakarotGoal, int tikufimGoal, int knasotGoal) {
    this.bakarotGoal = bakarotGoal;
    this.tikufimGoal = tikufimGoal;
    this.knasotGoal = knasotGoal;
    notifyListeners();
  }

  void reset() {
    var dateUtility = DateUtil();
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    for (int i = 1; i <= dateUtility.daysInMonth(month, year); i++) {
      if (history[DateFormat.yMd().format(DateTime(year, month, i))] != null) {
        history[DateFormat.yMd().format(DateTime(year, month, i))] = null;
      }
    }
    history[DateFormat.yMMMd()
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1))] = null;
    monthlyBakarot = 0;
    monthlyTikufim = 0;
    monthlyKnasot = 0;
    notifyListeners();
  }

  void saveData() {
    data['monthlyBakarot'] = monthlyBakarot;
    data['monthlyTikufim'] = monthlyTikufim;
    data['monthlyKnasot'] = monthlyKnasot;
    data['bakarotGoal'] = bakarotGoal;
    data['tikufimGoal'] = tikufimGoal;
    data['knasotGoal'] = knasotGoal;
  }

  void fromJson(Map<String, dynamic> json, Map<String, dynamic> data) {
    json.forEach((key, value) {
      history.putIfAbsent(
          key,
          () => HistoryData(
              monthlyBakarot: value['monthlyBakarot'],
              monthlyTikufim: value['monthlyTikufim'],
              monthlyKnasot: value['monthlyKnasot'],
              bakarotGoal: value['bakarotGoal'],
              tikufimGoal: value['tikufimGoal'],
              knasotGoal: value['knasotGoal']));
    });
    monthlyBakarot = data['monthlyBakarot'];
    monthlyTikufim = data['monthlyTikufim'];
    monthlyKnasot = data['monthlyKnasot'];
    bakarotGoal = data['bakarotGoal'];
    tikufimGoal = data['tikufimGoal'];
    knasotGoal = data['knasotGoal'];
    notifyListeners();
  }
}
