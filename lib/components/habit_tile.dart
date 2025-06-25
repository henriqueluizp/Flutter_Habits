import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.name,
    required this.isCompleted,
    required this.onChange,
    required this.settingClick,
    required this.deleteClick,
  });

  final String name;
  final bool isCompleted;
  final Function(bool?)? onChange;
  final Function(BuildContext)? settingClick;
  final Function(BuildContext)? deleteClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: settingClick,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: deleteClick,
            backgroundColor: Colors.red.shade400,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Checkbox(value: isCompleted, onChanged: onChange),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
