import 'package:habits/datatime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("HabitDB");

class HabitDB {
  List todaysHabitsList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void createDefaultDB() {
    todaysHabitsList = [
      ["New Habit", true],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  void loadDB() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitsList = _myBox.get("CURRENT_HABIT_LIST");

      for (int i = 0; i < todaysHabitsList.length; i++) {
        todaysHabitsList[i][1] = false;
      }
    } else {
      todaysHabitsList = _myBox.get(todaysDateFormatted());
    }
  }

  void updateDB() {
    _myBox.put(todaysDateFormatted(), todaysHabitsList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitsList);
    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitsList.length; i++) {
      if (todaysHabitsList[i][1] == true) {
        countCompleted++;
      }
    }

    String percentage = todaysHabitsList.isEmpty ? '0.0' : (countCompleted / todaysHabitsList.length).toStringAsFixed(1);
    _myBox.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percentage);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get('START_DATE'));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercentage = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercentage).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
