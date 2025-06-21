import 'package:flutter/material.dart';
import 'package:habits/components/floating_button.dart';
import 'package:habits/components/habit_tile.dart';
import 'package:habits/components/new_habit.dart';

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

  final _newHabitController = TextEditingController();

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return NewHabit(
            controller: _newHabitController,
            onSave: saveNewHabit,
            onCancel: cancelNewHabit,
          );
        });
  }

  void saveNewHabit() {
    setState(() {
      entityList.add([_newHabitController.text, false]);
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
  }

  void cancelNewHabit() {
    _newHabitController.clear();
    Navigator.of(context).pop();
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
                });
          }),
      floatingActionButton: FloatingButton(onPressed: createNewHabit),
    );
  }
}
