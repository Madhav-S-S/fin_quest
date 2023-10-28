import 'package:fin_quest/home.dart';
import 'package:fin_quest/login.dart';
import 'package:fin_quest/snake_game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}
