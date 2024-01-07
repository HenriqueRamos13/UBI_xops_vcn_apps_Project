import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/group.dart';
import 'screens/create_group.dart';
import 'screens/create_task.dart';
import 'screens/task.dart';
import 'providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isAuthenticated ? HomeScreen() : LoginScreen();
          },
        ),
        routes: {
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/group': (context) => authMiddleware(context, GroupScreen()),
          '/create_group': (context) =>
              authMiddleware(context, CreateGroupScreen()),
          '/create_task': (context) {
            final Map<String, dynamic>? args = ModalRoute.of(context)
                ?.settings
                .arguments as Map<String, dynamic>?;

            final String groupId =
                args?['groupId'] ?? ''; // ou qualquer lógica que você precise
            return authMiddleware(context, CreateTaskScreen(groupId: groupId));
          },
          // '/profile': (context) => authMiddleware(context, ProfileScreen()),
          '/task': (context) {
            final Map<String, dynamic>? args = ModalRoute.of(context)
                ?.settings
                .arguments as Map<String, dynamic>?;

            final String taskId =
                args?['taskId'] ?? ''; // ou qualquer lógica que você precise
            return authMiddleware(context, TaskScreen(taskId: taskId));
          },
        },
      ),
    );
  }

  Widget authMiddleware(BuildContext context, Widget page) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isAuthenticated ? page : LoginScreen();
  }
}
