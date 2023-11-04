import 'package:fin_quest/SnakeGame/room_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class QuizPage extends StatefulWidget {
  final String customerId;
  QuizPage({required this.customerId, Key? key}) : super(key: key);
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
            onPressed: () async {
                  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.customerId)
                      .get();

                  if (userSnapshot.exists) {
                    dynamic currentPool = userSnapshot.get('currentPool');
                    dynamic currentRoom = userSnapshot.get('currentRoom');

                    if (currentPool != null && currentRoom != null) {
                      String pool = currentPool.toString();
                      String room = currentRoom.toString();
                      await FirebaseFirestore.instance
                          .collection('$pool' + '_rooms')
                          .doc(room)
                          .collection('player_data')
                          .doc(widget.customerId)
                          .update({'score': score});

                      await FirebaseFirestore.instance
                          .collection('$pool' + '_rooms')
                          .doc(room)
                          .collection('player_data')
                          .doc(widget.customerId)
                          .update({'game_over': true});
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RoomPage(customerId: widget.customerId,gameName: 'Financial Quiz',),
                        ),
                      );
                    } else {

                    }
                  } else {
                    
                  }
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
            colors: [Colors.blue, Colors.purple], 
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
                        itemBuilder: (context, index) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color.fromARGB(255, 66, 132, 186), const Color.fromARGB(255, 243, 177, 33)], // Adjust the colors as needed
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 142, 33, 243),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: GestureDetector(
                                onTap: () => handleOptionSelection(index),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
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
