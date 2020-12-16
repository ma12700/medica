import 'package:firebase_database/firebase_database.dart';
import 'auth.dart';

class QuizData {
  static List<String> questions = [];
  static List<String> answers = [];
  static List<String> diseases = [];
  static Map<int, dynamic> answersOfDiseses = {};

  static Future<bool> fetchQuiz() async {
    try {
      await Auth.database
          .child('questions')
          .once()
          .then((DataSnapshot snapshot) {
        var data = snapshot.value;
        for (var q in data) {
          questions.add(q);
        }
      });
      await Auth.database.child('answers').once().then((DataSnapshot snapshot) {
        var data = snapshot.value;
        for (var ans in data) {
          answers.add(ans);
        }
      });
      await Auth.database
          .child('diseases')
          .once()
          .then((DataSnapshot snapshot) {
        var data = snapshot.value;
        var i = 0;
        for (var id in data.keys) {
          diseases.add(id);
          answersOfDiseses[i] = data[id];
          i++;
        }
      });
    } catch (error) {
      print(error.toString());
    }
    return true;
  }
}
