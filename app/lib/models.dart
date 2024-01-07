class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Task {
  final String id;
  final String name;
  final String? description;
  final String status;
  final bool completed;
  final User owner;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.completed,
    required this.owner,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      completed: json['completed'],
      owner: User.fromJson(json['owner']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Group {
  final String id;
  final String name;
  final String description;
  final List<Task> tasks;
  final User owner;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.tasks,
    required this.owner,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      tasks:
          (json['tasks'] as List).map((task) => Task.fromJson(task)).toList(),
      owner: User.fromJson(json['owner']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
