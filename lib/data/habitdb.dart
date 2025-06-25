import 'package:habits/datatime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("HabitDB");

class HabitDB {
  List todaysHabitsList = [];

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
  }
}
