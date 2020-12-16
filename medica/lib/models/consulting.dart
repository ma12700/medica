import 'package:firebase_database/firebase_database.dart';
import 'auth.dart';

class Consulting {
  String id;
  final String specialty;
  final int age;
  final String content;
  final String time;
  String answer;

  Consulting(
      this.id, this.specialty, this.age, this.content, this.answer, this.time);
}

class ConsultingData {
  static List<String> specialties = [];
  static List<Consulting> consultingsData = [];

  static Future<bool> fetchSpecialties() async {
    try {
      await Auth.database
          .child('specialties')
          .once()
          .then((DataSnapshot snapshot) {
        var data = snapshot.value;
        for (var spec in data) {
          specialties.add(spec);
        }
      });
    } catch (error) {
      print("error is here: " + error.toString());
    }
    return true;
  }

  static Future<bool> fetchconsultingsData() async {
    if (specialties.isEmpty) {
      await fetchSpecialties();
    }
    try {
      for (var spec in specialties) {
        await Auth.database
            .child('specialty/$spec/consultation/${Auth.userId}')
            .once()
            .then((DataSnapshot snapshot) {
          var data = snapshot.value;
          if (data != null) {
            for (var id in data.keys) {
              var ans = data[id]['answer'] == null ? "" : data[id]['answer'];
              if (data[id]['answer'] == null) {}
              consultingsData.add(Consulting(id, spec, data[id]['age'],
                  data[id]['content'], ans, data[id]['time']));
            }
          }
        });
      }
      if (consultingsData.isNotEmpty) {
        consultingsData.sort((a, b) {
          if (DateTime.parse(a.time).isBefore(DateTime.parse(b.time))) {
            return 1;
          }
          return -1;
        });
      }
    } catch (error) {
      print("fetch error is here: " + error.toString());
    }
    return true;
  }

  static Future<bool> addconsultings(Consulting consulting) async {
    try {
      DatabaseReference rootRef = Auth.database.child(
          'specialty/${consulting.specialty}/consultation/${Auth.userId}');
      String newkey = rootRef.push().key;
      print(consulting);
      print(newkey);
      await rootRef.child(newkey).set({
        'age': consulting.age,
        'content': consulting.content,
        'time': consulting.time,
      });
      consulting.id = newkey;
      consultingsData.insert(0, consulting);
    } catch (error) {
      print('add consulting error:' + error.toString());
    }
    return true;
  }

  static Future<bool> deleteConsultings(String specialty, String id) async {
    try {
      await Auth.database
          .child('specialty/$specialty/consultation/${Auth.userId}/$id')
          .remove();
    } catch (error) {
      print('delete consulting error:' + error.toString());
    }
    return true;
  }
}
