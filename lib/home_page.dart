import 'package:flutter/material.dart';
import 'package:flutter_application_2/grades_page.dart';
import 'calendar_page.dart';
import 'frequency_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), // Redireciona para a tela de login
      );
    } catch (e) {
      print('Erro ao fazer logout: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Principal'), actions: [
        // Botão de logout
        IconButton(
            icon: const Icon(Icons.logout), onPressed: () => _logout(context)),
      ]),
      //],
      //),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Logo do aplicativo
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/atten_logo.png',
              height: 150,
            ),
          ),
          // Botões
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FrequencyScreen()),
              );
            },
            child: const Text('Frequência'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GradesScreen()),
              );
            },
            child: const Text('Notas'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
            child: const Text('Calendário Acadêmico'),
          ),
        ],
      ),
    );
  }
}
