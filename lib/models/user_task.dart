class UserTask {
  int? id;
  int? userId;
  String title;
  String description;
  bool isDone;

  UserTask({
    this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.isDone,
  });

  UserTask copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return UserTask(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // Include the userId in the toMap method
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory UserTask.fromMap(Map<String, dynamic> map) {
    return UserTask(
      id: map['id'],
      userId: map['userId'], // Include the userId in the factory constructor
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
    );
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'userId': userId, // Include the userId in the toMapWithoutId method
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
    };
  }
}
