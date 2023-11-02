import 'package:fin_quest/Financial%20Quiz/quiz_logic.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int questionsAsked = 0; // Keep track of the number of questions asked
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestionsFromFirestore();
  }

  Future<void> fetchQuestionsFromFirestore() async {
    final quizLogic = QuizLogic();
    final fetchedQuestions = await quizLogic.fetchQuestions();
    setState(() {
      questions = fetchedQuestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz App'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questionsAsked >= 10) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Quiz Completed! Your Score: $score'),
              ElevatedButton(
                onPressed: () {
                  // Restart the quiz or navigate to the home screen
                },
                child: Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(questions[currentQuestionIndex]['question']),
            for (var i = 0; i < questions[currentQuestionIndex]['options'].length; i++)
              ElevatedButton(
                onPressed: () {
                  if (i == questions[currentQuestionIndex]['correctAns']) {
                    setState(() {
                      score++;
                    });
                  }
                  setState(() {
                    questionsAsked++; // Increment the count of questions asked
                    currentQuestionIndex++;
                  });
                },
                child: Text(questions[currentQuestionIndex]['options'][i]),
              ),
          ],
        ),
      ),
    );
  }
}
