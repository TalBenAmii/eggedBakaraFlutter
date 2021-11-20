import 'package:egged_bakara/models/history_data.dart';
import 'package:egged_bakara/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef OnDateSelected = void Function(DateTime);

class CalendarTimeline extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate selectableDayPredicate;
  final OnDateSelected onDateSelected;
  final double leftMargin;
  final Color dayColor;
  final Color activeDayColor;
  final Color activeBackgroundDayColor;
  final Color monthColor;
  final Color dotsColor;
  final Color dayNameColor;
  final String locale;
  final bool monthGoal;
  final Map<String, HistoryData> history;

  final bool showYears;

  CalendarTimeline({
    Key key,
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
    @required this.onDateSelected,
    @required this.monthGoal,
    this.selectableDayPredicate,
    this.leftMargin = 0,
    this.dayColor,
    this.activeDayColor,
    this.activeBackgroundDayColor,
    this.monthColor,
    this.dotsColor,
    this.dayNameColor,
    this.locale,
    this.showYears = false,
    @required this.history,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(
          initialDate.difference(firstDate).inDays >= 0,
          'initialDate must be on or after firstDate',
        ),
        assert(
          !initialDate.isAfter(lastDate),
          'initialDate must be on or before lastDate',
        ),
        assert(
          !firstDate.isAfter(lastDate),
          'lastDate must be on or after firstDate',
        ),
        assert(
          selectableDayPredicate == null || selectableDayPredicate(initialDate),
          'Provided initialDate must satisfy provided selectableDayPredicate',
        ),
        assert(
          locale == null || dateTimeSymbolMap().containsKey(locale),
          'Provided locale value doesn\'t exist',
        ),
        super(key: key);

  @override
  _CalendarTimelineState createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline> {
  final ItemScrollController _controllerYear = ItemScrollController();
  final ItemScrollController _controllerMonth = ItemScrollController();
  final ItemScrollController _controllerDay = ItemScrollController();

  int _yearSelectedIndex;
  int _monthSelectedIndex;
  int _daySelectedIndex;
  double _scrollAlignment;

  List<DateTime> _years = [];
  List<DateTime> _months = [];
  List<DateTime> _days = [];
  DateTime _selectedDate;
  bool init = true, initMonth = true;

  String get _locale =>
      widget.locale ?? Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    _initCalendar();
    _scrollAlignment = widget.leftMargin / 440;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initializeDateFormatting(_locale);
    });
  }

  @override
  void didUpdateWidget(CalendarTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCalendar();
    if (widget.showYears) _moveToYearIndex(_yearSelectedIndex);
    _moveToMonthIndex(_monthSelectedIndex);
    if (!widget.monthGoal) _moveToDayIndex(_daySelectedIndex);
  }

  void reset() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showYears) _buildYearList(),
        _buildMonthList(),
        if (!widget.monthGoal) _buildDayList(),
      ],
    );
  }

  SizedBox _buildDayList() {
    return SizedBox(
      height: 75,
      child: ScrollablePositionedList.builder(
        itemScrollController: _controllerDay,
        initialScrollIndex: _daySelectedIndex,
        initialAlignment: _scrollAlignment,
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        padding: EdgeInsets.only(left: widget.leftMargin, right: 10),
        itemBuilder: (BuildContext context, int index) {
          final List<String> dayNames = [
            'ראשון',
            'שני',
            'שלישי',
            'רביעי',
            'חמישי',
            'שישי',
            'שבת'
          ];
          final currentDay = _days[index];
          final shortName = dayNames[index % 7];
          return Row(
            children: <Widget>[
              _DayItem(
                history: widget.history,
                currentDate: currentDay,
                initDay: init,
                isSelected: _daySelectedIndex == index,
                dayNumber: currentDay.day,
                shortName: shortName,
                onTap: () {
                  init = false;
                  _goToActualDay(index);
                },
                available: widget.selectableDayPredicate == null
                    ? true
                    : widget.selectableDayPredicate(currentDay),
                dayColor: widget.dayColor,
                activeDayColor: init
                    ? Theme.of(context).accentColor
                    : widget.activeDayColor,
                activeDayBackgroundColor: widget.activeBackgroundDayColor,
                dotsColor: widget.dotsColor,
                dayNameColor: widget.dayNameColor,
              ),
              if (index == _days.length - 1)
                SizedBox(width: WIDTH - widget.leftMargin - 65)
            ],
          );
        },
      ),
    );
  }

  Widget _buildMonthList() {
    return Container(
      height: 40,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: _monthSelectedIndex,
        initialAlignment: _scrollAlignment,
        itemScrollController: _controllerMonth,
        padding: EdgeInsets.only(left: widget.leftMargin),
        scrollDirection: Axis.horizontal,
        itemCount: _months.length,
        itemBuilder: (BuildContext context, int index) {
          List<String> monthsName = [
            'ינואר',
            'פברואר',
            'מרץ',
            'אפריל',
            'מאי',
            'יוני',
            'יולי',
            'אוגוסט',
            'ספטמבר',
            'אוקטובר',
            'נובמבר',
            'דצמבר'
          ];
          final currentDate = _months[index];
          final monthName = monthsName[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.firstDate.year != currentDate.year &&
                    currentDate.month == 1 &&
                    !widget.showYears)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: YearName(
                      name: DateFormat.y(_locale).format(currentDate),
                      color: widget.monthColor,
                    ),
                  ),
                MonthName(
                  initMonth: initMonth,
                  monthGoal: widget.monthGoal,
                  isSelected: _monthSelectedIndex == index,
                  name: monthName,
                  onTap: () {
                    if (widget.monthGoal) initMonth = false;
                    _goToActualMonth(index);
                  },
                  color: widget.monthColor,
                ),
                if (index == _months.length - 1)
                  SizedBox(
                    width: WIDTH - widget.leftMargin - (monthName.length * 10),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearList() {
    return Container(
      height: 40,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: _yearSelectedIndex,
        initialAlignment: _scrollAlignment,
        itemScrollController: _controllerYear,
        padding: EdgeInsets.only(left: widget.leftMargin),
        scrollDirection: Axis.horizontal,
        itemCount: _years.length,
        itemBuilder: (BuildContext context, int index) {
          final currentDate = _years[index];
          final yearName = DateFormat.y(_locale).format(currentDate);

          return Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                YearName(
                  isSelected: _yearSelectedIndex == index,
                  name: yearName,
                  onTap: () => _goToActualYear(index),
                  color: widget.monthColor,
                  small: true,
                ),
                if (index == _years.length - 1)
                  SizedBox(
                    width: WIDTH - widget.leftMargin - (yearName.length * 10),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  _generateDays(DateTime selectedDate) {
    _days.clear();
    for (var i = 1; i <= 31; i++) {
      final day = DateTime(selectedDate.year, selectedDate.month, i);
      if (day.difference(widget.firstDate).inDays < 0) continue;
      if (day.month != selectedDate.month || day.isAfter(widget.lastDate))
        break;
      _days.add(day);
    }
  }

  _generateMonths(DateTime selectedDate) {
    _months.clear();
    if (widget.showYears) {
      int month = selectedDate.year == widget.firstDate.year
          ? widget.firstDate.month
          : 1;
      DateTime date = DateTime(selectedDate.year, month);
      while (date.isBefore(DateTime(selectedDate.year + 1)) &&
          date.isBefore(widget.lastDate)) {
        _months.add(date);
        date = DateTime(date.year, date.month + 1);
      }
    } else {
      DateTime date = DateTime(widget.firstDate.year, widget.firstDate.month);
      while (date.isBefore(widget.lastDate)) {
        _months.add(date);
        date = DateTime(date.year, date.month + 1);
      }
    }
  }

  _generateYears() {
    _years.clear();
    DateTime date = widget.firstDate;
    while (date.isBefore(widget.lastDate)) {
      _years.add(date);
      date = DateTime(date.year + 1);
    }
  }

  _resetCalendar(DateTime date) {
    if (widget.showYears) _generateMonths(date);
    _generateDays(date);
    _daySelectedIndex = date.month == _selectedDate.month
        ? _days.indexOf(
            _days.firstWhere((dayDate) => dayDate.day == _selectedDate.day))
        : null;
    if (!widget.monthGoal)
      _controllerDay.scrollTo(
        index: DateTime.now().day - 1 ?? 0,
        alignment: _scrollAlignment,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
  }

  _goToActualYear(int index) {
    _moveToYearIndex(index);
    _yearSelectedIndex = index;
    _resetCalendar(_years[index]);
    setState(() {});
  }

  void _moveToYearIndex(int index) {
    _controllerYear.scrollTo(
      index: index,
      alignment: _scrollAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  _goToActualMonth(int index) {
    _moveToMonthIndex(index);
    _monthSelectedIndex = index;
    _resetCalendar(_months[index]);
    if (widget.monthGoal)
      widget.onDateSelected(DateTime(
        DateTime.now().year,
        index + 1,
      ));

    setState(() {});
  }

  void _moveToMonthIndex(int index) {
    _controllerMonth.scrollTo(
      index: index,
      alignment: _scrollAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  _goToActualDay(int index) {
    _moveToDayIndex(index);
    _daySelectedIndex = index;
    _selectedDate = _days[index];
    widget.onDateSelected(_selectedDate);
    setState(() {});
  }

  void _moveToDayIndex(int index) {
    _controllerDay.scrollTo(
      index: index,
      alignment: _scrollAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  selectedYear() {
    _yearSelectedIndex = _years.indexOf(_years
        .firstWhere((yearDate) => yearDate.year == widget.initialDate.year));
  }

  selectedMonth() {
    if (widget.showYears)
      _monthSelectedIndex = _months.indexOf(_months.firstWhere(
          (monthDate) => monthDate.month == widget.initialDate.month));
    else
      _monthSelectedIndex = _months.indexOf(_months.firstWhere((monthDate) =>
          monthDate.year == widget.initialDate.year &&
          monthDate.month == widget.initialDate.month));
  }

  selectedDay() {
    _daySelectedIndex = _days.indexOf(
        _days.firstWhere((dayDate) => dayDate.day == widget.initialDate.day));
  }

  _initCalendar() {
    _selectedDate = widget.initialDate;
    _generateMonths(_selectedDate);
    _generateDays(_selectedDate);
    if (widget.showYears) {
      _generateYears();
      selectedYear();
    }
    selectedMonth();
    selectedDay();
  }
}

class YearName extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color color;
  final bool small;

  YearName(
      {this.name,
      this.onTap,
      this.isSelected = false,
      this.color,
      this.small = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: small ? null : onTap,
      child: Container(
        decoration: isSelected || small
            ? BoxDecoration(
                border: Border.all(color: color ?? Colors.black87, width: 1),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
          child: Text(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class MonthName extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color color;
  final bool monthGoal;
  final bool initMonth;
  MonthName(
      {this.name,
      this.onTap,
      this.isSelected,
      this.color,
      this.monthGoal,
      this.initMonth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        decoration: BoxDecoration(
            color: this.isSelected && !initMonth && this.monthGoal
                ? Colors.redAccent[200]
                : Colors.transparent,
            borderRadius: new BorderRadius.all(
              const Radius.circular(20.0),
            )),
        padding: const EdgeInsets.all(8),
        child: Text(
          this.name,
          style: TextStyle(
            height: this.isSelected && this.monthGoal
                ? 0.85
                : this.monthGoal
                    ? 0.96
                    : this.isSelected
                        ? 1.05
                        : 1.3,
            fontSize: this.monthGoal
                ? this.isSelected
                    ? 34
                    : 30
                : this.isSelected
                    ? 26
                    : 20,
            color: this.isSelected
                ? Theme.of(context).accentColor
                : color ?? Colors.black87,
            fontWeight: this.isSelected ? FontWeight.bold : FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;
  final Color dayColor;
  final Color activeDayColor;
  final Color activeDayBackgroundColor;
  final bool available;
  final Color dotsColor;
  final Color dayNameColor;
  final DateTime currentDate;
  final Map<String, HistoryData> history;
  final bool initDay;

  _DayItem(
      {Key key,
      @required this.dayNumber,
      @required this.shortName,
      @required this.isSelected,
      @required this.onTap,
      @required this.currentDate,
      @required this.history,
      this.dayColor,
      this.activeDayColor,
      this.activeDayBackgroundColor,
      this.available = true,
      this.dotsColor,
      this.dayNameColor,
      this.initDay})
      : super(key: key);

  final double height = 70.0;
  final double width = 60.0;

  _buildDay(BuildContext context) {
    final textStyle = TextStyle(
        color: available
            ? dayColor ?? Theme.of(context).accentColor
            : dayColor?.withOpacity(0.5) ??
                Theme.of(context).accentColor.withOpacity(0.5),
        fontSize: 32,
        fontWeight: FontWeight.normal,
        height: 1.2);
    final selectedStyle = TextStyle(
        color: activeDayColor ?? Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: initDay && history[DateFormat.yMd().format(currentDate)] == null
            ? 1
            : 0.75);

    return GestureDetector(
      onTap: available ? onTap : null,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: initDay
                    ? Colors.transparent
                    : activeDayBackgroundColor ?? Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(12.0),
              )
            : BoxDecoration(color: Colors.transparent),
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            if (isSelected ||
                history[DateFormat.yMd().format(currentDate)] != null) ...[
              SizedBox(height: 7),
              _buildDots(),
              SizedBox(height: 12),
            ] else
              SizedBox(height: 14),
            Text(
              dayNumber.toString(),
              style: isSelected
                  ? selectedStyle
                  : history[DateFormat.yMd().format(currentDate)] != null
                      ? textStyle.copyWith(height: 0.75)
                      : textStyle,
            ),
            if (isSelected && initDay != true)
              Text(
                shortName,
                style: TextStyle(
                  color: dayNameColor ?? activeDayColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    final dot = Container(
      height: 4,
      width: 4,
      decoration: new BoxDecoration(
        color: this.dotsColor ?? this.activeDayColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
    );
    final historyDot = Container(
      height: 6,
      width: 6,
      decoration: new BoxDecoration(
        color: Colors.green.shade800 ?? this.activeDayColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
    );
    return history[DateFormat.yMd().format(currentDate)] != null &&
            isSelected &&
            !initDay
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [dot, historyDot, dot])
        : isSelected && !initDay
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [dot, dot])
            : history[DateFormat.yMd().format(currentDate)] != null
                ? Row(
                    children: [historyDot],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  )
                : Row();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDay(context);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }
}
