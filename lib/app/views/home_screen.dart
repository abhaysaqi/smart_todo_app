import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_todo_app/app/controllers/home_controller.dart';
import 'package:smart_todo_app/app/views/add_edit_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _con = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("ToDo List")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search tasks...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => _con.searchTodos(val),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.sort, color: Colors.black),
                    onSelected: (val) {
                      _con.sortBy(val);
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'createdAt',
                            child: Text("Creation Date"),
                          ),
                          const PopupMenuItem(
                            value: 'dueDate',
                            child: Text("Due Date"),
                          ),
                          const PopupMenuItem(
                            value: 'priority',
                            child: Text("Priority"),
                          ),
                        ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final todos = _con.todos;
                return todos.isEmpty
                    ? Center(child: Text("Todo List is Empty"))
                    : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (_, index) {
                        final todo = todos[index];
                        return Card(
                          child: ListTile(
                            title: Text(todo.title),
                            subtitle: Text("${todo.dueDate.toLocal()}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed:
                                  () => Get.dialog(
                                    AlertDialog(
                                      title: const Text("Delete Task"),
                                      content: const Text(
                                        "Are you sure you want to delete this task? This action cannot be undone.",
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () => Get.back(),
                                        ),
                                        TextButton(
                                          child: const Text("OK"),
                                          onPressed: () {
                                            _con.deleteToDo(todo.id);
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                    barrierDismissible: false,
                                  ),
                            ),
                            onTap:
                                () =>
                                    Get.to(() => AddEditToDoScreen(todo: todo)),
                          ),
                        );
                      },
                    );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => AddEditToDoScreen()),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
