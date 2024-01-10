class User {
  final String id;
  final String name;
  final String email;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}

class Task {
  final String id;
  final String name;
  final String? description;
  final String status;
  final bool completed;
  final String
      owner; // Alterado para String assumindo que é a referência ao id do usuário

  Task({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.completed,
    required this.owner,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      status: json['status'] ?? '',
      completed: json['completed'] ?? false,
      owner: json['owner'] ?? '',
    );
  }
}

class Group {
  final String id;
  final String name;
  final String description;
  final List<Task> tasks;
  final User owner;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.tasks,
    required this.owner,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      tasks:
          (json['tasks'] as List).map((task) => Task.fromJson(task)).toList(),
      owner: json['owner'] is String
          ? User(id: json['owner'], name: '', email: '', password: '')
          : User.fromJson(json['owner']),
    );
  }
}
