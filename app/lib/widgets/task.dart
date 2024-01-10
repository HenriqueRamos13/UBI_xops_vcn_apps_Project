import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/models.dart';

class Task extends StatelessWidget {
  final TaskModel todo;
  final onTaskChanged;
  final onTaskDeleted;

  const Task(
      {Key? key,
      required this.todo,
      required this.onTaskChanged,
      required this.onTaskDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          //print('click');
          onTaskChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: stLightPurple,
        ),
        title: Text(
          todo.name,
          style: TextStyle(
            fontSize: 16,
            color: stBlack,
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: stRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              //print('click');
              onTaskDeleted(todo.id);
            },
          ),
        ),
      ),
    );
  }
}
