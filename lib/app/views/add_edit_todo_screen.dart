import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_todo_app/app/controllers/add_edit_todo_controller.dart';
import 'package:smart_todo_app/app/controllers/home_controller.dart';
import 'package:smart_todo_app/app/models/todo_model.dart';

class AddEditToDoScreen extends StatelessWidget {
  final AddEditTodoController _con = Get.put(AddEditTodoController());
  final HomeController _homeCon = Get.find();
  final ToDoModel? todo;

  AddEditToDoScreen({super.key, this.todo}) {
    if (todo != null) {
      _con.titleController.text = todo!.title;
      _con.descriptionController.text = todo!.description;
      _con.selectedDate.value = todo!.dueDate;
      _con.priority.value = todo!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(todo != null ? 'Edit task' : 'New task')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _con.formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _con.titleController,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Title required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  minLines: 3,
                  maxLines: 8,
                  textAlign: TextAlign.start,
                  controller: _con.descriptionController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => DropdownButtonFormField<int>(
                    initialValue:
                        _con.priority.value == 0 ? null : _con.priority.value,
                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text(
                          'High Priority',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text(
                          'Medium Priority',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text(
                          'Low Priority',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) _con.priority.value = val;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                    hint: const Text('Set Priority'),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final date = _con.selectedDate.value;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(color: Colors.grey.shade200),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _con.pickDate(context),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            date != null
                                ? DateFormat(
                                  'MMMM d, yyyy • h:mm a',
                                ).format(date)
                                : "Select Due Date & Time",
                            style: TextStyle(
                              fontSize: 15,
                              color:
                                  date != null
                                      ? Colors.black
                                      : Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_con.formKey.currentState!.validate() &&
                        _con.selectedDate.value != null) {
                      final newtodo = ToDoModel(
                        id: todo?.id ?? Random().nextInt(99999).toString(),
                        title: _con.titleController.text,
                        description: _con.descriptionController.text,
                        createDate: DateTime.timestamp(),
                        dueDate: _con.selectedDate.value!,
                        priority: _con.priority.value,
                        isCompleted: todo?.isCompleted ?? false,
                      );
                      todo == null
                          ? _homeCon.addTodo(newtodo)
                          : _homeCon.updatetodo(newtodo);
                      Get.back();
                    } else if (_con.selectedDate.value == null) {
                      Get.snackbar(
                        'Required',
                        'Please select a due date',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Text(todo != null ? 'Update Task' : 'Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
