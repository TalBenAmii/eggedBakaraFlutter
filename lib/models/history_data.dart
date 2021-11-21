class HistoryData {
  int monthlyBakarot,
      monthlyTikufim,
      monthlyKnasot,
      bakarotGoal,
      tikufimGoal,
      knasotGoal,
      bakarotAdded,
      tikufimAdded,
      knasotAdded;
  HistoryData({
    this.monthlyBakarot = 0,
    this.monthlyTikufim = 0,
    this.monthlyKnasot = 0,
    this.bakarotGoal = 0,
    this.tikufimGoal = 0,
    this.knasotGoal = 0,
    this.bakarotAdded = 0,
    this.tikufimAdded = 0,
    this.knasotAdded = 0,
  });

  void updateChangedData(int bakarot, int tikufim, int knasot) {
    this.bakarotAdded += bakarot;
    this.tikufimAdded += tikufim;
    this.knasotAdded += knasot;
  }
}
