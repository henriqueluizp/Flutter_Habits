import 'package:flutter/material.dart';
import 'package:habits/components/floating_button.dart';
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

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultDB();
    } else {
      db.loadDB();
    }

    db.updateDB();
    super.initState();
  }

  void checkBoxToggle(bool? value, int index) {
    setState(() {
      db.todaysHabitsList[index][1] = value;
    });
    db.updateDB();
  }

  final _habitController = TextEditingController();

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return HabitElement(
            controller: _habitController,
            onSave: saveNewHabit,
            onCancel: cancelHabit,
          );
        });
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitsList.add([_habitController.text, false]);
    });
    db.updateDB();
    _habitController.clear();
    Navigator.of(context).pop();
  }

  void cancelHabit() {
    _habitController.clear();
    Navigator.of(context).pop();
  }

  void habitSetting(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return HabitElement(
            controller: _habitController,
            onSave: () => editHabit(index),
            onCancel: cancelHabit,
          );
        });
  }

  void editHabit(int index) {
    setState(() {
      db.todaysHabitsList[index][0] = _habitController.text;
    });
    db.updateDB();
    _habitController.clear();
    Navigator.of(context).pop();
  }

  void habitDelete(int index) {
    setState(() {
      db.todaysHabitsList.removeAt(index);
    });
    db.updateDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          HeatmapHabits(dataset: db.heatMapDataSet, startDate: _myBox.get('START_DATE')),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.todaysHabitsList.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  name: db.todaysHabitsList[index][0],
                  isCompleted: db.todaysHabitsList[index][1],
                  onChange: (value) {
                    checkBoxToggle(value, index);
                  },
                  settingClick: (context) => habitSetting(index),
                  deleteClick: (context) => habitDelete(index),
                );
              }),
        ],
      ),
      floatingActionButton: FloatingButton(onPressed: createNewHabit),
    );
  }
}
