import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatelessWidget {
  final String taskId;

  TaskScreen({required this.taskId});

  Future<Task> _fetchTaskDetails(BuildContext context) async {
    final String apiUrl = '${Constants.apiUrl}/task/$taskId';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? token = await authProvider.getToken();

    if (token == null) {
      // Tratar o caso em que o token está ausente, se necessário
      throw Exception('Token not available');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Failed to load task details');
    }
  }

  void _completeTask(BuildContext context, String taskId) async {
    final String apiUrl = '${Constants.apiUrl}/task/$taskId';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? token = await authProvider.getToken();

    if (token == null) {
      // Tratar o caso em que o token está ausente, se necessário
      print('Token not available');
      return;
    }

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': 'DONE', 'completed': true}),
    );

    if (response.statusCode == 200) {
      // Tarefa marcada como concluída com sucesso
      // Adicione lógica adicional, se necessário
    } else {
      // Tratar falha ao concluir a tarefa
      print('Failed to complete task');
    }
  }

  void _deleteTask(BuildContext context, String taskId) async {
    final String apiUrl = '${Constants.apiUrl}/task/$taskId';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? token = await authProvider.getToken();

    if (token == null) {
      // Tratar o caso em que o token está ausente, se necessário
      print('Token not available');
      return;
    }

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Tarefa excluída com sucesso
      // Adicione lógica adicional, se necessário
    } else {
      // Tratar falha ao excluir a tarefa
      print('Failed to delete task');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: FutureBuilder<Task>(
        future: _fetchTaskDetails(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load task details'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Task not found'));
          } else {
            final Task task = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(task.name),
                  subtitle: Text('Description: ${task.description ?? 'N/A'}'),
                ),
                ListTile(
                  title: Text('Status: ${task.status}'),
                  subtitle: Text('Completed: ${task.completed}'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _completeTask(context, taskId);
                      },
                      child: Text('Complete'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteTask(context, taskId);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
