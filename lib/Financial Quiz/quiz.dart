import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  void fetchQuestions() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('question_bank').get();
    final allQuestions = querySnapshot.docs.map((doc) => doc.data()).toList();
    allQuestions.shuffle();
    questions = allQuestions.take(10).toList();
    setState(() {});
  }

  void handleOptionSelection(int selectedOptionIndex) {
    String feedbackMessage;
    if (questions != null &&
        questions[currentQuestionIndex] != null &&
        questions[currentQuestionIndex]['correctAns'] != null &&
        questions[currentQuestionIndex]['correctAns'] == selectedOptionIndex) {
      score++;
      feedbackMessage = "Correct!";
    } else {
      feedbackMessage = "Incorrect!";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(feedbackMessage),
        duration: Duration(seconds: 2),
      ),
    );

    if (currentQuestionIndex < 9) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      showQuizResult();
    }
  }

  void showQuizResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Result'),
        content: Text('Score: $score/10'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple], // Adjust the colors as needed
          ),
        ),
        child: Center(
          child: questions.isEmpty
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          child: Text(
                            'Question ${currentQuestionIndex + 1}: ${questions != null && questions[currentQuestionIndex] != null ? questions[currentQuestionIndex]['question'] : ''}',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            title: GestureDetector(
                              onTap: () => handleOptionSelection(index),
                              child: Text(
                                questions != null &&
                                    questions[currentQuestionIndex] != null &&
                                    questions[currentQuestionIndex]['options'] != null
                                    ? questions[currentQuestionIndex]['options'][index]
                                    : '',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
