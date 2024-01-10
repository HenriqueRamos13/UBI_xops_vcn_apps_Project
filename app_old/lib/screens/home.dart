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
  late List<Group> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? token = await authProvider.getToken();

    try {
      // Valide se o token está presente
      if (token == null) {
        // Adicione uma lógica para lidar com a ausência do token, se necessário
        return;
      }

      print('token: $token');

      // Faça a requisição com o token no cabeçalho
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/group'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.body);

      if (response.statusCode == 200) {
        // Converta a resposta JSON para uma lista de grupos
        final List<dynamic> data = jsonDecode(response.body);

        print('Type of data: ${data.runtimeType}');
        if (data is List) {
          final List<Group> groups =
              data.map((group) => Group.fromJson(group)).toList();

          setState(() {
            _groups = groups;
            _isLoading = false; // Atualize o estado do carregamento
          });
        } else {
          // Trate o caso em que a resposta não é uma lista válida
          print('Invalid response format');
        }

        if (data is List) {
          try {
            final List<Group> groups = data.map((group) {
              try {
                return Group.fromJson(group);
              } catch (e) {
                print('Error mapping group: $e');
                return Group(
                  id: '',
                  name: 'Invalid Group',
                  description: '',
                  tasks: [],
                  owner: User(
                    id: '',
                    name: '',
                    email: '',
                    password: '',
                  ),
                );
              }
            }).toList();

            setState(() {
              _groups = groups;
              _isLoading = false; // Atualize o estado do carregamento
            });
          } catch (e) {
            print('Error mapping groups: $e');
            // Trate o caso em que a obtenção dos grupos falhou
            setState(() {
              _isLoading =
                  false; // Atualize o estado do carregamento em caso de erro
            });
          }
        } else {
          // Trate o caso em que a resposta não é uma lista válida
          print('Invalid response format');
        }
      } else {
        // Trate o caso em que a obtenção dos grupos falhou
        print('Failed to load groups');
      }
    } catch (error) {
      print('Error loading groups: $error');
      // Trate o erro conforme necessário
      setState(() {
        _isLoading = false; // Atualize o estado do carregamento em caso de erro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        automaticallyImplyLeading: false, // Remova o botão de voltar
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Adicionar lógica para recarregar os grupos manualmente
              _loadGroups();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _groups.isNotEmpty
              ? ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    final int totalTasks = group.tasks.length;
                    final int completedTasks =
                        group.tasks.where((task) => task.completed).length;
                    final double percentageCompleted = totalTasks > 0
                        ? (completedTasks / totalTasks) * 100
                        : 0;

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
                  child: Text('No groups available'),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicionar lógica para criar um novo grupo
          // Por exemplo, navegar para a tela de criação de grupo
          Navigator.pushNamed(context, '/create_group');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
