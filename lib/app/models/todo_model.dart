// models/task_model.dart
class ToDoModel {
  String id;
  String title;
  String description;
  DateTime createDate;
  DateTime dueDate;
  int priority; // 1 = High, 2 = Medium, 3 = Low
  bool isCompleted;

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createDate,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'createDate': createDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'priority': priority,
    'isCompleted': isCompleted,
  };

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    createDate: DateTime.parse(json['createDate']),
    dueDate: DateTime.parse(json['dueDate']),
    priority: json['priority'],
    isCompleted: json['isCompleted'],
  );
}
