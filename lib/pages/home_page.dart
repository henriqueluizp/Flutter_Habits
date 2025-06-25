import 'package:flutter/material.dart';
import 'package:habits/components/floating_button.dart';
import 'package:habits/components/habit_tile.dart';
import 'package:habits/components/habit_element.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List entityList = [
    ["Teste 1", false],
    ["Teste 2", false],
  ];

  void checkBoxToggle(bool? value, int index) {
    setState(() {
      entityList[index][1] = value;
    });
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
      entityList.add([_habitController.text, false]);
    });
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
      entityList[index][0] = _habitController.text;
    });
    _habitController.clear();
    Navigator.of(context).pop();
  }

  void habitDelete(int index){
    setState(() {
      entityList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
          itemCount: entityList.length,
          itemBuilder: (context, index) {
            return HabitTile(
                name: entityList[index][0],
                isCompleted: entityList[index][1],
                onChange: (value) {
                  checkBoxToggle(value, index);
                },
                settingClick: (context) => habitSetting(index),
              deleteClick: (context) => habitDelete(index),
            );
          }),
      floatingActionButton: FloatingButton(onPressed: createNewHabit),
    );
  }
}

