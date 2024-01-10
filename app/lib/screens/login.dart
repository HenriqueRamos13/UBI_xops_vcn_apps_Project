import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/auth.dart';
import '../constants/colors.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          color: stBGColor,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60),
              Image.asset(
                'assets/images/logo.png',
                height: 200,
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'snap',
                        style: TextStyle(
                          color: stLightPurple,
                          fontSize: 40,
                          fontWeight: FontWeight.normal,
                        )),
                    TextSpan(
                      text: 'Task',
                      style: TextStyle(
                        color: stDarkerPurple,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  color: stGrey,
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authProvider.login(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    print('Erro durante o login: $e');
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: stLightPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Registar'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: stDarkerPurple,
                  backgroundColor: Colors.transparent,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: stBGColor,
    elevation: 0,
    //title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    //  Icon(
    //    Icons.menu,
    //    color: stBlack,
    //    size: 30,
    //  ),
    //  Container(
    //    height: 40,
    //    width: 40,
    //    child: ClipRRect(
    //      child: Image.asset('assets/images/verifica.png'),
    //    ),
    //  ),
    //]),
  );
}
