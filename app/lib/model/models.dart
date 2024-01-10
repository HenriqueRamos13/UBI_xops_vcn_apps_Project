class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}

class TaskModel {
  final String id;
  final String name;
  final String? description;
  final String status;
  final bool completed;
  final String owner;

  TaskModel({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.completed,
    required this.owner,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      status: json['status'] ?? '',
      completed: json['completed'] ?? false,
      owner: json['owner'] ?? '',
    );
  }
}
