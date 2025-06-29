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
    this.isInteractionDisabled = false,
  });

  final String name;
  final bool isCompleted;
  final Function(bool?)? onChange;
  final Function(BuildContext)? settingClick;
  final Function(BuildContext)? deleteClick;
  final bool isInteractionDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Slidable(
        useTextDirection: true,
        endActionPane: isInteractionDisabled
            ? null
            : ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            foregroundColor: Colors.white,
            onPressed: settingClick,
            backgroundColor: Colors.grey.shade500,
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color.fromRGBO(66, 66, 66, 1.0), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: onChange,
                activeColor: const Color.fromARGB(255, 2, 179, 8),
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color.fromARGB(255, 2, 179, 8);
                  }
                  if (isInteractionDisabled) {
                    return Colors.grey.shade700;
                  }
                  return Colors.white;
                }),
                checkColor: Colors.white,
              ),
              Text(
                name,
                style: TextStyle(
                  color: isInteractionDisabled ? Colors.grey.shade500 : Colors.white,
                  fontSize: 18,
                  decoration: isCompleted && !isInteractionDisabled ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: isCompleted && !isInteractionDisabled ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}