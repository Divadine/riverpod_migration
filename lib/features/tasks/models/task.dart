enum Priority { low, medium, high }

class Task {
  final String id;
  final String title;
  final Priority priority;
  final bool isDone;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.priority,
    this.isDone = false,
    required this.createdAt,
  });

  Task copyWith({String? title, Priority? priority, bool? isDone}) {
    return Task(
        id: id,
        title: title ?? this.title,
        priority: priority ?? this.priority,
        isDone: isDone ?? this.isDone,
        createdAt: createdAt
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    priority: Priority.values.byName(json['priority'] as String),
    isDone: json['isDone'] as bool,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'priority': priority.name,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
  };
}