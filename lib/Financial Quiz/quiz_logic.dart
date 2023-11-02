import 'package:cloud_firestore/cloud_firestore.dart';

class QuizLogic {
  final CollectionReference questions = FirebaseFirestore.instance.collection('question_bank');

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    QuerySnapshot querySnapshot = await questions.get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
