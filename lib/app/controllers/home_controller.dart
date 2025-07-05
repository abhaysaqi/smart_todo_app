import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_todo_app/app/models/todo_model.dart';
import 'package:smart_todo_app/app/services/notification_service.dart';

class HomeController extends GetxController {
  final todos = <ToDoModel>[].obs;
  final storage = GetStorage();
  var sortBy = 'createdAt'.obs;

  @override
  void onInit() {
    super.onInit();
    loadtodos();
  }

  void addTodo(ToDoModel todo) {
    todos.add(todo);
    savetodos();
    NotificationHelper.scheduleNotification(
      id: todo.id.hashCode, // 🔑 Use unique id (int)
      title: todo.title,
      body: "Your task '${todo.title}' is due soon!",
      scheduledDate: todo.dueDate.subtract(const Duration(days: 1)), // ⏰ DateTime when notification should fire
    );
  }

  void updatetodo(ToDoModel updatedtodo) async {
    final index = todos.indexWhere((todo) => todo.id == updatedtodo.id);

    if (index != -1) {
      todos[index] = updatedtodo;
      savetodos();
      await NotificationHelper.cancelNotification(updatedtodo.id.hashCode);
      NotificationHelper.scheduleNotification(
        id: updatedtodo.id.hashCode,
        title: updatedtodo.title,
        body: "Reminder: '${updatedtodo.title}' is due!",
        scheduledDate: updatedtodo.dueDate.subtract(const Duration(days: 1)),
      );
    }
  }

  void deleteToDo(String id) {
    todos.removeWhere((todo) => todo.id == id);
    savetodos();
    NotificationHelper.cancelNotification(id.hashCode);
  }

  void savetodos() {
    storage.write('todos', todos.map((e) => e.toJson()).toList());
  }

  void loadtodos() {
    final storedtodos = storage.read<List>('todos') ?? [];
    todos.assignAll(storedtodos.map((e) => ToDoModel.fromJson(e)).toList());
    sortTodos();
  }

  List<ToDoModel> searchTodos(String query) {
    return todos
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void sortTodos() {
    if (sortBy.value == 'dueDate') {
      todos.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (sortBy.value == 'priority') {
      todos.sort((a, b) => a.priority.compareTo(b.priority));
    } else {
      todos.sort((a, b) => a.createDate.compareTo(b.createDate));
    }
  }
}
