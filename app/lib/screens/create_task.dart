import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class CreateTaskScreen extends StatefulWidget {
  final String groupId;

  CreateTaskScreen({required this.groupId});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Create a new task:'),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createTask(context);
              },
              child: Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _createTask(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final String? token = await authProvider.getToken();

    // Valide se os campos são preenchidos corretamente
    if (name.isEmpty) {
      // Adicione uma lógica para lidar com campos vazios, se necessário
      return;
    }

    // Valide se o token está presente
    if (token == null) {
      // Adicione uma lógica para lidar com a ausência do token, se necessário
      return;
    }

    // Faça a requisição com o token no cabeçalho
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/task/${widget.groupId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'name': name, 'description': description}),
    );

    if (response.statusCode == 200) {
      // Lógica adicional se necessário após a criação da tarefa
      print('Task created successfully');
      // Limpe os controladores após a criação da tarefa
      _nameController.clear();
      _descriptionController.clear();
      // Navegue para a tela desejada após a criação da tarefa
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Trate o caso em que a criação da tarefa falhou
      print('Failed to create task');
    }
  }
}
