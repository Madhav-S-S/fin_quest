import 'package:fin_quest/home.dart';
import 'package:fin_quest/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
      routes: {
        '/home': (context) => Home(),
      },
    );
  }
}
