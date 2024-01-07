import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'dart:convert';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Create a new group:'),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createGroup(context);
              },
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }

  void _createGroup(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final String? token = await authProvider.getToken();

    // Valide se os campos são preenchidos corretamente
    if (name.isEmpty || description.isEmpty) {
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
      Uri.parse('${Constants.apiUrl}/group'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'name': name, 'description': description}),
    );

    if (response.statusCode == 200) {
      // Lógica adicional se necessário após a criação do grupo
      print('Group created successfully');
      // Limpe os controladores após a criação do grupo
      _nameController.clear();
      _descriptionController.clear();
      // Navegue para a tela desejada após a criação do grupo
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Trate o caso em que a criação do grupo falhou
      print('Failed to create group');
    }
  }
}
