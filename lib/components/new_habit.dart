import 'package:flutter/material.dart';

class NewHabit extends StatelessWidget {
  const NewHabit({
    super.key,
    this.controller,
    required this.onSave,
    required this.onCancel,
  });

  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          onPressed: onCancel,
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          onPressed: onSave,
          child: const Text(
            "Salvar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
