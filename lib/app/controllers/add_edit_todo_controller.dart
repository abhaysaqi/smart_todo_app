import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditTodoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedDate = Rxn<DateTime>();
  final priority = 0.obs;

  void pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      if (!context.mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate.value ?? DateTime.now()),
      );
      if (pickedTime != null) {
        selectedDate.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      } else {
        selectedDate.value = pickedDate; // Keep date if time is cancelled
      }
    }
  }
}
