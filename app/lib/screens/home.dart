import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:app/models.dart';
import 'dart:convert';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Group> _groups;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? token = await authProvider.getToken();

    // Valide se o token está presente
    if (token == null) {
      // Adicione uma lógica para lidar com a ausência do token, se necessário
      return;
    }

    // Faça a requisição com o token no cabeçalho
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/group'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Converta a resposta JSON para uma lista de grupos
      final List<dynamic> data = jsonDecode(response.body);
      final List<Group> groups =
          data.map((group) => Group.fromJson(group)).toList();

      setState(() {
        _groups = groups;
      });
    } else {
      // Trate o caso em que a obtenção dos grupos falhou
      print('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: _groups != null
          ? ListView.builder(
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                final int totalTasks = group.tasks.length;
                final int completedTasks =
                    group.tasks.where((task) => task.completed).length;
                final double percentageCompleted =
                    totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

                return ListTile(
                  title: Text(group.name),
                  subtitle: Text(
                      'Total tasks: $totalTasks, Completed: $completedTasks, % Completed: ${percentageCompleted.toStringAsFixed(2)}%'),
                  onTap: () {
                    // Navegar para a página do grupo passando o ID do grupo
                    Navigator.pushNamed(
                      context,
                      '/group',
                      arguments: {'groupId': group.id},
                    );
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
