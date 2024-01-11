import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../model/models.dart';
import '../providers/auth.dart';
import '../widgets/task.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _taskController = TextEditingController();
  final authProvider = AuthProvider();

  List<TaskModel> _taskList = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkAuthentication();
    _getTasks();
  }

  Future<void> _getTasks() async {
    try {
      final token = await authProvider.getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/task'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _taskList = data.map((task) => TaskModel.fromJson(task)).toList();
        });
      } else {
        // Handle errors
      }
    } catch (error) {
      // Handle errors
    }
  }

  Future<void> _addTask(String task) async {
    try {
      final token = await authProvider.getToken();
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/task'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': task}),
      );

      if (response.statusCode == 200) {
        print('Task added');
        _getTasks();
        _taskController.clear();
      } else {
        print('Task not added');
        // Handle errors
      }
    } catch (error) {
      print('Task error');
      // Handle errors
    }
  }

  Future<void> _handleTaskChange(TaskModel todo) async {
    try {
      final token = await authProvider.getToken();
      final response = await http.patch(
        Uri.parse('${Constants.apiUrl}/task/${todo.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'completed': !todo.completed}),
      );

      if (response.statusCode == 200) {
        _getTasks();
      } else {
        // Handle errors
      }
    } catch (error) {
      // Handle errors
    }
  }

  Future<void> _deleteTask(String id) async {
    try {
      final token = await authProvider.getToken();
      final response = await http.delete(
        Uri.parse('${Constants.apiUrl}/task/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _getTasks();
      } else {
        // Handle errors
      }
    } catch (error) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: stBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                _searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'Todas as tarefas',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (TaskModel todo in _taskList) _buildTaskItem(todo),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Adicionar nova tarefa',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      _addTask(_taskController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: stLightPurple,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskModel todo) {
    return Task(
      todo: todo,
      onTaskChanged: _handleTaskChange,
      onTaskDeleted: _deleteTask,
    );
  }

  Widget _searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _searchTask(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: stBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Pesquisar',
          hintStyle: TextStyle(color: stGrey),
        ),
      ),
    );
  }

  void _searchTask(String string) {
    if (string.isEmpty) {
      setState(() {
        _taskList =
            _taskList; // Reset para a lista completa se a pesquisa estiver vazia
      });
    } else {
      final results = _taskList
          .where(
              (task) => task.name.toLowerCase().contains(string.toLowerCase()))
          .toList();

      setState(() {
        _taskList = results;
      });
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 100,
      title: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: 'snap',
                style: TextStyle(
                  color: stLightPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            TextSpan(
              text: 'Task',
              style: TextStyle(
                color: stDarkerPurple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        //'snapTask',
        //tyle: TextStyle(fontSize: 43, fontWeight: FontWeight.w500),
      ),
      backgroundColor: stBGColor,
      elevation: 0,
      foregroundColor: stDarkerPurple,
      leading: IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: () async {
          await authProvider.logout(context);
        },
      ),
    );
  }
}
