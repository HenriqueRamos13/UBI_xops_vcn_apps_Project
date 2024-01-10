import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:app/models.dart';
import 'dart:convert';
import '../constants.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late Group _group = Group(
    id: '',
    name: '',
    description: '',
    tasks: [],
    owner: User(
      id: '',
      name: '',
      email: '',
      password: '',
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadGroup();
  }

  Future<void> _loadGroup() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? token = await authProvider.getToken();

    // Valide se o token está presente
    if (token == null) {
      // Adicione uma lógica para lidar com a ausência do token, se necessário
      return;
    }

    // Pegue o ID do grupo passado como argumento
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('groupId')) {
      final String groupId = args['groupId'];

      // Faça a requisição com o token no cabeçalho e o ID do grupo
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/group/$groupId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Converta a resposta JSON para um objeto Group
        final dynamic data = jsonDecode(response.body);
        final Group group = Group.fromJson(data);

        setState(() {
          _group = group;
        });
      } else {
        // Trate o caso em que a obtenção do grupo falhou
        print('Failed to load group');
      }
    }
  }

  Future<void> _navigateToTask(String taskId) async {
    final result = await Navigator.pushNamed(
      context,
      '/task',
      arguments: {'taskId': taskId},
    );

    // Se desejar, você pode lidar com o resultado retornado pela página da tarefa aqui.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_group?.name ?? 'Group'),
      ),
      body: _group != null
          ? ListView.builder(
              itemCount: _group.tasks.length,
              itemBuilder: (context, index) {
                final task = _group.tasks[index];

                return ListTile(
                  title: Text(task.name),
                  subtitle: Text(
                      'Status: ${task.status}, Completed: ${task.completed}'),
                  onTap: () {
                    _navigateToTask(task.id);
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_task',
              arguments: {'groupId': _group.id});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
