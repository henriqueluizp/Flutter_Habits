import 'package:habits/datatime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("HabitDB");

class HabitDB {
  List todaysHabitsList = [];
  Map<DateTime, int> heatMapDataSet = {};

  DateTime selectedDate = DateTime.now();

  void createDefaultDB() {
    _myBox.put("CURRENT_HABIT_LIST", []);

    DateTime initialStartDate = DateTime.now().subtract(const Duration(days: 365));
    _myBox.put("START_DATE", convertDateTimeToString(initialStartDate));

  }

  void loadDB(DateTime date) {
    selectedDate = date;
    String formattedDate = convertDateTimeToString(date);

    var habitsForThisDate = _myBox.get(formattedDate);

    if (habitsForThisDate == null) {
      todaysHabitsList = [];
      updateDB();
    } else {
      todaysHabitsList = List.from(habitsForThisDate);
    }
    List masterHabitList = _myBox.get("CURRENT_HABIT_LIST") ?? [];
    todaysHabitsList.removeWhere((habit) {
      String habitName = habit[0];
      return !masterHabitList.any((mHabit) => mHabit[0] == habitName);
    });
    updateDB();

    loadHeatMap();
  }

  void updateDB() {
    _myBox.put(convertDateTimeToString(selectedDate), todaysHabitsList);
    List existingMasterHabits = _myBox.get("CURRENT_HABIT_LIST") ?? [];
    List updatedMasterList = List.from(existingMasterHabits);

    for (var habitInTodayList in todaysHabitsList) {
      String habitName = habitInTodayList[0];
      String creationDateString = habitInTodayList.length > 2 ? habitInTodayList[2] : convertDateTimeToString(selectedDate);

      int existingIndex = updatedMasterList.indexWhere((h) => h[0] == habitName);
      if (existingIndex == -1) {
        updatedMasterList.add([habitName, false, creationDateString]);
      } else {
        if (updatedMasterList[existingIndex].length < 3) {
          updatedMasterList[existingIndex].add(creationDateString);
        }
      }
    }
    _myBox.put("CURRENT_HABIT_LIST", updatedMasterList);

    recalculateAllPercentages();
    loadHeatMap();
  }

  void addHabit(String name) {
    todaysHabitsList.add([name, false, convertDateTimeToString(selectedDate)]);
    updateDB();
  }

  void deleteHabit(int index) {
    String habitName = todaysHabitsList[index][0];
    todaysHabitsList.removeAt(index);

    List masterList = _myBox.get("CURRENT_HABIT_LIST") ?? [];
    masterList.removeWhere((habit) => habit[0] == habitName);
    _myBox.put("CURRENT_HABIT_LIST", masterList);

    for (var key in _myBox.keys) {
      if (key.startsWith("2")) {
        var dailyHabits = _myBox.get(key) as List?;
        if (dailyHabits != null) {
          dailyHabits.removeWhere((habit) => habit[0] == habitName);
          _myBox.put(key, dailyHabits);
          calculateHabitPercentagesForSpecificDate(createDateTimeObject(key));
        }
      }
    }

    recalculateAllPercentages();
    loadHeatMap();
  }

  void editHabit(int index, String newName) {
    String oldName = todaysHabitsList[index][0];
    todaysHabitsList[index][0] = newName;
    updateDB();

    List masterList = _myBox.get("CURRENT_HABIT_LIST") ?? [];
    for (int i = 0; i < masterList.length; i++) {
      if (masterList[i][0] == oldName) {
        masterList[i][0] = newName;
        break;
      }
    }
    _myBox.put("CURRENT_HABIT_LIST", masterList);

    for (var key in _myBox.keys) {
      if (key.startsWith("2")) {
        var dailyHabits = _myBox.get(key) as List?;
        if (dailyHabits != null) {
          int habitIndexInDailyList = dailyHabits.indexWhere((h) => h[0] == oldName);
          if (habitIndexInDailyList != -1) {
            dailyHabits[habitIndexInDailyList][0] = newName;
            _myBox.put(key, dailyHabits);
          }
        }
      }
    }
  }

  void recalculateAllPercentages() {
    heatMapDataSet = {};
    DateTime startDate = createDateTimeObject(_myBox.get('START_DATE'));
    DateTime currentDate = DateTime.now();

    for (DateTime d = startDate; d.isBefore(currentDate.add(const Duration(days: 1))); d = d.add(const Duration(days: 1))) {
      calculateHabitPercentagesForSpecificDate(d);
    }
    loadHeatMap();
  }

  void calculateHabitPercentagesForSpecificDate(DateTime date) {
    String yyyymmdd = convertDateTimeToString(date);
    var habitsForThisDate = _myBox.get(yyyymmdd) as List?;

    int countCompleted = 0;
    int totalHabitsForDay = 0;

    if (habitsForThisDate != null && habitsForThisDate.isNotEmpty) {
      totalHabitsForDay = habitsForThisDate.length;
      for (var habit in habitsForThisDate) {
        if (habit[1] == true) {
          countCompleted++;
        }
      }
    }

    String percentage = totalHabitsForDay == 0 ? '0.0' : (countCompleted / totalHabitsForDay).toStringAsFixed(1);
    _myBox.put('PERCENTAGE_SUMMARY_$yyyymmdd', percentage);
  }

  void loadHeatMap() {
    heatMapDataSet = {};

    DateTime startDate = createDateTimeObject(_myBox.get('START_DATE'));
    DateTime currentDate = DateTime.now();

    for (DateTime d = startDate; d.isBefore(currentDate.add(const Duration(days: 1))); d = d.add(const Duration(days: 1))) {
      DateTime normalizedDate = DateTime(d.year, d.month, d.day);
      String yyyymmdd = convertDateTimeToString(normalizedDate);

      double strengthAsPercentage = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int strength = (10 * strengthAsPercentage).toInt();
      heatMapDataSet[normalizedDate] = strength;
    }
  }
}