import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/register.dart';
import '../screens/login.dart';
import '../screens/home.dart';
import '../providers/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //root
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'snapTask',
        //theme: ThemeData,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, __) {
            return authProvider.isAuthenticated ? Home() : Login();
          },
        ),
        routes: {
          '/register': (context) => Register(),
          '/login': (context) => Login(),
          '/home': (context) => authMiddleware(context, Home()),
        },
      ),
    );
  }

  Widget authMiddleware(BuildContext context, Widget page) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isAuthenticated ? page : Login();
  }
}
