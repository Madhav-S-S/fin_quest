
import 'package:fin_quest/home.dart';
import 'package:fin_quest/login.dart';
import 'package:fin_quest/SnakeGame/snake_game.dart';
import 'package:fin_quest/pool_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Financial Quiz/quiz.dart';
import 'SnakeGame/room_page.dart';

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
      home: QuizPage(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}
