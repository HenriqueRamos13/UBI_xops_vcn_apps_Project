import 'package:flutter/material.dart';
import '../constants/colors.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  const NoInternetConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupa toda a largura disponível
      height: double.infinity, // Ocupa toda a altura disponível
      color: stBGColor, // Define a cor de fundo, se desejar
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sem conexão com a internet',
              style: TextStyle(
                color: stBlack,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            // Se necessário, adicione aqui outros elementos que você queira exibir
          ],
        ),
      ),
    );
  }
}
