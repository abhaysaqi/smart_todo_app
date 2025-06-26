import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_todo_app/app/controllers/add_edit_todo_controller.dart';
import 'package:smart_todo_app/app/controllers/home_controller.dart';
import 'package:smart_todo_app/app/models/todo_model.dart';
import 'package:smart_todo_app/app/widgets/background.dart';

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
        appBar: AppBar(title: Text(todo != null ? 'Edit todo' : 'Add todo')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _con.formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _con.titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator:
                      (value) => value!.isEmpty ? 'Title required' : null,
                ),
                SizedBox(height: 5),
                TextFormField(
                  minLines: 2,
                  maxLines: 5,
                  textAlign: TextAlign.start,
                  controller: _con.descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 5),

                Obx(
                  () => DropdownButtonFormField<int>(
                    value:
                        _con.priority.value == 0 ? null : _con.priority.value,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('High')),
                      DropdownMenuItem(value: 2, child: Text('Medium')),
                      DropdownMenuItem(value: 3, child: Text('Low')),
                    ],
                    onChanged: (val) {
                      if (val != null) _con.priority.value = val;
                    },
                    decoration: const InputDecoration(labelText: 'Priority'),
                    hint: const Text('Select Priority'),
                  ),
                ),

                const SizedBox(height: 16),
                Obx(() {
                  final date = _con.selectedDate.value;
                  return date != null
                      ? GestureDetector(
                        onTap: () => _con.pickDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.teal,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Due Date: ${DateFormat('d MMMM y').format(date)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_calendar,
                                  color: Colors.teal,
                                ),
                                onPressed: () => _con.pickDate(context),
                              ),
                            ],
                          ),
                        ),
                      )
                      : ElevatedButton.icon(
                        onPressed: () => _con.pickDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Select Due Date'),
                      );
                }),
                const SizedBox(height: 20),
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
                    }
                  },
                  child: Text(todo != null ? 'Update' : 'Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
