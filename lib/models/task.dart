class Task {
  int id;
  String title;
  String description;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
    );
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
    };
  }
}