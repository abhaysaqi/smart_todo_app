import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
        appBar: AppBar(title: const Text("Tasks")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                      onChanged: (val) => _con.searchTodos(val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.sort, color: Colors.black87),
                      offset: const Offset(0, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final todos = _con.todos;
                return todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.task_outlined, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text("No tasks yet", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: todos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final todo = todos[index];
                          String formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(todo.dueDate);
                          
                          Color priorityColor = Colors.grey;
                          if (todo.priority == 1) {
                            priorityColor = Colors.red.shade400;
                          } else if (todo.priority == 2) {
                            priorityColor = Colors.orange.shade400;
                          } else if (todo.priority == 3) {
                            priorityColor = Colors.green.shade400;
                          }

                          return InkWell(
                            onTap: () => Get.to(() => AddEditToDoScreen(todo: todo)),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4, right: 16),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: priorityColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          todo.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Due: $formattedDate",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.black54),
                                    onPressed: () => Get.dialog(
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: const Text("Delete Task"),
                                        content: const Text("Are you sure you want to delete this task?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                            onPressed: () => Get.back(),
                                          ),
                                          TextButton(
                                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                            onPressed: () {
                                              _con.deleteToDo(todo.id);
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
