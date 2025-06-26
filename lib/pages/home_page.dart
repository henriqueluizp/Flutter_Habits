import 'package:flutter/material.dart';
import 'package:habits/components/habit_tile.dart';
import 'package:habits/components/habit_element.dart';
import 'package:habits/components/heatmap_habits.dart';
import 'package:habits/data/habitdb.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDB db = HabitDB();
  final _myBox = Hive.box("HabitDB");

  late DateTime _selectedCalendarDate;

  final _newHabitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedCalendarDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultDB();
    }

    db.selectedDate = _selectedCalendarDate;
    db.loadDB(_selectedCalendarDate);
  }

  void checkBoxToggle(bool? value, int index) {
    setState(() {
      db.todaysHabitsList[index][1] = value;
    });
    db.updateDB();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return HabitElement(
          controller: _newHabitNameController,
          onSave: () {
            db.addHabit(_newHabitNameController.text);
            _newHabitNameController.clear();
            Navigator.pop(context);
            setState(() {
              db.loadDB(_selectedCalendarDate);
            });
          },
          onCancel: () {
            _newHabitNameController.clear();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void habitSetting(int index) {
    showDialog(
      context: context,
      builder: (context) {
        _newHabitNameController.text = db.todaysHabitsList[index][0];
        return HabitElement(
          controller: _newHabitNameController,
          onSave: () {
            db.editHabit(index, _newHabitNameController.text);
            _newHabitNameController.clear();
            Navigator.pop(context);
            setState(() {});
          },
          onCancel: () {
            _newHabitNameController.clear();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void habitDelete(int index) {
    db.deleteHabit(index);
    setState(() {
      db.loadDB(_selectedCalendarDate);
    });
  }

  void onCalendarDateSelected(DateTime date) {
    setState(() {
      _selectedCalendarDate = date;
      db.loadDB(_selectedCalendarDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime todayNormalized = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime selectedDateNormalized =
        DateTime(_selectedCalendarDate.year, _selectedCalendarDate.month, _selectedCalendarDate.day);

    bool isFutureOrTodaySelected =
        selectedDateNormalized.isAfter(todayNormalized) || selectedDateNormalized.isAtSameMomentAs(todayNormalized);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: const TextTheme(),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        body: ListView(
          children: [
            HeatmapHabits(
              dataset: db.heatMapDataSet,
              startDate: _myBox.get('START_DATE'),
              onDateSelected: onCalendarDateSelected,
              selectedCalendarDate: _selectedCalendarDate,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabitsList.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    name: db.todaysHabitsList[index][0],
                    isCompleted: db.todaysHabitsList[index][1],
                    onChange: (value) {
                      if (isFutureOrTodaySelected) {
                        checkBoxToggle(value, index);
                      }
                    },
                    settingClick: (context) {
                      if (isFutureOrTodaySelected) {
                        habitSetting(index);
                      }
                    },
                    deleteClick: (context) {
                      if (isFutureOrTodaySelected) {
                        habitDelete(index);
                      }
                    },
                  );
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: isFutureOrTodaySelected ? createNewHabit : null,
          backgroundColor: isFutureOrTodaySelected ? const Color.fromARGB(255, 2, 179, 8) : Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
