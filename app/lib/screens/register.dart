import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/auth.dart';
import '../constants/colors.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registo'),
        backgroundColor: stBGColor,
        foregroundColor: stDarkerPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: stBGColor,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
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
                'Bem vindo! Crie uma conta para começar.',
                style: TextStyle(
                  fontSize: 17,
                  color: stGrey,
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              SizedBox(height: 10),
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
                    await authProvider.register(
                      context,
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                    // Após o registro, redirecione para a tela de login
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (e) {
                    print('Erro durante o registro: $e');
                  }
                },
                child: Text('Registrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: stDarkerPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Redirecione para a tela de login
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Já tem uma conta? Faça ',
                        style: TextStyle(
                          color: stGrey,
                        ),
                      ),
                      TextSpan(
                        text: 'login.',
                        style: TextStyle(
                          color: stLightPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 55),
            ],
          ),
        ),
      ),
    );
  }
}
